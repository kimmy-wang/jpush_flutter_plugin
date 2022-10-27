// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';

/// An implementation of [JpushFlutterPluginPlatform] that uses method channels.
class MethodChannelJpushFlutterPlugin extends JpushFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('plugins.kimmy.me/jpush_flutter_plugin');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
