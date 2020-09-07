+++
title = "Lessons Learned From Being a ZIO Contributor"
date = 2020-09-05T12:43:34-07:00
draft = false
keywords = ["functional programming", "scala", "zio", "open source", "lambdaconf", "contributor"]
description = "Contributing to your first open source project can be daunting but is a rewarding experience. In this post I will discuss what it is like to contribute to the ZIO Scala library, what lessons were learned from this experience, and discuss how you can get started contributing to your first open source project."
tags = ["functional programming", "scala", "zio", "open source"]
categories = ["functional programming", "scala", "zio", "open source"]
lastmod = 2020-09-05T12:43:34-07:00
+++


This blog post is a companion to the [Lambdaconf 2020 Talk](https://lambdaconf.zohobackstage.com/LambdaConf2020#/tickets) I did on this topic. Video of my talk and slides will be added to this post once it is available.

## My Journey to being an Open source contributor ##

I started my programming life at the age of eleven which lead to me learning Pascal, Fortran and C Programming by the time I graduated from University. 

First half of my career was spend writing software for enterprise level companies using C, Java, Oracle DB on Unix whilst watching open source software being talked about and used. At that point in my career I had zero contact with open source with the exception of being an early Linux enthusist and desktop user. As open source grew it did start trickling into my work with time, so the next phase of my career as a software engineer was filled with using open source projects on my stack on all the projects I was working on multiple levels.

Open source was a culture shock to me, the whole concept of the someone giving up their personal time to write software that they share with the rest of the world without any direct renumeration was something I spent time trying to understand. I felt guilty that at work we use so many but don't seem to be thanking the authors in any way for using what they created. 

Wanting to understand open source more, and wanting to give back I started looking for an open source project to contribute to. I started by choosing projects I had an interest in or had used before and tried to interact with the current contributors and maintainers. As new comer to the projects I found this process difficult through no fault of each projects maintainers. As everyone are in effect volunteers, they only have a certain amount of bandwidth to contribute to their project so did not have any time or process to help new contributors on board. I then saw on reddit a project maintainer wanting a new maintainer for their open source project so I expressed an interest. To my surprise others who had nothing to do with the project started reacting in a negative way to my interest which included an arrogant rude interaction with a well known figure of that community. This friction to contribute lead me to take a step back and reconsider how I want to contribute to an open source project planning to revisit it later on.

I was learning and using [Scala](https://www.scala-lang.org/) at work for the first time and as it was a technology I had introduced I had no mentors at work to work with and hence started following key people in the Scala community and try to learn from them. One of the people I was following (whom at this point I had never met) was [John A De Goes](https://degoes.net/). Following John on twitter one day he mentioned on twitter that he is looking to start a new open source project and he is looking for contributors and he will be providing mentorship to get the project off the ground. If I remember right around 300 people replied expressing an interest when he was hoping to find 5 people 😀. This is where my journey into being a ZIO contributor began.

# Contributing to ZIO #

[ZIO](https://zio.dev) is a library for asynchronous and concurrent programming that is based on pure functional programming for the Scala programming language.

ZIO comprises of the core library itself and multipe smaller projects which either use ZIO or complement ZIO to solve different technical problems. Goal being that no matter what problems you are trying to solve, you can build a complete solution using ZIO.

The core library itself is by far the area that attracts most contributors. The velocity of new changes being merged is very high. There was a time where I was to review every single PR that would come in, not anymore. 

## Decide on a project to contribute to ##

First thing to do is to decide on a project you want to contribute too.

To get started visit [ZIO list of repositories on GitHub](https://github.com/zio) anhave a browse of the different projects. 

![ZIO Projects](https://shared.softinio.com/Screen-Recording-2020-09-05-20-02-47.gif)

Every project will have something different to offer you that will help you decide on what project is a good fit for you. Some projects have only recently started so if you are looking for something with less code to get familiar at the expense of fast changing. There are also projects that are short of contributors to consider. 

A good practice is to look at the issue tracker of the projects on GitHub and start contributing with some low hanging fruit. We do try to label `good first issues`. There are also some issues labeled `documention` which are good to start with.

Each project has an associated channel on the [ZIO Discord](https://sca.la/ziodiscord) feel free to stop by, chat with the existing contributors who will be delighted to help you get started. Open invitation get in touch with me and I will help also. 

## Starting a new ZIO Project ##

The other option is to contribute a new project to the ZIO eco-system. Think of new library that can use ZIO to solve a problem that doesn't exist or a library that extends ZIO capability. 

The best way to get started with this is to use our [ZIO giter8 seed project](https://github.com/zio/zio-project-seed.g8). To get started with your project simpy run: 

```shell-script
sbt new zio/zio-project-seed.g8
```
We have tried to standardize across all projects as much as possible on project structure, how we build our projects, what plugins and dependencies we use as base and how CI is run. By using this seed to create your project your project is conforming to this standard.

The project generated by the seed even includes a sample project website all ready with the appropriate CI configuration to deploy to GitHub pages with minimal change.

There are two options available to you when starting a new ZIO based project:

1. `ZIO Project`: Your project is added to the offical ZIO organization on GitHub and Maven. Your project will also have its own channel on the [ZIO Discord](http://sca.la/ziodiscord) as a ZIO Project.

2. `Community Project`: Your project is part of your own GitHub account/organization and maven account. You can still use [ZIO Discord](https://sca.la/ziodiscord) `#zio-users` channel for any kind of conversation you need help with your project. We want your project to succeed and make a point of being approachable. Once your project is mature we would consider creating a channel for you on our discord under the community projects section. We evaluate this on a case by case basis.

We have had multiple cases of projects starting as a community project and then being moved to the ZIO organization. There are a lot of advantages for doing this such as increased publicity leading increased adoption of your library as well as attracting more contributors to help with your project. This is one of the reasons its best to start your project with the ZIO seed as if you decide you want to do this later it will be a lot easier to move.

## Devops, infrastructure & Builds Lair ##

All our projects support both JDK Versions `8` and `11`. All projects support Scala versions `2.12.*`, `2.13.*` & `Dotty`. 

Scala `2.11.*` as needed so you will see some projects have it added some don't. If your project is new and need it added take a look at [ZIO Actors](https://github.com/zio/zio-actors) and add it to the CircleCI and SBT settings.

If you need help with anything devops, build, infrastructure like CI related issues ask in the `#devops-lair` channel on [ZIO Discord](http://sca.la/ziodiscord) for help. If necessary create an issue on the relevant repositories issue tracker on GitHub and share link in this channel on discord for feedback and help.

We use CircleCI for all our builds but we are looking at moving to GitHub Actions which is an exciting effort coming up as it will help improve our build and release process better.

All our active projects on merge to the `master` branch do an automated `snapshot` release to maven so you don't have to wait for an official release to try the latest changes. We do periodic when necessary do official releases of the projects. Releases are done by doing a GitHub release and using [semantic versioning](https://semver.org/). For details of each release see the releases tab on GitHub for the project (example: [ZIO Releases](https://github.com/zio/zio/releases)). They do include some release notes that are helpful.

## Projects Documentation sites ##

We use [mdoc](https://scalameta.org/mdoc/) to generate our documentation inconjunction with [Docusaurus](https://docusaurus.io/) (version 1.x at the time of writing though we plan to upgrade to version 2.x) for every projects documentation microsite. 

All projects have this already setup as part of the CI build. New Microsite is published when we do an official release of a project. 

We do plan on making improvements in the future where in addition to documentation being updated at the point of release for us to be able to do adhoc releases of the documentation on its own.

The core ZIO project's documentation is the only one with its own domain and is what you see when visiting <https://zio.dev>. This is hosted by a combination of using GitHub pages and [Netlify](https://www.netlify.com/).

All other projects use GitHub pages and have a GitHub pages project URL as opposed to a custom domain. 

## Contribution Etiquette and Collaboration ##

The environment to contribute to an open source project is very different than how you collaborate with colleagues at work. The biggest points to realize is everyone is in effect a volunteer giving up their time to help. They maybe in a different timezone and only have second pockets of time around their busy lives to take part.

As such working in harmony, being patient and greatful for all the help is very important. What I would like to summaries a few do's and don't that we should follow as an etiquette in order to maintain a happy and welcoming environment for all.

### Working on an issue ###

If you are interested in working on an issue, check the issue comments to make sure no one else is working on it already. If no one else is make a comment on the issue that you are working on it. 

If someone has already commented on it that they are working on it and a considerable time has passed (about a month I would say is reasonable) with no visible work on the issue being done and no PR then add a comment asking if that contributor is still working on it and wait a few days for response and if they no longer are you are welcome to comment on the issue that you will be working on it. If in doubt as in the projects discord channel.

Unfortunately, due to the general nature of open source, you may see situations that multiple contributors work on the same issue and multiple PRs get submitted. This is why it is important to try your best to communicate your intentions as well as possible to minimize this happening.

### Pull request reviewers ###

Maintainers do regularly review new Pull Request to review but if you want to bring it their attention or tag someone for review you can either look at the pull request history to see who to tag for review or discuss PR in the projects discord channel.

Each project does have a group of maintainers who care about its progress who are the ones review your work. 

In a work environment you would refer to them as project leads but its not really the same in open source. Its more the case that the maintainer has devoted a lot of their time to the project already that differentiates them from a new or an occasional contributor.

## Learning and Getting Help ##

Being a ZIO contributor is an opportunity to learn and practice. When trying to contribute don't hesitate to ask for help. All of us who have been contributing to ZIO for a while strive because we are happy to help each other and learn from each other.

When picking up an issue to work on and have any questions, ask by commenting on it or go to the projects discord channel and have a discussion about any topic that you need help with. 

We try to be a very welcoming and helpful community so we look forward to helping you succeed at contributing. 

Don't forget about the tools you have available to help you succeed: 

- GitHub issues
- [ZIO Discord](https://sca.la/ziodiscord)

### Additional Resources for Contributing ###

- [ZIO Contributor Guidelines](https://zio.dev/docs/about/about_contributing)
- [ZIO Coding Guidelines](https://zio.dev/docs/about/about_coding_guidelines)
- [ZIO Code of Conduct](https://zio.dev/docs/about/about_coc)

ZIO Code of conduct linked above does include details of the current steering committee that you can contact in case of any issues especially conduct related. 

## Lessons Learnt Contributing to ZIO ##

- Anyone can be a contributor. I used to think open source was done by a small group of elite people and not for  *regular* developers. Contributing to ZIO showed me I was wrong and really anyone can and should participate.

- Focus your library on satisfying user experience and their needs and the rest will take care of itself

{{< youtube NZN0A0U6ysg >}}

- The power of the group. Do your best to figure out the answer yourself but be open when you haven't figured something out. It is amazing what we can figure out together.

- ZIO community is very welcoming to everyone especially if you are junior in Scala. A lot of passionnate people who have a common goal to push Scala to the top.

- Everyone in the ZIO community makes you feel welcome and supported
- You will learn a lot by just trying to answer other peoples question on discord
- Contributing to open source is the best way to learn and gain experience. Better than any course.
- Quality of feedback and help is very high enabling you to learn a lot
- Improved my collaboration skills by a large margin
- Learn a ton about concurrency, performance tuning and functional design
- Make a lot of new friends from all around the world that you would never have otherwise met
- Microsite CI build will always randomly fail when you haven't changed anything, just to make you laugh 🤣





 