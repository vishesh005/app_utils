import 'dart:io';

import 'package:app_utils/models.dart';
import 'package:app_utils/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_utils/app_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('App Util Example'),
          ),
          body: Center(
            child: FutureBuilder<List<BundleInfo>>(
              future: AppUtils.getInstalledApps(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BundleInfo>> snapShot) {
                if (snapShot.data != null) {
                  return ListView.builder(
                      itemCount: snapShot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final appDetail = snapShot.data![index];
                        return GestureDetector(
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(appDetail.appName),
                              subtitle: Text("${appDetail.appIdentifier}"),
                            ),
                          ),
                          onTap: (){
                            AppUtils.launchApp(
                                androidPackage: appDetail.appIdentifier,
                                iosUrlScheme: "whatsapp://",
                                playStoreUrl:
                                "https://play.google.com/store/apps/details?id=${appDetail.appIdentifier}",
                                appStoreUrl:
                                "https://apps.apple.com/in/app/whatsapp-messenger/id310633997",
                                launchStore: true);
                          },
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          floatingActionButton:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                onPressed: () async {
                   final settings = Platform.isAndroid ?
                       AndroidSettings(settings: AndroidSettingsType.MAIN) :
                       IOSSettings(settings: IOSSettignsType.MAIN);
                    await AppUtils.openDeviceSettings(settings);
                },
                child: Text("Open Settings")),
            Builder(builder: (BuildContext builderContext) {
              return ElevatedButton(
                  onPressed: () async {
                    final canLaunch = await AppUtils.canLaunchApp(
                        androidPackageName: "com.whatsapp",
                        iOSUrlScheme: "whatsapp://");
                    ScaffoldMessenger.of(builderContext).showSnackBar(SnackBar(
                      content: Text("Can launch application : $canLaunch"),
                    ));
                  },
                  child: Text("Can Launch App"));
            }),
                Builder(
                  builder:(builderContext) => ElevatedButton(
                      onPressed: () async {
                         final deviceInfo = await AppUtils.getCurrentDeviceInfo();
                         final appInfo = await AppUtils.getCurrentAppInfo();
                         final launchData = await AppUtils.readLaunchedData();
                         showCupertinoModalPopup(
                           context: builderContext, builder: (context){
                           return Material(
                             child: Container(
                               height: 100,
                               width: 500,
                               child: Column(
                                 children: [
                                   Text("Name : ${deviceInfo.name}", style: TextStyle(fontWeight: FontWeight.w600),),
                                   Text("Id : ${deviceInfo.id}", style: TextStyle(fontWeight: FontWeight.w600)),
                                   Text("Brand : ${deviceInfo.brand}", style: TextStyle(fontWeight: FontWeight.w600)),
                                   Text("Os Version : ${deviceInfo.osVersion}", style: TextStyle(fontWeight: FontWeight.w600))
                                 ],
                               ),
                             ),
                           );
                         });
                      },
                      child: Text("Device Info")),
                )
          ])),
    );
  }
}
