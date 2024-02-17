+++
title =  "Configuring Github Pages With a Custom Domain"
date =  2023-01-14T16:45:33-08:00

[taxonomies]
tags = ["github"]
categories = [ "TIL" ]

[extra]
toc = true
keywords = ["github pages"]
+++

To setup my custom domain I went through the following steps:

1. *Verify Domain:* I followed [these steps](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages) to verify. Note that this was done using my GitHub accounts settings and not the repositories settings.
2. *Configuring my subdomain:* Next I configured my subdomain to be used as my custom domain with GitHub pages by following [these steps](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-a-subdomain) which involved adding a CNAME record to my DNS settings with my domain registrar. Note that as I was using a subdomain adding a CNAME record was all that was needed (however if I was to use an apex domain, I would have needed to add A and AAAA records too pointing to GitHub's ip addresses).
3. *Add CNAME file:* You need to add a file called `CNAME` to the root of your generated static site that contains your host name only (i.e. for this site `til.softinio`). As I use Hugo, I put this in the `static` directory as when the site is created it will be put in the root. Here is an [example](https://github.com/softinio/til/blob/main/static/CNAME).
4. *Configuring GitHub Pages:* Go to your repositories settings and select pages. Enter your domain name, save it and click check. Tick the box to enforce `https`.

## Notes

- This TIL does not cover setting up GitHub actions to build and deploy your code. Here is a [sample](https://github.com/softinio/til/tree/main/.github/workflows).
- You need to have your site deployed at least once so that the `gh-pages` branch is created so that you can set the site source branch in your repositories pages settings.
- To make sure your GitHub actions is able to create the `gh-pages` branch, go to your repositories settings, then click `Actions` then `General` and under the `workflow permissions` section make sure the `read and write permissions` is selected and saved.

## References

- [Hugo Documentation for hosting on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)


