import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:share_api/share_api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
                    RawMaterialButton(
                      onPressed: () {
                        print('shareimage called');
                        ShareApi.shareImage();
                      },
                      fillColor: Colors.lightBlue,
                      splashColor: Colors.lightBlueAccent,
                      child: Text(
                        'Share File Through API',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        print('sharetext called');
                        ShareApi.shareText();
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
