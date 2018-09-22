import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_api/intents/base.dart';
import 'package:share_api/share_result.dart';

class Facebook extends ShareIntent {
  Facebook(MethodChannel channel) : super(channel);
  final String handler = 'facebook';

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
        final ByteData backgroundAssetAsBytes =
            await composer.backgroundAsset.toByteData();
        final Uint8List backgroundAssetAsList =
            backgroundAssetAsBytes.buffer.asUint8List();
        backgroundAssetPath = '${tempDir.path}/$backgroundAssetName';
        final file = await File(backgroundAssetPath).create();
        file.writeAsBytesSync(backgroundAssetAsList);
      }

      if (composer.stickerAsset != null) {
        final ByteData stickerAssetAsBytes =
            await composer.stickerAsset.toByteData();
        final Uint8List stickerAssetAsList =
            stickerAssetAsBytes.buffer.asUint8List();
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
        'handler': handler,
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

class FacebookStoryComposer {
  Image backgroundAsset;
  String backgroundMediaType;

  Image stickerAsset;
  String stickerMediaType;

  Color topBackgroundColor;
  Color bottomBackgroundColor;

  String contentUrl;

  FacebookStoryComposer(
      {this.backgroundAsset,
      this.backgroundMediaType,
      this.stickerAsset,
      this.stickerMediaType,
      this.topBackgroundColor,
      this.bottomBackgroundColor,
      this.contentUrl}) {
    if (backgroundAsset == null && stickerAsset == null) {
      throw new Exception(
          'Background asset, sticker asset, or both must be provided!');
    }
  }
}
