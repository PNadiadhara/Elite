# Elite
A sports application which tracks your casual competitive games using Elo-Ranking and your location. Become an Elite when you win the most games out of your friends and other people you meet at local parks. 


## Introduction 
We here at Elite would like to know a few things. Do you like to compete? Do you love winning and getting recognition for it?
Do you like to show off to your friends how much better you are than them? If any or all of those answers were yes than download this app right now!!! This is a platform where you can truly brag even more when you win games at your local parks. We show you the number of wins an losses at each park and who you play against, so you can compare and boast to others how nice you are on the court. We even have this incentive where if you win a great number of games on the app you get placed in a ranking category only the best of the best can be in. That ranking status is what is known as Elite. 


We challenge users to get the whole community involved and compete against each other in casual competitive games all throughout the five boroughs. We plan on changing the game when it comes to competition 


## Where People Compete 

![Parks!](https://user-images.githubusercontent.com/43886009/60988925-b735b580-a312-11e9-8dc9-959c3c46ec1c.png)


We have users all over the boroughs putting in that work to gain Elite status. It's like they say ball is life. Come to the courts and start winning.

## Technologies

* Swift 4.2+
* Xcode 10.2+
* Frameworks/Pods: GoogleMapkit, Elo Ranking(our own Cocoapod), Firebase, KingFisher, SnapchatKit, Bit-MojiKit, Multipeer Connectivity, Facebook SDK‬,


## Table of contents
* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [App Background](#app-background)
* [Views](#views)
* [Features](#features)
* [Status](#status)
* [Inspiration](#inspiration)
* [Contributors](#contributors)

## Getting Started
If you are instrested in downloading this project please look at the prerequisites and installations for the app. You can alos keep scrolling to look at more about the app

### Prerequisites
Here is a link on how to properly download install snapkit and adjust the settings in your Xcode project
- [Snapkit Installation](https://medium.com/adventures-in-ios-mobile-app-development/snapchat-snap-kit-sdk-tutorial-for-ios-swift-311863074bab)
Also inoder for you to use Google Maps api you must get a Key. See Link
-[Google Developers](https://developers.google.com/maps/documentation/ios-sdk/start)

## Installation
```bash
pod 'SnapSDK'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
pod 'Kingfisher'
source 'https://github.com/CocoaPods/Specs.git'
pod 'GoogleMaps'
pod 'GooglePlaces'
```
## App Background
It's hard to find new competition for the casual player. In most analog games there is no casual competitive scene. Finding other players who would like an equal challenge but don’t have the time, or wouldn’t like to commit the time for more formal competition formats can be difficult. 

## Marketing Strategy
Elite is an app targeted towards preteens, teens, and young adults. Elite is user-friendly and interactive. It gives young people a new way to play literally any game they want with an added competition aspect. Elite can be played as a single, double, multiplayer game with an optional Witness to corroborate who won. You can add friends and play a customized private game. Invite challengers to a game of your choosing and if you defeat enough players you   Elite status! Once you achieve Elite status people can come and challenge you to overthrow your Elite status.





## Views
* Login
  - The User is able to login to the app with a email and a password (FMO login using, Gmail & Facebook)
* Create Account
  - The User is able to create and account  with a username, email and a password (FMO login using, Gmail & Facebook)
* Map 
  - Displays a collection of annotations on the park View.
  - The user is able to toggle between which parks have 
  - When a user selects a google marker it shows more about the map
   * Game Selection
   - The map view annotations can be changes by selecting the bar button item for called Game
   - Contains a list of the games you can choose, image and the name of game
   * Detail Popup
   - when the collection of annotations changes the user can select the actual anotation and it will have
* Feed (Next Version)
   - Displays a list of the acheivements you and your friends have and the games you played
  * Detail
* Leader baord (Next Version)
   - Displays a collection view at the top that shows you and the rank you are in that sport
   - At the bottom is of list of everyone who play that sport and is organized by ranking 
  * Challenge Elite Popup
    - when you select the user icon you are able request a challenge an Elite 
* Create Game
   - The user has the ability select a gametype (1 on 1, 2 vs 2, & 5 vs 5)
   - The user has the ability to select the middle icon to choose the type of game (Basketball & Handball)
   -  There is a QR code for each profile for users when they want to be added to the game
  * QR Popup (Next Version)
   - User is able to add a player using their profile QRCode
* Versus View For (1 on 1, 2 vs 2, & 5 vs 5)
  - Has a view of the host and the player(s) "depending on the gametype you choose"
  - When the user taps on the player(s) image icon they add a player (They are able to add a player with a QR Code, through search or theough their friends list)
  - Once when the players have been selected they players play their game
  - After the game is over they confirm on who won 
* Profile View
  - Shows  the users rank info and three tab sections simiular to instagram
    - First section is a list of the games they played
    - Second section is the list of the achivements 
    - Third section is the list of your friends 
    - Users are request a match with an elite on if you are one
    - Click on the setting and do more alterication 
 * QRCode
    - Each QR code is accoisted with the user so when they join a match it is faster for them to join a game.  
 
 
 ## Next Steps
 
 ![Eilte Demo Deck.pdf](https://github.com/Ibraheemraw/eReminder/files/3378688/Eilte.Demo.Deck.pdf)
 
Adding more games increases our audince, not everyone likes to play handball and basketball. Based off the feedback, we will get from our users,  we will add those sports and and or games requested. The Elite of the borogugh concept is something our beta users recommend to us to implement and you know what they say, “Give the people what the want”. Also having a platform where we give you the organized tornament structure just makes it easer for the players and facilitators

## Follow us

![FOLLOW](https://user-images.githubusercontent.com/43886009/60990607-d0d8fc00-a316-11e9-9255-da579d720dc0.png)
 
## Contributors
- [Manolova Yusuf](https://github.com/manolovayusuf)
- [Leandro Wauters](https://github.com/leandrowauters)
- [Ibraheem Rawlinson](https://github.com/Ibraheemraw)
- [Pritesh Nadiadhara](https://github.com/PNadiadhara)

