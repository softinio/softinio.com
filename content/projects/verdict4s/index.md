+++
title = "verdict4s"
description = "A Scala 3 client for TypeSafe AI's Jev decision model."
weight = 1

tags = ["Scala", "AI", "Typelevel", "Project"]
categories = ["Project"]

[params]
local_image = "projects/verdict4s/verdict4s_logo.svg"
toc = true
keywords = ["Scala", "Scala.js", "AI", "Jev", "TypeSafe AI", "Typelevel"]
+++

![verdict4s](verdict4s_logo.svg)

# Overview

A Scala 3 client for [TypeSafe AI](https://typesafe.ai)'s **Jev**, a decision model that answers typed questions about your program state. It returns choices, scores and calibrated probabilities, not text.

It is cross-built for the JVM and Scala.js from one source tree. The service's limits are carried by the types, so an invalid question fails at compile time or during validation before anything is sent. It doesn't wait for a network round trip. The library ships as three modules:

- `verdict4s`: a working client in one line, with its own transport.
- `verdict4s-client`: for when you already have an http4s `Client[F]` or want a specific backend.
- `verdict4s-core`: the types and codecs only, with no effect system.

## Links

- Documentation: <https://verdict4s.softinio.dev/>
  - Getting Started: <https://verdict4s.softinio.dev/getting-started.html>
- Repository: <https://github.com/softinio/verdict4s>
  - README: <https://github.com/softinio/verdict4s/blob/main/README.md>
