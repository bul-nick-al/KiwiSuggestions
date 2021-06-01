## About the app

A simple iOS app that shows 5 interesting flights to destinations you can visit with kiwi.com

## Technical details

The app consists of several modules that are all imported by the `KiwiSugeestions` module. The only external dependemcy used is the [TinyConstraints](https://github.com/roberthein/TinyConstraints) library, that provides some syntactic sugar for the standard `NSLayoutConstraint` (the ui-related code looks much cleaner and more readable)

For the main list with suggestions I used `UICollectionView` with a custom layout. Every suggestion can be tapped to reveal a different view controller with more information about the flight. I use a custom `UIViewControllerTransitioningDelegate` to provide a better experience when opening and closing the view controller. Finally, I use a custom class that implements `UIViewControllerInteractiveTransitioning` to provide an interactive animation when a user swipes the flight details view down.

The app will requiest your location to show the most relevant flights. If you don't give the permission, the default location will be used. The suggestions update every day (and it will require more time to get the location), otherwise the flights are retreived from cache and load instantly

## How to install

Since there are several modules, if you want to run the app on a device, you need to choose you account to sign it in every module. This can be done in the `Signing and Capablilities` tab of each module's settings. 

## Demo

Preview 1 | Preview 2 
--- | ---
![](https://github.com/bul-nick-al/KiwiSuggestions/blob/main/preview/1.png) | ![](https://github.com/bul-nick-al/KiwiSuggestions/blob/main/preview/2.png)


Preview 3 | Preview 4
--- | ---
![](https://github.com/bul-nick-al/KiwiSuggestions/blob/main/preview/3.gif) |![](https://github.com/bul-nick-al/KiwiSuggestions/blob/main/preview/4.gif) 
