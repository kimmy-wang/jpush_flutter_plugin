// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';

/// The Android implementation of [JpushFlutterPluginPlatform].
class JpushFlutterPluginAndroid extends JpushFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('plugins.kimmy.me/jpush_flutter_plugin_android');

  /// Registers this class as the default instance of
  /// [JpushFlutterPluginPlatform]
  static void registerWith() {
    JpushFlutterPluginPlatform.instance = JpushFlutterPluginAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<void> setDebugMode({bool debugMode = false}) {
    return methodChannel
        .invokeMethod<void>('setDebugMode', {'debugMode': debugMode});
  }

  @override
  Future<void> setAuth({bool auth = false}) {
    return methodChannel.invokeMethod<void>('setAuth', {
      'auth': auth,
    });
  }

  @override
  Future<void> init(
    String appKey,
    String channel,
    JpushFlutterPluginHandler handler,
  ) {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      handler(call);
    });
    return methodChannel.invokeMethod<void>('init', {
      'appKey': appKey,
      'channel': channel,
    });
  }

  @override
  Future<void> setAlias(int sequence, String alias) {
    return methodChannel.invokeMethod<void>('setAlias', {
      'sequence': sequence,
      'alias': alias,
    });
  }

  @override
  Future<void> deleteAlias(int sequence) {
    return methodChannel.invokeMethod<void>('deleteAlias', {
      'sequence': sequence,
    });
  }
}
