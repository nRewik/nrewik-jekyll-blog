---
layout: post
title:  "Function as First Class Citizens in Swift"
date:   2015-10-20
summary: Why I need to write a function that return a function that return a function?
categories: programming swift
tag: programming swift
---
Why I need to write a function that return a function that return a function ? This is the question that I was confused when I start learning Functional Programming. 

**“Functions as first-class citizens”** is an elusive concept for beginners. This article will shows how to treat function properly by giving an example of writing a rule-based string validator.

You can see the full source code at [nRewik/Rule.swift](https://gist.github.com/nRewik/c2cfcc041928db562df8)


## Functions as Variables
Functions as first-class citizens means function is a variable. It’s just that. If you are a wizard who knows how to manipulate function like a variable, you can stop reading now. However, if you are not, this is worth reading.

There are two separated worlds, imperative and functional. Most of people get used to with the former. 

In imperative world, we tell the computer what to do, the computer does what we tell. We treat functions as subroutines. For example, we write this function to validate any given string.

```swift
func validate(text:String) -> Bool { return true }
```

Have you heard about *[Wave–particle duality](https://www.youtube.com/watch?v=Q_h4IoPJXZw)* ? that sometimes particle prefers itself to be wave. Functions behaves just like particles. In functional world, they prefer themselves to be variables.

> Functions are not just  functions, they are variables.

Functions are not just functions, they are variables. And being a variable means it belongs to a type. The validate function has `String–>Bool` type, which doesn’t sound like any variable type, so I will rename it to:

```swift
typealias Validator = String -> Bool
```

Revising the name to `Validator`, we can pronounce it like Int, String, Bool. We sense it like an ordinary type. When we see a variable of this type, we don't care how  the function is done, but we care what is done. It is a divergent aspect. Thinking what you want done, rather than how you want something done.

## Storing Functions
Functions can be stored as variables. You might not know how to, but you already did. Just write a function with `func` or `closure`. These two words similarly represent a function. Although, they differ in scope and context, they can be used interchangeably.

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

I could add more default rules like `.length` to enum cases, but how about other rules that we uncommonly used. Let’s provide `.custom` which allows user to create other rules that doesn’t fall in the default category.

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

// Usage
let palindromeRule = Rule.custom{ text in
    text == String( text.characters.reverse() )
}

palindromeRule.validate("ABBABBA") // true
palindromeRule.validate("ABC") // false
```

Just like the previous `.length`, we have function as a parameter, but now it is changed to a validator. You might notice that it’s easier to understand when we have `Validator` or `IntComparator` typealias. This is why I usually give function a nickname, and I recommend you to do so.

> Whenever you feel it’s too complicated, try give it a nickname.

## Returning Functions
Rule is now customisable, but still lack of combinability. *Transformer* and *Combiner* are function types that return a function, which allow us to create combinations of rules.

**Transformer**
A rule can be transformed to another rule. For example we might create a negate rule that yield opposite result.

```swift
typealias ValidatorTransformer = Validator -> Validator
```

`ValidatorTransformer` takes a `Validator` and produce a new one. You can see the benefit of renaming here, because its actual type is the long `(String->Bool) -> (String->Bool)`. 

Let's create `.transform`, which take a transformer to transform a rule, before validate a string.

```swift
enum Rule{
    //...
    // Note that this case should be marked  as `indirect` to allow recursive enum.
    indirect case transform( Rule, ValidatorTransformer )
    func validate(text: String) -> Bool{
        switch self{
        case let .transform( rule, transformer):
            return transformer(rule.validate)(text)
        }
    }
}

// Usage
let negateTransformer: ValidatorTransformer = { validator in
    return { text in !validator(text) } 
}
let notPalindromRule = Rule.transform( rule, negateTransformer )
```

We can make the syntax more concise by turning `negateTransformer` into `!` operator and add a shortcut for creating a negate rule.

```swift
// negateTransformer
prefix func ! ( validator: Validator) -> Validator{
    return { !validator($0) }
}

// negate rule shortcut
prefix func ! (rule: Rule) -> Rule{
    return Rule.transform(rule, !)
}

// usage
let notPalindromRule = !palindromeRule
```
**Combiner**
A rule can be a combination of several rules. For example, we might create a rule that is combined from a logical conjunction, i.e. *and*, *or*. `ValidatorCombiner` takes two validators and then produce a new one.

```swift
typealias ValidatorCombiner = ( Validator , Validator ) -> Validator

enum Rule{
    //...
    indirect case combine( Rule, Rule, ValidatorCombiner )
    func validate(text: String) -> Bool{
        switch self{
        case let .combine( leftRule, rightRule, combiner):
            return combiner( leftRule.validate, rightRule.validate )(text)
        }
    }
}

// Usage
let andCombiner: ValidatorCombiner = { left , right in
    return { text in left.validate(text) && right.validate(text) }
}

let palindromeGreaterThanFiveRule = Rule.combine( palindromeRule, Rule.length(>,5) , andCombiner )
```

Let’s make this more concise again with `&&` and `||` operator.

```swift
// and combiner
func && ( leftValidator: Validator , rightValidator: Validator) -> Validator{
    return { leftValidator($0) && rightValidator($0) }
}

// or combiner
func || ( leftValidator: Validator , rightValidator: Validator) -> Validator{
    return { leftValidator($0) || rightValidator($0) }
}

// and rule shortcut
func && ( left: Rule , right: Rule) -> Rule{
    return Rule.combine(left, right, &&)
}

// or rule shortcut
func || ( left: Rule , right: Rule) -> Rule{
    return Rule.combine(left, right, ||)
}

// Usage
let palindromeGreaterThanFiveRule = palindromeRule && Rule.length(>,5)
let complexRule = !( !palindromeRule || Rule.length(<,10) )
```

Finally, String extension and `~=` operator eliminate verboseness. Now Rule is more flexible, we can use default rules, customise new rules and combine rules.

```swift
"AABBAA" ~= palindromeRule // true
"ABCDEF" ~= .alphabetOnly && .length(<, 2) // false
"test@test.com" ~= .email && .length(>, 5) // true

switch "some test string"{
case palindromeGreaterThanFiveRule:
    print("it's a spectacular palindrome.")
case palindromeRule:
    print("it's just an ordinary palindrome.")
default:
    print("it's not a palindrome")
}
```

## Conclusion
Functional Programming is about thinking what you want done rather than how you want something done. Functions are not subroutines. You treat them as variables.

To answer my question “Why I need to write a function that return a function that return a function ?”. Why? because you can. If you have function as a variable mindset, there’s nothing to be confused. You treat them like you used to. Storing, passing, returning them as you do with Int, String, Bool. 😃




