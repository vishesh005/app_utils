import 'package:app_utils/models.dart';
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
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(appDetail.appIdentifier),
                            subtitle: Text(appDetail.category?.toString() ?? "Not Available"),
                            trailing: Text("${appDetail.targetVersion}"),
                          ),
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
                onPressed: () {
                  AppUtils.launchApp(
                      androidPackage: "com.google.android.apps.photos",
                      iosUrlScheme: "whatsapp://",
                      playStoreUrl:
                          "https://play.google.com/store/apps/details?id=com.google.android.apps.photos",
                      appStoreUrl:
                          "https://apps.apple.com/in/app/whatsapp-messenger/id310633997",
                      launchStore: true);
                },
                child: Text("Launch App")),
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
          ])),
    );
  }
}
