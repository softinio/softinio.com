+++
title =  "Migrating my markdown notes from Obsidian to Apple Notes"
date =  2024-03-03

[taxonomies]
tags = ["markdown", "obsidian", "apple", "pandoc", "bash"]
categories = [ "TIL" ]

[extra]
toc = true
keywords = ["markdown", "html", "pandoc", "obsidian", "apple notes", "bash", "migrate"]
+++

So I wanted to migrate my markdown notes from Obsidian to Apple Notes. Apple Notes did not support import from markdown. I also wanted to maintain the folder structure. 

For every file I also wanted to maintain the title of the note. I wanted to prepend the title to the HTML file so that when I import the HTML file to Apple Notes, the title is correctly set. I did this by adding the file name (without the extension) as an `h1` tag to the HTML file.

I did this using [pandoc](https://pandoc.org) and a bash script. Here is how I did it:

```bash
#!/bin/bash

SRC_DIR="/obsidian_notes"
DEST_DIR="/notes_migrated_to_html"

find "$SRC_DIR" -type f -name "*.md" | while IFS= read -r file; do
    # Compute the subdirectory path
    sub_dir="$(dirname "${file#$SRC_DIR/}")"
    # Compute the destination path
    dest_path="$DEST_DIR/$sub_dir"
    # Print the source and destination paths for logging purposes
    echo "processing: [$file] to [$dest_path]"
    # Create the destination directory structure
    mkdir -p "$dest_path"
    # Define the output HTML file path
    output_html="${dest_path}/$(basename "${file%.md}.html")"
    # Convert the Markdown file to HTML
    pandoc "$file" -o "$output_html"
    # Extract the base filename without the extension for the title
    base_name="$(basename "$file" .md)"
    # Prepend the title to the HTML file
    echo "<h1>$base_name</h1>$(cat "$output_html")" > "$output_html"
done
```

I put the above script in a file called `convert_md_to_html.sh` and made it executable using `chmod +x convert_md_to_html.sh`. Then I ran the script using `./convert_md_to_html.sh`. This script will convert all the markdown files in the `SRC_DIR` to HTML files and put them in the `DEST_DIR` while maintaining the folder structure. Then I imported the HTML files to Apple Notes using the `File -> Import to Notes` option. This worked like a charm. I was able to maintain the folder structure and the notes were imported with the correct titles.
