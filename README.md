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

Our app, NewsAppDemo, uses [NewsAPI](https://newsapi.org/docs) to load articles that match the user's search. 

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

### SearchViewController.swift

We've already set up this screen in Main.storyboard to have a search bar, a title label and a button. We've also added a navigation transition to the main Feed screen that will occur when the user taps the Go button. If we run the app without setting a custom class for this screen, everything will work as expected, EXCEPT that our FeedTableViewController won't know what search query was typed into the search bar on the previous screen. We need a custom class for SearchViewController to pass that information on to the next screen before the transition occurs. 

The `SearchViewController` class is uses outlets to reference the search bar and Go button on the storyboard. We set up these outlets by CTRL + dragging from the view in the storyboard to the line of code in our custom class where we want the reference to go.  Once SearchViewController has references to these to the search bar, it can assign itself as the delegate of the search bar, so that it will be informed whenever the user returns from a search. We can then trigger the Go button when the user hits enter, the same as if it had been tapped. 

This is the crucial code in SearchViewController, that intercepts the navigation to the FeedTableViewController, and passes along whatever search query the user had typed in.  
```
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let feedController = segue.destination as? FeedTableViewController {
            feedController.searchQuery = searchBar.text
        }
    }
```

### FeedTableViewController.swift

FeedTableViewController is attached to the storyboard view for our list of articles. The FeedTableViewController class is responsible for calling the `fetch` method provided by our NewsAPIClient with the search query from the previous screen, storing the results of this request (hopefully, an array of articles), and reloading its table view to use this data in its rows.

FeedTableViewController also handle's the event where a user taps on one of the table view rows. Our table view is already hooked up in the storyboard to transition to our Detail screen when the user taps on one of its rows. But before that transition happens, we need to figure out which article corresponds to the tapped row, and pass that article to the Detail screen's controller so it can populate its fields with the right information. 

### ArticleDetailViewController.swift

We need a custom class for the Article Detail view so that we can populate the screen with information specific to a specific article. ArticleDetailViewController expects that it will be provided with the NewsArticle it needs by the time it loads. On viewDidLoad, this article is used to populate the various labels in the Detail screen. 

We also use ArticleDetailViewController to handle the case where a user taps on the 'Read more' link, by getting the correct URL for the specific article, and opening it in the Safari app. 

## Services

### NewsAPIClient

This class is responsible for keeping track of where we want to fetch articles from, constructing the URLRequest, and executing the request on an instance of URLSession. The class is also responsible for decoding the raw Data object we get back from our request, and decoding it into the expected response type (i.e. an array of `NewsArticle`s. There's an article in the `Additional Resources` section called `Writing your API Network Client` that will give you more information on how this works. 


### ImageCache.swift

An important detail of how Table Views work on iOS is that they reuse cells. As you scroll downwards, and the first row dissappears off the top of the screen, iOS will repurpose that cell for a row that is about to come into view from the bottom. This makes for very performant table views and smooth scrolling, but it also means we have build our cells remembering that the content we put in them will be removed when when the cell leaves the screen, and reloaded when it reappears. 

This makes loading images into a cell from a URL a bit trickier. We don't want to have to re-fetch the image every time the user scrolls down and the cell temporarily leaves the screen. This is why we've created a simple ImageCache class, that can store images we've already downloaded. Whenever a cell is about to load an image from a URL, it can first check if that image is already loaded in the ImageCache class. If so, it can avoid making an unnecessary url request. 

## Fonts
This folder stores the custom font .ttf files we want to use in our app. These files can be dragged and dropped into your project (make sure you check 'Add to target NewsAppDemo in the dialog that pops up when you drop the files). The `Additional Resources` section has more information about how you can use these fonts in your storyboard views. 


## Extensions

There are a few handy helper methods that we have added as extensions to the classes that use them. 

### UIImage+GIF.swift

Understanding this code is out of the scope of this tutorial! However, there are some great libraries you can add to your project that will handle this for you. For example, https://github.com/swiftgif/SwiftGif. In order to use this library, or a different one, you will need to follow instructions for setting up your project to use [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) or [Carthage](https://github.com/Carthage/Carthage). 

### UIView+Constraints

iOS has two systems for setting up layout rules: Frames and Autolayout. You can compare these two approaches [here](https://fluffy.es/frame-vs-autolayout/), but for storyboard-based apps you're going to be using Autolayout. 

Autolayout relies on `NSLayoutConstraint`s. Each constraint is a rule for how the width, or height, or edge of one view should appear relative to another view. Since NSLayoutConstraints have to be setup individually, one for each edge or dimension of a view, it can be helpful to setup some methods that activate a group of commonly used constraints. 

In our example, we've added an extension method to UIView called `func fill(_ view: UIView)`. Calling the method on a view will add the 4 constraints needed to pin its edges to those of the second view that is passed as an argument. 


### UIViewController+Alerts

Inline errors are great, but they take a lot more time to build, since you have to accomodate for hiding/showing them in your layout. The simplest way to display errors, or other quick information snippets to the user, is usually with the built-in UIAlertController that can be presented from any other View Controller. 

This extension method gives us a quick way to display a simple error alert that can be dismissed from any of our view controllers. 

# Additional Resources
- Getting Started with Storyboards
raywenderlich.com/ios-storyboards-getting-started 
https://developer.android.com/guide/topics/ui
- Human Interface Design guidelines
https://developer.apple.com/design/human-interface-guidelines 
- Writing your API Network Client
https://swiftbysundell.com/articles/creating-generic-networking-apis-in-swift/ 
- Adding custom fonts to your project
https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app

# Designs
[Figma Sample App Designs](https://www.figma.com/file/jzLY4lzbaxUSEVvcGLn9N5/HackHer-Starter-App?node-id=39%3A525)

Linked are the final designs we came up with for the start project. We also show 3 iterations of progress that was done before arriving at the final designs. Create a Figma account if you want to the full experience which allows you to checkout design specs. 
