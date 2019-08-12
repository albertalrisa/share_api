import 'dart:typed_data';
import 'dart:ui';

class StoryComposer {
  Uint8List backgroundAsset;
  String backgroundMediaType;

  Uint8List stickerAsset;
  String stickerMediaType;

  Color topBackgroundColor;
  Color bottomBackgroundColor;

  String contentUrl;

  String backgroundFile;
  String stickerFile;

  StoryComposer(
      {this.backgroundAsset,
      this.backgroundMediaType,
      this.stickerAsset,
      this.stickerMediaType,
      this.topBackgroundColor,
      this.bottomBackgroundColor,
      this.contentUrl,
      this.backgroundFile,
      this.stickerFile}) {
    if (backgroundAsset == null &&
        stickerAsset == null &&
        backgroundFile == null &&
        stickerFile == null) {
      throw new Exception(
          'Background asset or file, sticker asset or file, or both must be provided!');
    }
  }
}
