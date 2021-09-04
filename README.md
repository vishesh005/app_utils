# App Utils
  
[![Pub Package](https://img.shields.io/badge/pub-v0.3-blue)](https://pub.dartlang.org/packages/app_utils)
[![Pub Package](https://img.shields.io/badge/Licensce%20-MIT-green)](https://opensource.org/licenses/MIT)



  Application  plugin which provides utility functions for
  Android and iOS.
 
## Installation

###  Android
 
No additional setup is required.

###  iOS

In Ios, for opening the target app from your app, you need to provide the URL scheme of the target app.

To know more about URLScheme in iOS, please visit below link. <br> https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app

In your deployment target is greater than or equal to 9 then also need to update another app information in your Info.plist.

    <key>LSApplicationQueriesSchemes</key>
    <array>
    <string>whatsapp</string> // url scheme
    </array>

<br>
<img src="https://i.imgur.com/nUZoOdP.gif" height="500" width="300">


## List of supported functions
1. <b>launchApp (Android and iOS)</b> : <br>   It opens target application from provided package name in Android and URLScheme in iOS.
<br>
<br>   
2. <b>getInstalledApps (Android)</b> : <br>
    It returns a list of the installed applications from your devices.
<br>
<br>
3. <b>canLaunchApp (Android & iOS)</b> : <br> It checks application is launchable or not.
   <br>
   <br>
4. <b>getCurrentDeviceInfo (Android and iOS)</b> : <br> It returns current device information.
   <br>
   <br>
5. <b>getCurrentAppInfo (Android and iOS)</b> : <br> 
    It returns your application information.
<br>
<br>   
6. <b>readLaunchedData (Android and iOS)</b> : <br>
    It allows us to read sender application data. In android, it reads data from activity intent but in iOS, it reads data from URL Scheme.

## Upcoming features

1. <b>openThread</b> : Allows you to work with system threads.
2. <b>closeThread</b> : Allows you to close or dispose system threads.
3. <b>sendDataToThread</b> :  Allows you to send data from one thread to another.


## Bugs or Requests
If you encounter any problems feel free to open an issue. 
If you feel the library is missing a feature, please raise a ticket on <a href ="https://github.com/vishesh005/app_utils/issues">
GitHub</a> and I'll look into it. Pull request are also welcome.




