import 'package:flutter/services.dart';
import 'package:share_api/intents/facebook.dart';
import 'package:share_api/intents/instagram.dart';
import 'package:share_api/intents/system.dart';

class ShareApi {
  static const channel_name = 'com.albertalrisa.flutter.plugins/share_api';

  static const MethodChannel _channel = const MethodChannel(channel_name);

  static final viaSystemUI = SystemUI(_channel);
  static final viaFacebook = Facebook(_channel);
  static final viaInstagram = Instagram(_channel);
}
