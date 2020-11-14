+++
title = "Introduction to the Actor Model"
date = 2020-10-04T11:23:12-07:00
description = "In this post I am going do a quick introduction to the actor model and the problems it is trying to solve."
toc = true
featured = false
draft = false
featureImage = "https://shared.softinio.com/Screen-Shot-2020-10-17-15-56-15.66.png"
thumbnail = ""
shareImage = ""
codeMaxLines = 10
codeLineNumbers = false
figurePositionShow = false
keywords = ["concurrent", "concurrency", "actor model", "actor", "actors", "threads", "petri net", "coroutines", "distributed", "akka", "erlang", "elixir", "akka.net", "microsoft orleans", "orleans", "zio", "zio-actors", "swift language actors"]
tags = ["actor model", "concurrency", "distributed systems"]
categories = ["concurrency", "distributed systems"]
+++

My first proper computer was an IBM PC clone with an Intel 486 processor. It had a button on it called `turbo` that when you pushed it would run the processor at double the speed. I say proper as before that I had started my computer journey with a Sinclair ZX Spectrum (48k Ram) and a Commodore 64 (64k Ram) hence didn't consider them as serious contenders for this post. It has been a really exciting ride watching hardware and software evolve together. The interesting observation has been that as faster more powerful hardware has come out, software has been quick to grab all the extra speed and resources the new hardware provides.

Watching how CPU's have evolved, in the early days it was all about clock speed and cache as the main optimizations to improve performance. However in the later years multicore and hyperthreading has been the driving factor to improve performance. This means that in current times to reap the maximum performance benefits that are offered by todays processors we need to write our software leveraging concurrency.

There are many methods and patterns of concurrency. In this post I am going to focus on the actor model.

## What is an Actor ? ##

An actor is an entity that receives a message and does some processing on the received message as a self contained concurrent operation.

![Actor](/img/actor.png)

An Actor consists of an isolated internal state, an address, a mailbox and a behavior. 

The address is a unique reference used to locate the actor so that you can send a message to it. It will include all the information you need, such as the protocol used to communicate with the actor.

Once an actor receives a message, it adds the message to its mailbox. You can think of the mailbox as queue where the actor picks up the next message it needs to process. Actors process one message at a time. The actor patterns specification does say that the order of messages received is not guaranteed, but different implementations of the actor pattern do offer choices on mailbox type which do offer options on how messages received are prioritized for processing.

The behavior determines what the actor needs to do with the message it receives. It will involve some processing of the message with some business logic which may include a side effect. Plus it will need to decide what to do next after processing.

Once it has finished processing the message, the actor will do one of the following:

- Does nothing, only needed to run the behavior on the received message
- Sends messages to other existing actors
- Creates a new actor and sends a message to it
- Respond to the sender zero or more times

## Characteristics of an Actor ##

One of the differentiating characteristics of an actor is that it persists and has an isolated internal state. 

What this means is that once an actor is started it will keep running, processing messages from its inbox and won't stop unless you stop it. It will maintain its state through out and only the actor has access to this state. This is unlike your traditional asynchronous programming, such as using Future in Scala or promises in javascript where once the call has finished its state between calls is not maintained and the call has finished.

This ability gives actors super powers when building concurrent applications.

## Handling Failure with Actors ##

In an actor system every actor has a supervisor who is responsible for handling failures. Supervisors are actors themselves but with the sole responsability of continuity for the actor it is supervising and handling any failures that occur. In the case of the supervisor actor its behavior is what you want it to do in case of such failure. Most implementations of the actor model will provide you with several types of supervisors, each using a different strategy for handling failures but you will have the option of creating your own custom supervisors too. Supervisors make it possible for actor's to self heal and continue. 

## Comparing Actors with traditional object oriented programming ##

Lets go through a contrived simple example, lets say you are a store that sells oranges. You have 10 oranges in stock. You have two customers who try to buy 7 oranges each. As you don't have enough oranges you cannot serve both customers requests for oranges.

![Object Oriented Programming Flow Example](/img/oop_oranges_example.png)

In a normal object oriented (multi-threadeed) program a customer would send a request to a service requesting the oranges they want. They expect a reply right away and wait for the response. When the request is received a check is made against the database to make sure there are enough oranges to fulfill the request (i.e. number of oranges >= 7) and if so, a success will be returned to the customer and 7 oranges will be deducted from the total orange count, python like pseudo code:

```python
def get_oranges(number_of_oranges):
    oranges_list = db_call_to_get_oranges()
    oranges_list_len = len(oranges_list)
    if oranges_list_len >= number_of_oranges:
        update_oranges(oranges - number_of_oranges)
        return oranges_list[:number_of_oranges-1]
    return None
```

If the second customer places their order at the same time, as our application is multi-threaded, there is a chance the check to get the current list of oranges will return the full list before the first customers purchase of 7 oranges has been deducted from the number of oranges available which will result in us returning a success by mistake even though we don't have enough oranges available. To avoid this race condition extra work needs to be done to prevent it, such as using locks or other appropriate mechanisms.

Using the Actor model this kind of race condition is avoided.

![Actor Programming Flow Example](/img/actor_oranges_example.png)

When each of the two requests are received, they will placed in the actor's inbox. The actor processes one request at a time from the inbox. The actors state are the oranges and updates to it are done whilst processing a single request which completes before the next request is fetched and processed from the inbox, thereby avoiding any potention race condition.

## Notable Implementations of the Actor Model ##

| Language/Framework | Link | Description |
| ------------------ | ---- | ----------- |
| akka (Java, Scala) | [akka](https://akka.io) | Framework implementing the actor model on the JVM |
| akka.net (C#) | [akka.net](https://getakka.net/index.html) | Framework implementing the actor model for C# and .net |
| Erlang | [Erlang OTP](https://www.erlang.org) | A Programming language and VM that implements the actor model |
| Elixir | [Elixir](https://elixir-lang.org) | A Programming language that compiles down to Erlang bytecode |
| Orleans (C#) | [orleans](https://dotnet.github.io/orleans/) | Framework implementing the actor model for C# and .net |
| zio-actors (Scala) | [zio-actors](https://zio.github.io/zio-actors/) | A high-performance, purely-functional library for building, composing, and supervising typed actors based on ZIO using Scala |

## Next ##

This was a rather short introduction to the actor model. Follow my blog for my follow-up posts on the actor model and my experience using it. In the meanwhile, it would be wonderful if my readers who are currently using this model could share using the comments below what problems they are solving with it and which implementation (language and/or framework) of the actor model they are using.

