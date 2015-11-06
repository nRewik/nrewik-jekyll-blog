---
layout: post
title:  "Flux in Swift"
date:   2015-11-04
summary: A one-way traffic pattern.
categories: programming swift
tag: programming swift design-pattern
--- 

Flux is an application architecture designed by Facebook. In constrast to other patterns like MVC and MVVM, Flux has a uni-directional data flow as its strength, which means data flow through the app in a single direction. It makes data more predictable, and make bugs easier to trackdown. In this article, I will show how to Flux—by giving an example of an iOS Todo App. 

The full source code can be found at [nRewik/Flux-in-Swift-Example](https://github.com/nRewik/Flux-in-Swift-Example)

## The big picture

At first glance, Flux looks like MV&#42; pattern.

Flux is composed from four components. ... 

Wait, this diagram looks like the wrong version of MV&#42;.

Yes, Flux is reminiscent of MV&#42;. The main differece is arrows direction. They point forward in a single direction. Each component will listen to a component and talk forward to a component. They will not talk back and forth. They are actually pub/sub services!

They indicate the communication of components.