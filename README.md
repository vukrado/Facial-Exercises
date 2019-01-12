# Facial Exercises
> Our app guides you through a variety of facial exercises aimed to improve mobility.

[![Swift Version][swift-image]][swift-url]

Facial exercises began as a two day hackathon project. It was intended to mimick post-stroke exercises. Using ARKit the app tracks movement of specific facial features, graphing range of motion trends for each exercise. During an individual exercise, real time feedback is displayed describing the relative movement of the specific feature. After the completion of all exercises selected, users are shown their highest score for each. The scores range from 0.0 (neutral) to 1.0 (maximum movement). These scores are saved to CoreData and plotted on individual line graphs representing movement trends for each exercise, to help visualize how much movement has been regained.

![](header.png)

## Features

- [x] Feature 1
- [x] Feature 2
- [x] Feature 3
- [x] Feature 4
- [x] Feature 5

## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'YourLibrary'
```

To get the full benefits import `YourLibrary` wherever you import UIKit

``` swift
import UIKit
import YourLibrary
```
#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/YourLibrary.framework` to an iOS project.

```
github "yourUsername/yourlibrary"
```
#### Manually
1. Download and drop ```YourLibrary.swift``` in your project.  
2. Congratulations!  

## Usage example

```swift
import EZSwiftExtensions
ez.detectScreenShot { () -> () in
    print("User took a screen shot")
}
```

## Contribute

We would love you for the contribution to **YourLibraryName**, check the ``LICENSE`` file for more info.

## Meta

Your Name – [@YourTwitter](https://twitter.com/dbader_org) – YourEmail@example.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
