import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:share_api/composers/facebook_story.dart';
import 'package:share_api/share_api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Map<String, String> isInstalled = {
    "facebook": "unknown",
    "instagram": "unknown",
    "system": "unknown",
  };

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getInstalledPackages();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ShareApi.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> getInstalledPackages() async {
    try {
      isInstalled["facebook"] =
          await ShareApi.viaFacebook.isPackageInstalled() ? "true" : "false";
    } on PlatformException {
      isInstalled["facebook"] = 'Failed to get facebook status.';
    }
    try {
      isInstalled["instagram"] =
          await ShareApi.viaInstagram.isPackageInstalled() ? "true" : "false";
    } on PlatformException {
      isInstalled["instagram"] = 'Failed to get instagram status.';
    }
    try {
      isInstalled["system"] =
          await ShareApi.viaSystemUI.isPackageInstalled() ? "true" : "false";
    } on PlatformException {
      isInstalled["system"] = 'Failed to get system status.';
    }

    setState(() {});

    if (!mounted) return;
  }

  bool _isLoading = false;

  void shareToFacebookStory() async {}

  void shareToInstagramStory() async {
    var image = await rootBundle.load('assets/image.jpg');
    var bytedata = image.buffer.asUint8List();
    var fou = await rootBundle.load('assets/fou.png');
    var foudata = fou.buffer.asUint8List();
    var composer = FacebookStoryComposer(
//      backgroundAsset: bytedata,
//      backgroundMediaType: 'image/*',
      stickerAsset: foudata,
      stickerMediaType: 'image/*',
      topBackgroundColor: Color(0xFFFF0000),
      bottomBackgroundColor: Color(0xFF00FF00),
    );
    ShareApi.viaInstagram.shareToStory(composer).then((response) {
      print('Instagram $response');
    });
  }

  void shareToStory() async {
    var image = await rootBundle.load('assets/image.jpg');
    var bytedata = image.buffer.asUint8List();
    ShareApi.viaFacebook.setAppId("1241515685991259");
    var composer = FacebookStoryComposer(
      backgroundAsset: bytedata,
      backgroundMediaType: 'image/*',
//      stickerAsset: bytedata,
//      stickerMediaType: 'image/*',
//      topBackgroundColor: Color(0xFFFF0000),
//      bottomBackgroundColor: Color(0xFF00FF00),
    );
    ShareApi.viaFacebook.shareToStory(composer).then((response) {
      print(response);
    });
//    var response = await ShareApi.viaFacebook.shareToStory(composer);
//    print("Facebook $response");
  }

  void shareImage() async {
    setState(() {
      _isLoading = true;
    });
    var image = await rootBundle.load('assets/image.jpg');
    var bytes = image.buffer.asUint8List();
//    var httpClient = HttpClient();
//    var request = await httpClient.getUrl(Uri.parse(
//        'https://i.pinimg.com/originals/80/39/74/80397406370badaca3493ce4e84d4786.jpg'));
//    var response = await request.close();
//    var bytes = await consolidateHttpClientResponseBytes(response);
    ShareApi.viaSystemUI.shareImage(bytes, imageType: 'image/png');

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('assets/image.jpg'),
              Container(
                alignment: Alignment(0.5, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children:
                          ["facebook", "instagram", "system"].map((handler) {
                        return Text(isInstalled[handler]);
                      }).toList(),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        shareToInstagramStory();
                      },
                      fillColor: Colors.lightBlue,
                      splashColor: Colors.lightBlueAccent,
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              'Share File To Instagram Story',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        shareToStory();
                      },
                      fillColor: Colors.lightBlue,
                      splashColor: Colors.lightBlueAccent,
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              'Share File To Facebook Story',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        shareImage();
                      },
                      fillColor: Colors.lightBlue,
                      splashColor: Colors.lightBlueAccent,
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              'Share File Through API',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        ShareApi.viaSystemUI.shareText("Kemosaba!");
                      },
                      fillColor: Colors.lightBlue,
                      splashColor: Colors.lightBlueAccent,
                      child: Text(
                        'Share Text Through API',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Center(child: new Text('Running on: $_platformVersion\n')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
