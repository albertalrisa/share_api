import 'package:flutter/services.dart';

abstract class ShareIntent {
  MethodChannel channel;
  ShareIntent(this.channel);
}
