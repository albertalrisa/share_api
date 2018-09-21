import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ShareApi {
  static const channel_name = 'com.albertalrisa.flutter.plugins/share_api';

  static const MethodChannel _channel = const MethodChannel(channel_name);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> shareText() async {
    final String result = await _channel.invokeMethod('shareText');
    return result;
  }

  static Future<Null> shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image.jpg');
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.jpg').create();
      file.writeAsBytesSync(list);

      await _channel.invokeMethod('shareFile', {'uri': 'image.jpg'});
    } catch (e) {
      throw e;
    }
  }
}
