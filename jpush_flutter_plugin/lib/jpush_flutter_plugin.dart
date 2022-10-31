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

/// 隐私确认接口
///
/// 确保 App 首次启动时，在用户阅读您的《隐私政策》并取得用户授权之后，
/// 才调用初始化函数 JPushInterface.init()，此时 SDK 才会真正采集设备信息，并上报。
/// 如果没有在用户阅读您的《隐私政策》时取得用户授权，或者用户不同意您的《隐私政策》，
/// 则初始化方法 JPushInterface.init() 失效。
///
/// 一旦 App 未获取到《隐私政策》的用户授权，后续的 App 冷启动，
/// 开发者应该保证在调用初始化 SDK 方法 JPushInterface.init()之前，
/// 调用 JCollectionAuth.setAuth(context, false)方法，告知极光未获得用户授权。
///
/// @param auth 为 true 则代表同意隐私协议，false 则代表不同意隐私协议
Future<void> setAuth({bool auth = false}) async {
  return _platform.setAuth(auth: auth);
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
