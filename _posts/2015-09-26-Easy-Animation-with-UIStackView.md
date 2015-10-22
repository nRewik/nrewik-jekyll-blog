---
layout: post
title:  "Easy Animation with UIStackView"
date:   2015-09-26
summary: Animate UIStackView like a pro.
categories: programming swift
tag: programming swift
---

**UIStackView** leverages the power of Auto Layout by managing the layout of all the views inside. You can change property of UIStackView or its arranged subview, and place these changes inside an animation block.

For example, changing `hidden` property of the arranged subview.

```swift
UIView.animateWithDuration(0.3){
    viewInsideStackView.hidden = true //or false
}
```

Here’s the animation.

<figure class="center"><img src="{{ site.baseurl }}/images/easy-animation-with-ui-stack-view-1.gif"/></figure>

iOS encourages you to create adaptive UI, when working with UIStackView, you can define size-class specific values for many of the stack view’s properties directly in Interface Builder. UIStackView automatically animates these changes for you.

For example, changing `axis` property of UIStackView in CompactHeight, and with some tweaks of the arranged subview’s constraints. You can have this animation without coding.

<figure class="center"><img src="{{ site.baseurl }}/images/easy-animation-with-ui-stack-view-2.gif"/></figure>

For the detail of how constraints are set up, see the full project at GitHub [UIStackViewEasyAnimation](https://github.com/nRewik/UIStackViewEasyAnimation)