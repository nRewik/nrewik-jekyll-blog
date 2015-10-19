---
layout: post
title:  "Function as First Class Citizens in Swift"
date:   2015-10-17 17:00:00
summary:    See what the different elements looks like. Your markdown has never looked better. I promise.
categories: programming swift
tag: programming swift
---
Why I need to write a function that return a function that return a function ? This is the first question that I was confused with Functional Programming, until I finally understand one of the core concepts.

The concept that I am talking about is **“functions as first-class citizens”**. It is elusive, usually delude newcomers. This article shows how to treat function properly by giving an example of writing a rule-based string validator. {% tk %}

You can see the full source code at [nRewik/Rule](https://www.github.com).


## Functions as Variables
Functions as first-class citizens means function is a variable. It’s just that. If you are a wizard who knows how to manipulate function like a variable, you can stop reading now. However, if you are not, this is worth reading.

There are two separated worlds, imperative and functional. Most of people get used to with the former. 

In imperative world, we tell the computer what to do, the computer does what we tell. We treat functions as subroutines. For example, we write this function to validate any given string.

```swift
func validate(text:String) -> Bool { return true }
```

Have you heard about *Wave–particle duality* ? that sometimes particle prefers itself to be wave. Functions behaves just like particles. In functional world, they prefer themselves to be variables.

> Functions are not just  functions, they are variables.

Functions are not just functions, they are variables. And being a variable means it belongs to a type. The validate function has `String–>Bool` type, which doesn’t give any sense of a variable, hence I will rename it to:

```swift
typealias Validator = String -> Bool
```

Revising the name to `Validator`, we can pronounce function types like Int, String, Bool. We sense it like an ordinary type. When we see a variable of this type, we don't care how  the function is done, but we care what is done. It is a divergent aspect. Thinking what you want done, rather than how you want something done.

## Storing Functions
Functions can be stored as variables. You might not know how to, but you already did. Just write a function with func or closure. These two words similarly represent a function. Although, they differ in scope and context, they can be used interchangeably.

```swift
enum Rule{
    func validate(text:String) -> Bool{
        return true
    }
}
```

or

```swift
enum Rule{
    var validate: Validator{
        return { text in return true }
    }
}
```

## Passing Functions
Let’s add a dummy rule to validate string’s length.

```swift
enum Rule{
    case lengthEqual(Int)
    func validate(text: String) -> Bool{
        switch self{
        case let .lengthEqual(length):
            return text.characters.count == length
        }
    }
}

Rule.lengthEqual(5).validate("12345") //True
```
`.lengthEqual` is just a simple rule to show how I use `Rule` to validate a string. It is very strict and totally useless, we need to limber it up. To validate length that is greater than or less than *x*, we might add more cases to enum, but there is functional way to do this.

```swift
typealias IntComparator = (Int,Int) -> Bool

enum Rule{
    case length( IntComparator , Int )
    func validate(text: String) -> Bool{
        switch self{
        case let .length(comparator, textCount):
            return comparator(text.characters.count,textCount)
        }
    }
}

Rule.length(==, 5).validate("12345") //True
Rule.length(>, 5).validate("12345") //False
Rule.length(<, 10).validate("12345") //True
```

Instead of thinking how to compare the length, thinking how the length is compared. Instead of covering all cases, exposing function as a parameter. `IntComparator` is a nickname of `(Int,Int)–>Bool`. Its signature is identical to Int operator function `>,<,==,!=,<=,>=`, so we can pass it directly as a variable via function argument.

I can add more default rules like `.length` to enum cases, but how about other rules that we uncommonly used. Let’s provide `.custom` which allows user to create other rules that doesn’t fall in the default category.

```swift
enum Rule{
    //...
    case custom( Validator )
    func validate(text: String) -> Bool{
        switch self{
        case let .custom( validator ):
            return validator(text)
       }
}
```

Just like the previous `.length`, we have function as a parameter, but now it is changed to a validator. You might notice that it’s easier to understand when we have `Validator` or `IntComparator` typealias. This is why I usually give function a nickname, and I recommend you to do so.

> Whenever you feel it’s too complicated, try give it a nickname.

## Returning Functions
Now, I should answer my question that I was confused. “Why I need to write a function that return a function that return a function ?”. The answer is if you have function as a variable mindset, there’s nothing to be confused. You treat it like you used to, storing, passing and returning as you do with Int, String, Bool.

