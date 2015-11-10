---
layout: post
title:  "Flux in Swift"
date:   2015-11-04
summary: A one-way traffic pattern.
categories: programming swift
tag: programming swift design-pattern
--- 

Flux is an application architecture designed by Facebook. Unlike MVC and MVVM, Flux governs data to flow in a single direction. It makes data more predictable, and make bugs easier to trackdown. In this article, I will show how to implement Flux—by giving an example of iOS Todo app. 

The full source code can be found at [nRewik/Flux-in-Swift-Example](https://github.com/nRewik/Flux-in-Swift-Example)

has a uni-directional data flow

## The big picture

Action, Dispatcher, Store and View—are four compoents in Flux—can be summarised as follows:

Action

* simple object containing the new data and an identifying type property.

Store

* similar to Model in MVC.
* stores all UI states.
* listen to the dispatcher, recieve all actions sent from the dispatcher, perform filterd actions.
* emit an event when states are changed.

Dispatcher 

* the workload distribution centre.
* dispatch all works to all stores.

View

* renders UI from Store's state.
* listen to Store. When stores emit an event, views should update UI corresponding to new Store's states. 
* Views can emit actions. For example, user taps at a button—causing View to propagate an action through the dispatcher. 


Yes, Flux is reminiscent of MV&#42;. The main differece is arrows direction. They point forward in a single direction. Each component will listen to a component and talk forward to a component. They will not talk back and forth. They are actually pub/sub services!

They indicate the communication of components.


