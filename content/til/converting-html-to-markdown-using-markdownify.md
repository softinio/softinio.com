+++
title =  "Converting HTML to Markdown using Markdownify"
date =  2023-12-26

[taxonomies]
tags = ["markdown"]
categories = [ "TIL" ]

[extra]
toc = true
keywords = ["markdown", "html", "convert", "python", "nix"]
+++

I had some HTML content that I wanted to convert to markdown.

The simplest tool I found to do this effectively was a python utility called [Markdownify](https://pypi.org/project/markdownify/).

I used Nix Shell to install it:

```bash
nix-shell -p python311Packages.markdownify
```

And to do the conversion I just did:

```bash
markdownify myfile.html > myfile.md
```

where `myfile.html` is the name of the file I wanted to convert and `myfile.md` in the name of the markdown file it got converted to.

