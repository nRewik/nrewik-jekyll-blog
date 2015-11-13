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

The heart of Flux is a uni-direcitonal data flow, which is illustrated by the arrows pointing forward to a single direction. A component will listen to a component and only talk forward to another component. They will not talk back and forth. It might be easier to think of Flux as pub/sub services!

Action, Dispatcher, Store and View—are the four main components, which their roles can be summarised as follows:

**Action**

* simple object containing the new data and an identifying type property.

**Store**

* similar to Model in MVC.
* stores all UI states.
* listen to the dispatcher, recieve all actions sent from the dispatcher
* perform actions.
* emit an event when states are changed.

**Dispatcher**

* the workload distribution centre.
* dispatch all works to all stores.

**View**

* renders UI from Store's state.
* listen to Store. Whenever stores emit an event, views will update UI corresponding to the new Store's states. 
* emit and propagate actions through the dispatcher. For example, when user taps at a button.


## Dispatcher




