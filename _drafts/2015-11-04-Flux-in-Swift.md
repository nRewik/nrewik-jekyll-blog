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

* stores and manages application states.
* listens to the dispatcher, recieve all actions sent from the dispatcher.
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

Store manages the application state and logic. They are akin to models in MVC, but stores manage more than a single piece of data. Stores are singleton classes. They are self-contained universes, completely in control of their data and behaviour. Each store is a single source of truth in its domain.

**Stores and manages application states**
In this app, there will be only one store—**TodoStore**. It manages everything about **TodoItem**. TodoStore should know how to store, create, delete and edit todo items. 

```swift
struct TodoItem{
    let id = NSUUID().UUIDString
    var text = "hello world!"
}

class TodoStore{

	// Singleton
    static let defaultStore = TodoStore()
    private init(){ }

    // TodoItems List
    var todoList: [TodoItem]{ return _todoList }
    private var _todoList: [TodoItem] = []
    
    // Action Handler
    func addTodo(todo: TodoItem){
        _todoList += [todo]
    }
    func editTodo(id: String, text: String){
        guard let editedIndex  (_todoList.indexOf{ $0.id == id }) else { return }
        _todoList[editedIndex].text = text
    }
    func deleteTodo(id: String){
        guard let removeIndex = (_todoList.indexOf{ $0.id == id }) else { return }
        _todoList.removeAtIndex(removeIndex)
    }
}
```
**Emit change events**
Stores should emit an event when their states are changed. The event will be sent to listeners. This can be done with delegate pattern. We will be creating this behaviour as a **Store** protocol, since this is a common behaviour for every store.

```swift
protocol StoreListener: class{
    func storeDidChanged( store: Store )
}
protocol Store: class{
    var listeners : [ StoreListener ] { get set }
}

// protocol extension
extension Store{
    func registerStoreChanged( listener: StoreListener){
        guard nil == ( listeners.indexOf{ $0 === listener } ) else { return }
        listeners += [listener]
    }
    func unregisterStoreChanged( listener: StoreListener){
        guard let removedIndex = (listeners.indexOf{ $0 === listener} ) else { return }
        listeners.removeAtIndex(removedIndex)
    }
    func emitChangeEvent(){
        for listener in listeners{
            listener.storeDidChanged(self)
        }
    }
}
```

Then we adopt Store trait to TodoStore.

```swift
class TodoStore: Store{
	// MARK: - Store
    var listeners: [StoreListener] = []

	// Action Handler
    func addTodo(todo: TodoItem){
        _todoList += [todo]
        emitChangeEvent() // also do this to `editTodo` and `deleteTodo`
    }
    // ...
}
```

**Dispatcher callback**

Each store should have a **dispatcherCallback**. This callback will be called from the dispatcher when someone create an action. Stores should handle some actions inside this callback, by investigating action type in **Payload**.

When stores are creating, they should register their callback to the dispatcher. After registering a callback, we will get **dispatcherToken**. This token is useful to identify a callback, for example, we can use this token to unregister a callback later.

```swift
struct Payload{
    var type = "" // to identify action type
    var data: [ String : AnyObject ] = [:] // associated data
}

protocol Store: class{
	// ...
    var dispatcherToken: String { get set }
    func dispatcherCallback( payload: Payload )
}

class TodoStore: Store{

	private init(){
        dispatcherToken = Dispatcher.register(dispatcherCallback)
    }

	// MARK: - Store
	// ...
	var dispatcherToken: String = ""
    func dispatcherCallback( payload: Payload ){

    	// investigate action type
        switch payload.type{
        case TodoAction.CREATE_TODO:
        	// extract associated data from payload
            guard let text = payload.data["text"] as? String else { return }
            let newTodo = TodoItem(text: text)
			// perform action
            addTodo(newTodo)

        case TodoAction.EDIT_TODO:
            guard let text = payload.data["text"] as? String else { return }
            guard let id = payload.data["id"] as? String else { return }
            editTodo(id, text: text)
        case TodoAction.DELETE_TODO:
            guard let id = payload.data["id"] as? String else { return }
            deleteTodo(id)
        default:
            break
        }
    }
}
```

## Dispatcher

## Action

## View







