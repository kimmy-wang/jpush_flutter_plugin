// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';

JpushFlutterPluginPlatform get _platform => JpushFlutterPluginPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}

/// 设置调试模式 API
/// 该接口需在 init 接口之前调用，避免出现部分日志没打印的情况。
/// 多进程情况下建议在自定义的 Application 中 onCreate 中调用。
/// @param debugMode debugMode 为 true 则会打印 debug 级别的日志，
///     false 则只会打印 warning 级别以上的日志
Future<void> setDebugMode({bool debugMode = false}) async {
  return _platform.setDebugMode(debugMode: debugMode);
}

/// 初始化推送服务 API
/// 调用了本 API 后，JPush 推送服务进行初始化。
/// 建议在自定义的 Application 中的 onCreate 中调用。
Future<void> init(
  String appKey,
  String channel,
  JpushFlutterPluginHandler handler,
) async {
  return _platform.init(appKey, channel, handler);
}
