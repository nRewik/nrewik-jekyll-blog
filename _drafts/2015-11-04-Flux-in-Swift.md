---
layout: post
title:  "Flux in Swift"
date:   2015-11-04
summary: A one-way traffic pattern.
categories: programming swift
tag: programming swift design-pattern
--- 

[Flux](https://facebook.github.io/flux/docs/overview.html) is an application architecture designed by Facebook. Unlike MVC and MVVM, Flux governs data to flow in a single direction. It makes data more predictable, and make bugs easier to trackdown. In this article, I will show how to implement Flux—by giving an example of iOS Todo app. 

The full source code can be found at [nRewik/Flux-in-Swift-Example](https://github.com/nRewik/Flux-in-Swift-Example)

## The big picture

The heart of Flux is the one-way route, called a uni-direcitonal data flow, which is illustrated by the arrows pointing forward to a single direction. 


Unlike MV* patterns that components can talk back and forth, Flux's components can only talk forward. They only talk to someone they trust, for example, stores only talk to views. 

Talking to everyone without getting feedback, means you are talking to no one. Flux's components listen for feedback events after talking. They again only listen to someone they trust, for example, stores only listen to the dispatcher. 

In summary, We can think of Flux as pub/sub services!

## Components

Action, Dispatcher, Store and View—are the four main components in Flux. Their roles can be summarised as follows:

**Action**

* simple object containing the new data and an identifying type property.

**Store**

* stores all UI states.
* listens to the dispatcher, recieve all actions sent from the dispatcher
* performs some actions.
* emits an event when states are changed.

**Dispatcher**

* the workload distribution centre.
* dispatches all works to all stores.

**View**

* renders UI from store's state.
* listens to stores. Whenever stores emit an event, views will update UI corresponding to the new store's states. 
* emits and propagate actions through the dispatcher. For example, when user taps at a button.

## Begin with Store

Stores are not models as we used to think in MVC. Store is a singleton. It is a self-contained universe, completely in control of its data and behaviour. It is a single source of truth in your app, which every UI states rely on it.

`TodoStore` stores `TodoItem` lists.  

register a callback with dispatcher




