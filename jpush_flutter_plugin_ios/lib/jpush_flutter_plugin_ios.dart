// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';

/// The iOS implementation of [JpushFlutterPluginPlatform].
class JpushFlutterPluginIOS extends JpushFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('plugins.kimmy.me/jpush_flutter_plugin_ios');

  /// Registers this class as the default instance of
  /// [JpushFlutterPluginPlatform]
  static void registerWith() {
    JpushFlutterPluginPlatform.instance = JpushFlutterPluginIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
