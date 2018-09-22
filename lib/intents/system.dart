import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_api/intents/base.dart';
import 'package:path/path.dart' as Path;
import 'package:share_api/share_result.dart';

class System extends ShareIntent {
  System(MethodChannel channel) : super(channel);
  final String handler = 'system';

  Future<ShareResult> shareText(String text) async {
    final String result = await channel.invokeMethod('share', {
      'handler': 'system',
      'type': 'text',
      'argument': {'text': text}
    });
    return ShareResult.undefined;
  }

  Future<ShareResult> shareFile(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      String filename = Path.basename(file.path);
      String filePath = '${tempDir.path}/$filename';

      file.copy(filePath);

      await channel.invokeMethod('share', {
        'handler': 'system',
        'type': 'file',
        'argument': {'file_url': file}
      });
    } on Exception catch (e) {
//      throw e;
      print(e);
      return ShareResult.failed;
    }
    return ShareResult.undefined;
  }

  Future<ShareResult> shareImage(Image image) async {
    try {
      final tempDir = await getTemporaryDirectory();
      String imageName = 'share.png';
      String imagePath = '${tempDir.path}/$imageName';

      final ByteData bytes = await image.toByteData();
      final Uint8List list = bytes.buffer.asUint8List();

      final file = await File(imagePath).create();
      file.writeAsBytesSync(list);

      await channel.invokeMethod('share', {
        'handler': 'system',
        'type': 'image',
        'argument': {'image_url': imageName}
      });
    } on Exception catch (e) {
//      throw e;
      print(e);
      return ShareResult.failed;
    }
    return ShareResult.undefined;
  }
}
