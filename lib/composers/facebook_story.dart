import 'dart:typed_data';
import 'dart:ui';

class FacebookStoryComposer {
  Uint8List backgroundAsset;
  String backgroundMediaType;

  Uint8List stickerAsset;
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
