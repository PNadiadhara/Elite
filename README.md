# Elite
The app Designed to create healthy competitve competition amongst users

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
   - when the collection of annotations changes the user can select the actual anotation and it will have:
* Parkboard 
   -  
* Feed
   - Displays a list of the acheivements you and your friends have and the games you played
  * Detail
* Leader baord
   - Displays a collection view at the top that shows you and the rank you are in that sport
   - At the bottom is of list of everyone who play that sport and is organized by ranking 
  * Challenge Elite Popup
    - when you select the user icon you are able request a challenge an Elite 
* Create Game
   - The user has the ability select a gametype (1 on 1, 2 vs 2, & 5 vs 5)
   - The user has the ability to select the middle icon to choose the type of game (Basketball & Handball)
   -  There is a QR code for each profile for users when they want to be added to the game
  * QR Popup
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
 
## Contributors
- [Manolova Yusuf](https://github.com/manolovayusuf)
- [Leandro Wauters](https://github.com/leandrowauters)
- [Ibraheem Rawlinson](https://github.com/Ibraheemraw)
- [Pritesh Nadiadhara](https://github.com/PNadiadhara)

