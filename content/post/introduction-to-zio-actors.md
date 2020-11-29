+++
title = "Introduction to Zio Actors"
date = 2020-11-01T14:14:21-08:00
description = "Introduction to ZIO Actors"
featured = true
draft = false
toc = true
featureImage = "/img/ZIO.png"
thumbnail = ""
shareImage = ""
codeMaxLines = 30
codeLineNumbers = false
figurePositionShow = false
keywords = ["concurrent", "concurrency", "actor model", "actor", "actors", "threads", "petri net", "coroutines", "distributed", "akka", "erlang", "elixir", "akka.net", "microsoft orleans", "orleans", "zio", "zio-actors", "zio actors","swift language actors", "functional programming", "fp"]
tags = ["actor model", "concurrency", "distributed systems", "scala", "zio", "zio-actors", "functional programming"]
categories = ["concurrency", "distributed systems", "scala", "functional programming"]
+++

In this post I am going to do a quick introduction to using the [ZIO Actors](https://zio.github.io/zio-actors/), a library that implements the Actor model using Scala and ZIO a library for asynchroneous and concurrent programming.

Before reading this post it is recommended that you read my two earlier posts [Introduction to the Actor Model](/post/introduction-to-the-actor-model/) and [Introduction to Akka Typed Using Scala](/post/introduction-to-akka-typed-using-scala/) as I have assumed the reader will be familiar with the concepts discussed in those posts. Some basic knowledge of [ZIO](https://zio.dev) is assumed.

I will be going through the same example as I covered in my Introduction to Akka post, only this time I am using ZIO Actors instead of Akka.

## Problem to solve ##

To get start we are going to build a simple mailing list application where a persons name and email address are added to a datastore and we are able to retrieve their details and remove them from the datastore. As the scope of this example is to show how we can use zio actors to build an application, our data store will be a pretend one.

The diagram below illustrates the actors that we will need and the message flow between each actor.

![ZIO Actor System Design Example](/img/zio_actor_system_design.png)

- `ZIO Actor System`: Creates the actor system and spawns all the actors.
- `Validate Email Address Actor`: Validates if the new message received has a valid email address
- `Datastore Actor`: Decides which datastore `Command` (i.e. `Add`, `Get` or `Remove`) we are actioning and calls the relevant actor with the message.
- `Add Action Actor`: Uses the message received to add the received subscriber to the database.
- `Get Subscriber Actor`: Retrieves a subscriber from the database.
- `Remove Subscriber Actor`: Removes a subscriber from the database.

## Messages and Types ##

Lets start by defining the types of the messages our actors are going to be passing.

First our actors are going to be sending on of three types of commands to either add, remove or get a subscriber from the datastore:

```scala
sealed trait Command
final case object Add extends Command
final case object Remove extends Command
final case object Get extends Command
```

The message type to add a subscriber:

```scala
sealed trait Protocol[+A]

final case class Message(
    firstName: String,
    lastName: String,
    emailAddress: String,
    command: Command,
    db: ActorRef[Protocol],
    replyTo: ActorRef[Protocol]
) extends Protocol[Unit] {
  def isValid: UIO[Boolean] =
    UIO(EmailValidator.getInstance().isValid(emailAddress))
}

```

The message type for sending a reply to the requester:

```scala
final case class SubscribedMessage(subscriberId: Long, from: ActorRef[Protocol])
    extends Protocol[Unit]
```
The exception type if an invalid message is sent to an actor:

```scala
case class InvalidEmailException(msg: String) extends Throwable
```

The message type of message retrieved from the datastore when a `Get` command is received:

```scala
final case class Customer(
    firstName: String,
    lastName: String,
    emailAddress: String
) extends Protocol[Unit]
```

## Validate Email Address Actor ## 

```scala
  val subscriber = new Stateful[Console, Unit, Protocol] {
    override def receive[A](
        state: Unit,
        protocol: Protocol[A],
        context: Context
    ): RIO[Console, (Unit, A)] =
      protocol match {
        case message: Message =>
          for {
            _ <- putStrLn(
              s"Validating ${message.firstName} ${message.lastName} with email ${message.emailAddress}!"
            )
            valid <- message.isValid
            self <- context.self[Protocol]
            _ <- message.replyTo ! SubscribedMessage(1L, self)
            if (valid)
            _ <- message.db ! message
            if (valid)
          } yield ((), ())
        case _ => IO.fail(InvalidEmailException("Failed"))
      }
  }
```
When creating actors we need to define how the actor reacts to messages and how they are processed. Looking at the above code you will see that we are creating a `Stateful`.

### What is Stateful ###

Stateful is the data type we use to describe a behavior with zio-actors:

```scala
Stateful[R, S, -F[+_]]
```

What do the type parameters represents:

- `R` represents the environment type (similar to `R` in `ZIO[R, E, A]`)
- `S` represents the state of the actor that gets updated after every message. 
- `F` represents the message the actor will receive to process.

### How Validate Email Address Actor Work ###

Looking at the code snippet above you will see a new `Stateful` is created, for the `R` (environment type) we are passing Console which is an Environment provided by ZIO which allows you to log messages to the console. The state of this actor does not change after each message is processed and hence it `S` type which represents state is set to `Unit`. `Protocol` is the types of messages our actor can process. We went through definition of this type [earlier in the post]({{< ref "introduction-to-zio-actors.md#messages-and-types-" >}}).

By creating a new `Stateful` we override its `receive` method (similar to `akka`) that implements the actual behavior. Here we pattern match on the message received to make sure it is of type `Message` and if so we use a for comprehension to go through a few steps:

- Call the message's `isValid` method to verify it contains a valid email address. Only continue if valid.
- Get the `ActorRef` for `self`, i.e. the current actor.
- The message received contains an `ActorRef` to reply to. Send a message `SubscribedMessage` to this actor (this includes the `ActorRef` of self that was obtained in the last step).
- send the message received onto the datastore actor

From the pattern matching you can see that if you do not receive a message of type `Message`, `IO.fail` which is provided by `ZIO` is used to surface the failure.

The `receive` method returns `RIO[Console, (Unit, A)]` which is an alias for `ZIO[Console, Throwable, (Unit, A)]` which highlights that a tuple is returned for a success.

## Datastore Actor ##

This actor is responsible for adding, removing and fetching a `Customer` from the datastore.

```scala
  val datastore = new Stateful[Console, Unit, Protocol] {
    override def receive[A](
        state: Unit,
        protocol: Protocol[A],
        context: Context
    ): RIO[Console, (Unit, A)] =
      protocol match {
        case message: Message =>
          for {
            _ <- putStrLn(s"Processing Command")
            _ <- message.command match {
              case Add =>
                putStrLn(s"Adding message with email: ${message.emailAddress}")
              case Remove =>
                putStrLn(
                  s"Removing message with email: ${message.emailAddress}"
                )
              case Get =>
                putStrLn(s"Getting message with email: ${message.emailAddress}")
            }
          } yield ((), ())
        case _ => IO.fail(InvalidEmailException("Failed"))
      }
  }
```

Similar to the [Validate Email Address Actor]({{< ref "introduction-to-zio-actors.md#how-validate-email-address-actor-work-" >}}), this actor creates a new stateful with same type parameters. Overrides `receive` to implement behavior. Pattern match the received message to make sure it is of type `Message` and if not does `IO.fail`. If correct message it does the following: 

- pattern match on the command field of the message to determine which command we have received.
- For each command take the appropriate action. As this is a contrived example we just log what we are doing instead of an actual interaction with a database by calling another actor. 

## Creating the Actor System ##

```scala
  val program = for {
    actorSystemRoot <- ActorSystem("salarTestActorSystem")
    subscriberActor <- actorSystemRoot.make("subscriberActor", Supervisor.none, (), subscriber)
    datastoreActor  <- actorSystemRoot.make("datastoreActor", Supervisor.none, (), datastore)
    replyActor      <- actorSystemRoot.make("replyActor", Supervisor.none, (), reply)
    _               <- subscriberActor ! Message(
                "Salar",. 
                "Rahmanian",
                "code@softinio.com",
                Add,
                datastoreActor,
                replyActor
              )
    _               <- zio.clock.sleep(Duration.Infinity)
  } yield ()
```

With ZIO Actors as everything is a ZIO effect we can use a for comprehension to create our system. Looking at the above code snippet you can see we start by creating an `ActorSystem`. We then use the `.make` property of our `ActorSystem` to create all the actors. Now we are ready to create our `Message` and start sending to the message to the `subscriberActor` we created. As you can see the `ActorRef` of the `dataStoreActor` and `replyActor` are included in the message so that the correct actor is used to store the message and the correct actor is used to send the reply.

## Summary ##

In this post I have just tried to give you a feel for what its like to use zio-actors, how to think about your application in terms of Actors and message passing and to get started. As you can see zio-actors leverages ZIO as a library and functional programmming to the max leading to a very composable and readable solution.

zio-actors has many other features and patterns of use which I will be blogging in more details about in the future so follow my post as I try to share my learnings with everyone. 


## Useful Resources ##

- [My Sample Application used in this post](https://github.com/softinio/pat)
- [ZIO Actors Documentation](https://zio.github.io/zio-actors/)
- [ZIO Documentation](https://zio.dev)

