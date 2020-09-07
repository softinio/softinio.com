+++
title = "Scale By The Bay 2018 San Francisco"
date = 2019-05-02T18:30:40-07:00
description = "Highlights of Scale By The Bay 2018 San Francisco conference an event based in the San Francisco Bay Area California with major focus on Functional Programming, Reactive programming and Data Science"
draft = false
featureImage = "https://via.softinio.com/scalebythebay_2018_header.jpg"
keywords = ["scala", "bythebay", "sfscala", "functional programming", "san francisco", "bay area", "california", "conference"]
tags = ["scala", "conference", "functional programming"]
categories = ["scala", "conference", "functional programming"]
+++

One of the highlights of 2018 was attending and being part of the Scale By the bay 2018 conference in San Francisco. This by far was the best conference I have ever attended. 

from left: [Dick Wall](https://twitter.com/dickwall), [Salar Rahmanian](https://twitter.com/SalarRahmanian), [Martin Odersky (Creator of Scala)](https://twitter.com/odersky), [Alexy Khrabrov](https://twitter.com/ChiefScientist), [Jakob Odersky ](https://twitter.com/jodersky)

The conference had 3 tracks covering the functional programming, reactive programming and data science topics. All the talks were of high quality made even better by highly intelligent audience made up of the most talented stars of our industry.

## Keynotes
![Scale By the Bay 2018 Keynotes](https://via.softinio.com/scalebythebay_2018_keynotes.jpg)

### New Functional Constructs in Scala 3 by Martin Odersky (Creator of Scala)

The first keynote was by the creator of Scala Programming language. He took us through some of the new constructs we are likely to see in the upcoming major release of Scala3. Overall the audience was very excited about the new constructs and what is coming up. There were a few people I had talked to at the conference who had concerns that we are heading for another python2 -> python3 situation causing a split in the community and some hesitation in desire to upgrade as there will be some breaking changes.

I personally am excited about the new features coming out and am optimistic about the success of the new version. In addition there will be new tooling the scala center is working on that will help with migrating to the new version. Let's not forget Scala is strongly typed which will help a lot with the migration unlike languages like Python.

{{< youtube 6P06YHc8faw >}}

### Kafka and the Rise of the event driven Microservices by Neha Narkhede (Co-creator of Apache Kafka)
This keynote started off by asking the audience who uses Kafka in Production today. It was fascinating to see that 95% of the audience were which is a huge endorsement of Kafka.

One of the initial and primary use cases for using Kafka has been to build data pipelines, this keynote focused on the next evolution of Kafka where it is used to build event driven applications and microservices. The standard mindset has been to design and implement your apps based around static data, Kafka helps us design apps based around continuely streaming data.

This new paradigm will allow us to take data from your applications and data from your data systems like databases and do stream processing on them to produce.

{{< youtube DOoJzaXOGxs >}}

## Concurrency and more concurrency
There was a common theme at this years conference, multiple talks about libraries and patterns to make concurrency and parallel processing easier and over coming the pain points associated with it. 

Jakob Odesky talk summarized the concurrency options available to you  within Scala Language and the JVM such as threads, Futures and Promises. He then went on to talk about Scala Center 's [scala-async](https://github.com/scala/scala-async) library which has lead him to his new open source project  [escale](https://github.com/jodersky/escale) which is built on top of scala-async.  This new library, escale, introduces the same concept as channels and green threads that was introduced by the go programming language for scala. I look forward to seeing how this evolves.

{{< youtube EuNEZW8ljeY >}}

Michael Pilquist gave us a nice update on `cats-effect` took us through an overview of some of the features it has to solve concurrency problems. There was lot of content in his talk for me to summarize in this post so I urge you to watch the video of his talk.

{{< youtube Gig-f_HXvLI >}}

My favorite talk of the conference was a talk by Sergei Winitzki on Declarative distributed concurrency in Scala where he talk about his open source project  [Chymyst](https://github.com/Chymyst/chymyst-core) which implements the chemical machine (based on joint calculus). The philosophy and end goal  of the chemical machine is to be able to process what ever problem you are trying to solve in 15 lines or less of code. Containers holding values are known as `molecules`. Molecules  float around the site until they combine to form a chemical reaction the output of which can be used again. In his implementation partial functions where used  to implement the reactions. I loved the analogy to chemistry and Sergei's presentation really explained the concept well to spark my interest in this. Since his talk I have researched the topic of chemical machines and I could only find research papers on the topic and none of them do as good a job in explaining what it is as the talk did so I urge you to watch the video. 

{{< youtube 23O32DMm69E >}}

## Hero’s welcome
Over the years in my career I have followed many of the people I met at this years conference. Their work and teachings have helped me progress my knowledge and ability and have motivated me and others to be part of a great community. 

Here  are some pictures of the tech heroes I got to meet at this conference:

![Scale By the Bay 2018 ](https://via.softinio.com/scale_by_the_bay_2018_1.JPG)
Top left: [Rob Norris (creator of Doobie)](https://twitter.com/tpolecat), Top right: [Ross Baker (creator of http4s)](https://twitter.com/rossabaker),
Bottom left: [Michael Pilquist (Creator of FS2)](https://twitter.com/mpilquist), Bottom right:  [Jon Pretty (Scala Center Advisory board chair)](https://twitter.com/propensive/)

![Scale By the Bay 2018](https://via.softinio.com/scale_by_the_bay_2018_2.JPG)
[Runar Bjarnason ](https://twitter.com/runarorama) & [Paul Chiusano](https://twitter.com/pchiusano) authors of the book [Functional Programming in Scala](https://www.manning.com/books/functional-programming-in-scala)

![Scale By the Bay 2018](https://via.softinio.com/scale_by_the_bay_2018_4.JPG)
Top left: [Eugene Yokota (Scala/SBT Team)](https://twitter.com/eed3si9n) , Top right:  [Justin Kaeser (Jetbrains)](https://twitter.com/ebenwert),
Bottom left: [Cliff Click](https://twitter.com/cliff_click),  Bottom right:  [Julien Le Dem (Apache Parquet & Arrow)](https://twitter.com/J_)

![Scale By the Bay 2018](https://via.softinio.com/scale_by_the_bay_2018_3.JPG)
Top: [John De Goes (Creator of ZIO) ](https://twitter.com/jdegoes) & [Itamar Ravid (Core contributor to ZIO)](https://twitter.com/itrvd),
Bottom:  [Jon Pretty (Scala Center Advisory board chair)](https://twitter.com/propensive/)

## Thank you
I am humbled that I got a chance to meet so many great people at this conference, for the first time in person, and hope to keep in touch going forward. 

I want to thank all speakers and attendees at this event, especially I want to thank [Alexy Khrabrov](https://twitter.com/ChiefScientist) for putting together such a great event, welcoming me to the bay area and helping me be part of the great community we have in the bay area and this conference.

{{< youtube iTeh-wnvweQ >}}

