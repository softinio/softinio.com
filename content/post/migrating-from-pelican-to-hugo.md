+++
title = "Migrating from Pelican to Hugo"
date = "2015-11-29T07:16:53-05:00"
description = "In this post I will discuss the steps I took to migrate my blog from Pelican to Hugo."
toc = true
keywords = ["pelican",  "hugo",  "golang", "go", "python", "blog"]
tags = ["hugo",  "golang", "blog"]
categories = ["development"]
+++

In this post I will discuss the steps I took to migrate my blog from [Pelican](http://blog.getpelican.com/) to [Hugo](http://gohugo.io/).

## Goal

|    | Original Blog  | New Blog |
| --- | --- | --- |
| Static site generator | [Pelican](http://blog.getpelican.com/) | [Hugo](http://gohugo.io/) |
| Hosting | [Linode](https://www.linode.com/) | [Amazon S3](https://aws.amazon.com/s3/) |
| Deployment Strategy | Manual using git | Automated using [Wercker](http://wercker.com/) |
| Source Control | [bitbucket](https://bitbucket.org/) | [GitHub](https://github.com/softinio/softinio.com) |

## Installing Hugo

I do all of my development on an Apple Macbook Pro so I used homebrew to install Hugo:

```bash
brew install hugo
```

## Creating my project

Its up to you how you organize your project, but as I am a Go Language developer and Hugo is built using Go I have created a folder for this project here:

```bash
$GOPATH/src/github.com/softinio/softinio.com
```

change directory to this and in terminal run (for the rest of this blog I will assume you are in this directory):

```bash
git init
```

This will create a git repository for your project.

## Create Hugo Site

To create your new Hugo site in terminal run:

```bash
hugo new site $GOPATH/src/github.com/softinio/softinio.com
```

This will create the skeleton for your new Hugo site.

## Choosing a theme

First I headed over to the themes showcase for hugo here: [Hugo Themes](http://themes.gohugo.io/). This has screenshots and links to demo sites for each theme.

I chose [hyde-x](http://themes.gohugo.io/hyde-x/) for my blog.

Make a subdirectory called `themes` and change directory to it and clone the theme you have chosen there:

```bash
git clone https://github.com/zyro/hyde-x
```

Once this theme repo got cloned into my project I then removed its `.git` directory by changing directory into the themes root folder and removing it:

```bash
cd themes/hyde-x
rm -fr .git
```

## Configuring your project and theme

In the root of your project there is a file called `config.toml` that you need to update to configure your site. You can look at [my configuration](https://github.com/softinio/softinio.com/blob/master/config.toml) to get an idea of the things you can set. For your theme specific settings of course look at the github repo for your theme's readme for detailsi (e.g. for my chosen theme: [hyde-x documentation](https://github.com/zyro/hyde-x/blob/master/README.md)).

## Content Types, Archetypes and Front Matter

I have decided to have two content types:

- `post` for my blog posts
- `page` for my sites static pages (like my about me page).

When creating any kind of content using Hugo you must provide some meta data about it. This meta data is known as `front matter`.

For example my `front matter` for this post is:

```
+++
categories = ["python", "golang"]
date = "2015-11-29T07:16:53-05:00"
description = "In this post I will discuss the steps I took to migrate my blog from Pelican to Hugo."
keywords = ["pelican",  "hugo",  "golang", "go", "python", "blog"]
slug = "migrating-from-pelican-to-hugo"
tags = ["pelican",  "hugo",  "golang", "go", "python", "blog"]
title = "Migrating from Pelican to Hugo"

+++
```

You can get Hugo to automatically create the above front matter for you for each content type. These are called `archetypes`. If you look at the `archetypes` subdirectory of my project there are two archetypes `default.md` and `page.md`. Any content created that is of type `page` will have the contents of `page.md` added to its header. Any other content type will have the content of `default.md` added to its header.

Looking at the content of `page.md` we have:

```
+++
title = ""
slug = ""
description = ""
menu = "main"
keywords = [""]
categories = [""]
tags = [""]
+++
```

So this will be added to the top of every content of type page that I add. Of course I will have to edit this template for each content with that contents specific meta data.

The main difference between my two different content types is that the `page.md` content type has `menu = "main"` this tells hugo that this content is not a blog post and it should be added to the left column of my website below my name as a link.

## Creating Content

To create content, from the project root you call:

`hugo new <content type>/<name of new content md file>`

So to create this page I did:

`hugo new post/migrating-from-pelican-to-hugo.md`

So to migrate my blog posts from pelican to hugo I used to above command to create a post with same file name as I had in pelican, copy and pasted the contents of each file from my pelican project to my hugo project. Note that of course I did not copy the front matter of my pelican posts across. Instead I updated the hugo front matter with the same meta data as I had in pelican manually. I repeated this process for my pages too.

## Permalinks

 My permalinks structure for my old pelican based blog was:

`/blog/<slug>`

meaning to access my a post it would have URL like:

`http://www.softinio.com/blog/<slug>`

In hugo I have changed this to:

`/post/<slug>`

meaning to access my a post it would have URL like:

`http://www.softinio.com/post/<slug>`

I could have kept it the same so that the URL to my existing content moving from Pelican to Hugo would not change, but I prefered to move forward with it this way. This is a personal choice of course.

If you have a look at my `config.toml` file you will see under the `permalinks` section how I have defined my permalinks.

For more details on permalinks have a look at the [Hugo documentation on permalinks](http://gohugo.io/extras/permalinks/).

## GitHub

By this stage I had migrated all my content to hugo and had setup my site. All tested locally. So to get ready for deployment I [created a new GitHub repo](https://help.github.com/articles/create-a-repo/) for it and pushed my code to it:

To add github repo I created as my remote:

```bash
git remote add origin git@github.com:softinio/softinio.com.git
```

Commit All My work:

```bash
git commit -am "Initital version of my site"`
```

Merge the remote with my local:

```bash
git pull origin master
```

Pushed my code to GitHub:

```bash
git push origin master
```

## Creating your Amazon AWS S3 bucket

I already had an account with [Amazon AWS](http://aws.amazon.com/) so I signed in and created a S3 bucket:

- The bucket I named `www.softinio.com` and set it up for static website hosting by following this [Amazon Document](https://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html)

When I created the `www.softinio.com` bucket I also clicked `properties` and selected the `permissions` section. Here I edited the bucket policy and added:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::<domain/bucket name>/*"
        }
    ]
}
```

Of course replace `<domain/bucket name>` with your actual bucket name which for me would be `www.softinio.com`.

## Moving my domains DNS management to Amazon AWS Route 53

I then moved my domain's DNS management to [Amazon AWS Route 53 service](https://aws.amazon.com/route53/) for convenience.

I followed the steps in this [Amazon document](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/creating-migrating.html) to move my domain's DNS management.

## Creating a User on Amazon AWS to use for deployment

We need to create a user on Amazon AWS to use for deployments to the S3 bucket we created. To do this log into your Amazon AWS console and select `Identity & Access Management`, then select `Users` and then select `Create New Users`.

Give the new user a name and make note of the access keys for this user that gets generated for you.

You will need to create a policy and attach to this user. Here is a sample policy you can use:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::<domain/bucket name>",
                "arn:aws:s3:::<domain/bucket name>/*"
            ]
        }
    ]
}
```

Of course replace `<domain/bucket name>` with what you actually called your Amazon S3 bucket name.


## Automate your deployments with Wercker

Head over to [Wercker website](http://wercker.com/) and click sign up and register for an account.

Once you have your account, login and go to your settings and click git connections. Here click to connect to your GitHub account.

## Adding your application to Wercker

I followed these steps:

- Click Create to start adding your application
- Select your GitHub Repository
- Select the repository owner
- Configure Access (I chose: `werker will checkout the code without using an ssh key`)
- I chose not to have my app public

Once the app was created Wercker gave me the option to trigger a build. Decline it as we have not finished creating our app.

## Create and add wercker.yml file

In the root of my project I added a new `wercker.yml` file for my configuration of wercker:

```yaml
    box: debian
    build:
    steps:
        - arjen/hugo-build:
            version: "0.14"
            theme: hyde-x
            config: config.toml
            flags: --disableSitemap=false
    deploy:
        steps:
        - s3sync:
            source_dir: public/
            delete-removed: true
            bucket-url: $AWS_BUCKET_URL
            key-id: $AWS_ACCESS_KEY_ID
            key-secret: $AWS_SECRET_ACCESS_KEY
```

## Adding environment variables for deployment

Log back into wercker and go to your application settings. Select `Targets` and in there add 3 new variables to your deploy pipeline:

- AWS_ACCESS_KEY_ID - As provided for the user you created on Amazon AWS

- AWS_SECRET_ACCESS_KEY - As provided for the user you created on AWS

- AWS_BUCKET_URL - set this to `s3://yourdomain.com` (Note: having the `s3://` in front of your domain is very important!)


## Your first deployment

You are all set now to deploy your hugo website. Commit your changes and push to the GitHub repo you created and your website will be deployed to S3 for you automatically.

From now on when ever you make any changes to your site, as soon as you push to your GitHub repo , it will build and deploy your changes to Amazon S3.

## Conclusion

I am really enjoying using Hugo for my blog and having it deploy automatically when I push a change to GitHub. My workflow is a lot simpler now making it easier for me to write and publish my blogs.

You may ask why I moved from the Python based Pelican to Hugo, well I simply wanted to try something new. I think both Pelican and Hugo are great at what they do so you can't go wrong with either.

If I had to choose between them, I would choose Hugo for the more modern approach and excellent documentation.
