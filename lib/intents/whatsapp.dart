import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/src/services/platform_channel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_api/intents/base.dart';
import 'package:share_api/share_result.dart';

class WhatsApp extends ShareIntent {
  final String handlerModule = 'whatsapp';

  WhatsApp(MethodChannel channel) : super(channel);

  Future<int> shareText(String text) async {
    await channel.invokeMethod('share', {
      'handler': {
        'module': handlerModule,
        'function': 'shareText',
      },
      'arguments': {
        'text': text,
        'type': 'text/plain',
      }
    });
    return ShareResult.undefined;
  }

  Future<int> shareImage(Uint8List image,
      {String imageType = "image/*", String prompt}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      String imageName = 'share.jpg';
      String imagePath = '${tempDir.path}/$imageName';

      final file = await File(imagePath).create();
      file.writeAsBytesSync(image);

      var res = await channel.invokeMethod('share', {
        'handler': {
          'module': handlerModule,
          'function': 'shareImage',
        },
        'arguments': {
          'image_url': imageName,
          'type': imageType,
        }
      });
      print(res);
    } on Exception catch (e) {
      print(e);
      return ShareResult.failed;
    }
    return ShareResult.undefined;
  }

  @override
  Future<bool> isPackageInstalled() async {
    return await channel.invokeMethod('isInstalled', {
      'handler': {
        'module': handlerModule,
      }
    });
  }
}
