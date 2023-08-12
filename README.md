# App Utils
  
[![Pub Package](https://img.shields.io/badge/pub-v0.6-blue)](https://pub.dartlang.org/packages/app_utils)
[![Pub Package](https://img.shields.io/badge/Licensce%20-MIT-green)](https://opensource.org/licenses/MIT)



An application plugin that offers utility functions designed for use on both the Android and iOS platforms.
 
## Installation

###   Android

In the Android context, you have the option to either declare the QUERY_ALL_PACKAGES permission (providing a wider scope of visibility for app packages) or specify packages within the <queries> tag in your AndroidManifest.xml file.

  Note: Using QUERY_ALL_PACKAGES permission could result in the potential rejection of your app on the Play Store if your app lacks essential core functionalities that necessitate a broader package visibility.
        For instance, applications like antivirus software that require broader visibility to scan all apps on the device. If your app does not inherently demand QUERY_ALL_PACKAGES permission as a core functionality,
        it is recommended to explore the option of using the **queries** tag instead.
  

     <!-- Only for core functionality apps like antivirus, device security, etc. -->
    <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/> 

      OR 

    <!-- For all common use cases -->
    <queries> 
     <package android:name="com.whatsapp.businessapp"/> 
     <package android:name="in.techbyvishesh.myapp"/> 
     </queries>


###  iOS

In Ios, for opening the target app from your app, you need to provide the URL scheme of the target app.

To know more about URLScheme in iOS, please visit below link. <br> https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app

In your deployment target is greater than or equal to 9 then also need to update another app information in your Info.plist.

    <key>LSApplicationQueriesSchemes</key>
    <array>
    <string>whatsapp</string> // url scheme
    </array>

<br>
<img src="https://i.ibb.co/ZH3D7nP/ezgif-com-gif-maker.gif" height="500" width="300">


## List of supported functions

| Function                               | Description                                                                                                                                                                                                                                                                                                                          |
|----------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| launchApp (Android and iOS)            | Initiates the launch of the specified application using the provided package name on Android and the URLScheme on iOS.                                                                                                                                                                                                               |
| getInstalledApps (Android)             | Returns a list of the installed applications on your Android device.                                                                                                                                                                                                                                                                 |
| canLaunchApp (Android & iOS)           | Verifies the application's launch feasibility.                                                                                                                                                                                                                                                                                       |
| getCurrentDeviceInfo (Android and iOS) | Returns current device information.                                                                                                                                                                                                                                                                                                  |
| getCurrentAppInfo (Android and iOS)    | Returns information about your application.                                                                                                                                                                                                                                                                                          |
| readLaunchedData (Android and iOS)     | Allows reading sender application data. On Android, it gathers data from the activity intent, whereas on iOS, it acquires data from the URL Scheme.                                                                                                                                                                                  |
| openDeviceSettings (Android and iOS)   | Initiates access to the settings page within your application.<br> - For Android, it offers diverse settings choices.<br> - However, in iOS, owing to Apple's limitations, it exclusively provides access to the primary settings page. For more information, please [visit here](https://developer.apple.com/forums/thread/100471). |



## Upcoming features

## Features

1. **requestDeviceAuth** 🌟
        - Unleash your device's potential with a touch! Open the device unlock screen on both Android and iOS platforms.

2. **playAudio** 🎶
        - Immerse yourself in a world of sound. Seamlessly play audio on your device with just a tap.

3. **openDeviceSensor** 🌈
        - Get closer to the magic of your device. Experience the power of open device sensors like never before.

Explore these exciting functionalities and bring a new dimension to your app's capabilities!

## Contributors

A big shoutout to the following amazing contributors who have helped shape and improve this project:

- [Vishesh Pandey](https://github.com/vishesh005)
- [Ashwin Ramakrishnan](https://github.com/ashwinkey04)

Join our ranks by contributing to this project! Every line of code makes a difference. 🙌


## Bugs or Requests
If the code genie escapes its lamp and causes trouble, just give a shout by opening an issue. Got a brainwave for a cool feature? Toss the idea into a GitHub ticket, and I'll whip out my magnifying glass 🔍. And hey, pull requests? They're like virtual high-fives! 🙌




