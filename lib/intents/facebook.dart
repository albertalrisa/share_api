import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_api/composers/facebook_story.dart';
import 'package:share_api/intents/base.dart';
import 'package:share_api/share_result.dart';

class Facebook extends ShareIntent {
  Facebook(MethodChannel channel) : super(channel);
  final String handlerModule = 'facebook';

  static String _appId = '';

  void setAppId(String appId) {
    _appId = appId;
  }

  Future<ShareResult> shareToStory(FacebookStoryComposer composer) async {
    try {
      final tempDir = await getTemporaryDirectory();
      String backgroundAssetPath;
      String stickerAssetPath;
      String backgroundAssetName = 'backgroundAsset.png';
      String stickerAssetName = 'stickerAsset.png';

      if (composer.backgroundAsset != null) {
        final Uint8List backgroundAssetAsList = composer.backgroundAsset;
        backgroundAssetPath = '${tempDir.path}/$backgroundAssetName';
        final file = await File(backgroundAssetPath).create();
        file.writeAsBytesSync(backgroundAssetAsList);
      }

      if (composer.stickerAsset != null) {
        final Uint8List stickerAssetAsList = composer.stickerAsset;
        stickerAssetPath = '${tempDir.path}/$stickerAssetName';
        final file = await File(stickerAssetPath).create();
        file.writeAsBytesSync(stickerAssetAsList);
      }

      String topBackgroundColor;
      String bottomBackgroundColor;

      if (composer.topBackgroundColor != null) {
        final sixHexValue = composer.topBackgroundColor.value
            .toRadixString(16)
            .padLeft(8, '0')
            .substring(2);
        topBackgroundColor = '#$sixHexValue';
      }

      if (composer.bottomBackgroundColor != null) {
        final sixHexValue = composer.bottomBackgroundColor.value
            .toRadixString(16)
            .padLeft(8, '0')
            .substring(2);
        bottomBackgroundColor = '#$sixHexValue';
      }

      await channel.invokeMethod('share', {
        'handler': {
          'module': handlerModule,
          'function': 'shareToStory',
        },
        'arguments': {
          'appId': _appId,
          'backgroundAssetPath': backgroundAssetName,
          'backgroundMediaType': composer.backgroundMediaType,
          'stickerAssetPath': stickerAssetName,
          'stickerMediaType': composer.stickerMediaType,
          'topBackgroundColor': topBackgroundColor,
          'bottomBackgroundColor': bottomBackgroundColor,
          'contentUrl': composer.contentUrl,
        }
      });
    } on Exception catch (e) {
//      throw e;
      print(e);
      return ShareResult.failed;
    }
  }
}
