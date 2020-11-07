# ios-workshop
This repository goes along with a 1 hour workshop on the topic of how to spend your time most effectively at a hackathon. Checkout the slides linked below.


This is an iOS sample app written in Swift.

# How to make a copy of this starter project
If your team is looking to make an iOS app, this sample app could be a great starting point. Making a copy of this repo will allow you and your team to make changes that will have **no impact on the original repository**. Go ahead, test things out, break things, that's what a hackathon is all about. 

**Steps:**
1. Create a Github account if you don't have one already.
2. Select the `Fork` button at the top left of the Github window. 

**Expected Result:** A copy of this repository should exist on your github account.

### Adding your team members as Collaborators
Only 1 of your team members will need to fork this repository. Everyone else can be added as collaborators. 
1. Click the `Settings` button on the repository you just forked.
2. Select `Manage Access` from the menu.
3. Click the `Invite a collaborator` button and search for a github username. 

**Expected Result:** A team member can now make changes to your repository.

# Setup
Xcode 12 Download Link: https://developer.apple.com/xcode/

Swift 5.3 (comes with Xcode 12)

Apple Computer (Xcode only runs on Apple)

# Overview
<img src="ios-sample-app.gif" alt="sample App" width="350"/>

# Project Structure

## LaunchScreen.storyboard

An app takes a couple seconds to load when the user launches it. During this time, the view you set up in LaunchScreen.storyboard will be shown to the user. The default is a blank white screen. 

## Info.plist
This file contains some important metadata for the app. The following line will be added for for you on creating a new storyboard-based project: 

`Main storyboard file base name: Main`

This indicates that, on app launch, we want to the load the file `Main.storyboard`.

## AppDelegate.swift & SceneDelegate.swift
These classes and several of their methods are provided to us by default when we create a new Xcode project. AppDelegate & SceneDelegate govern the lifecycle of your app, and give you a way to respond to events like the user putting the app in the background, or quitting the app. We don't need to add any custom code to these files for the purposes of this demo. 

## Main.storyboard

Here we have all our the various view controllers / screens and views that we want to use in our app. The first view controller to show will be the one with the entrypoint arrow. 

![Screen Shot 2020-11-07 at 8 54 47 AM](https://user-images.githubusercontent.com/7647185/98443141-705afa00-20d7-11eb-8c35-dcb8f3e45ea4.png)

Storyboards contain navigation, layout and style information - but they are completely static. In order to load data into your views that is dynamic, like a feed of news articles, you need to attach certain views to a custom View Controller class that can handle this logic. 

You can connect a storyboard view controller to a custom class by opening the Inspector panel while the controller is selected, tapping the Identity Inspector icon, and adding the name of your custom controller class to the `Class` field. 

![Screen Shot 2020-11-07 at 9 14 56 AM](https://user-images.githubusercontent.com/7647185/98443526-cfba0980-20d9-11eb-8cb4-cf61577377cb.png)

## Controllers

This app uses 3 custom [View Controller](https://learnappmaking.com/view-controller-uiviewcontroller-ios-swift/) classes to add load data in to the Search, Feed and ArticleDetail screens of the app: 

### FeedTableViewController.swift

FeedTableViewController is attached to the storyboard view for our list of articles. The FeedTableViewController class is responsible for calling the `fetch` method provided by our NewsAPIClient, storing the results of this request (hopefully, an array of articles), and reloading its table view to use this data in its rows.

### ArticleDetailViewController.swift

### SearchViewController.swift


## Services

### NewsAPIClient

This class is responsible for keeping track of where we want to fetch articles from, constructing the URLRequest, and executing the request on an instance of URLSession. The class is also responsible for decoding the raw Data object we get back from our request, and decoding it into the expected response type (i.e. an array of `NewsArticle`s. There's an article in the `Additional Resources` section called `Writing your API Network Client` that will give you more information on how this works. 


## ImageCache.swift

An important detail of how Table Views work on iOS is that they reuse cells. As you scroll downwards, and the first row dissappears off the top of the screen, iOS will repurpose that cell for a row that is about to come into view from the bottom. This makes for very performant table views and smooth scrolling, but it also means we have build our cells remembering that the content we put in them will be removed when when the cell leaves the screen, and reloaded when it reappears. 

This makes loading images into a cell from a URL a bit trickier. We don't want to have to re-fetch the image every time the user scrolls down and the cell temporarily leaves the screen. This is why we've created a simple ImageCache class, that can store images we've already downloaded. Whenever a cell is about to load an image from a URL, it can first check if that image is already loaded in the ImageCache class. If so, it can avoid making an unnecessary url request. 

# Additional Resources
- Getting Started with Storyboards
raywenderlich.com/ios-storyboards-getting-started 
https://developer.android.com/guide/topics/ui
- Human Interface Design guidelines
https://developer.apple.com/design/human-interface-guidelines 
- Writing your API Network Client
https://swiftbysundell.com/articles/creating-generic-networking-apis-in-swift/ 


# Designs
[Figma Sample App Designs](https://www.figma.com/file/jzLY4lzbaxUSEVvcGLn9N5/HackHer-Starter-App?node-id=39%3A525)

Linked are the final designs we came up with for the start project. We also show 3 iterations of progress that was done before arriving at the final designs. Create a Figma account if you want to the full experience which allows you to checkout design specs. 
