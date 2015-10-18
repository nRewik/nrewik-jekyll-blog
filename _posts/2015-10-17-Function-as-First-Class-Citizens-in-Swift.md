---
layout: post
title:  "Function as First Class Citizens in Swift"
date:   2015-10-17 17:00:00
---
Hi Hello There

```swift
class ParticleModel {
	private var point = ( x: 0.0, y: 0.0 )
	private var velocity = 100.0

	private func updatePoint(newPoint: (Double, Double), newVelocity: Double) {
		point = newPoint
		velocity = newVelocity
	}

	func update(newP: (Double, Double), newV: Double) {
		updatePoint(newP, newVelocity: newV)
	}
}
let x = "\"haha\""
let ccc = "😀"
```





