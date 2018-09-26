import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

abstract class ShareIntent {
  MethodChannel channel;
  ShareIntent(this.channel);

  Future<bool> isPackageInstalled();

  Future<Uint8List> getBytesFromFile(File file) async {
    final bytes = await file.readAsBytes();
    return bytes;
  }

  Future<Uint8List> getBytesFromBytesData(ByteData byteData) async {
    return byteData.buffer.asUint8List();
  }
}
