---
layout: post
title:  "Function as First Class Citizens in Swift"
date:   2015-10-17 17:00:00
---
Hi Hello There

```swift
class UIView : UIResponder {  
	init!(frame: CGRect)

	var superview: UIView! { get }  
	var subviews: [AnyObject]! { get }  
	var window: UIWindow! { get }

	// ...

	func isDescendantOfView(view: UIView!) -> Bool
	func viewWithTag(tag: Int) -> UIView!

	// ...

	var constraints: [AnyObject]! { get }

	// ...
}
```





