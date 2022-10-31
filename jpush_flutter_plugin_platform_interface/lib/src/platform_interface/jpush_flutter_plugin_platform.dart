// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:jpush_flutter_plugin_platform_interface/src/method_channel/method_channel_jpush_flutter_plugin.dart';
import 'package:jpush_flutter_plugin_platform_interface/src/types/jpush_flutter_plugin_handler.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of jpush_flutter_plugin must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `JpushFlutterPlugin`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [JpushFlutterPluginPlatform] methods.
abstract class JpushFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a JpushFlutterPluginPlatform.
  JpushFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static JpushFlutterPluginPlatform _instance =
      MethodChannelJpushFlutterPlugin();

  /// The default instance of [JpushFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelJpushFlutterPlugin].
  static JpushFlutterPluginPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [JpushFlutterPluginPlatform] when they register themselves.
  static set instance(JpushFlutterPluginPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  /// 设置调试模式 API
  /// 该接口需在 init 接口之前调用，避免出现部分日志没打印的情况。
  /// 多进程情况下建议在自定义的 Application 中 onCreate 中调用。
  /// @param debugMode debugMode 为 true 则会打印 debug 级别的日志，
  ///     false 则只会打印 warning 级别以上的日志
  Future<void> setDebugMode({bool debugMode = false});

  /// 初始化推送服务 API
  /// 调用了本 API 后，JPush 推送服务进行初始化。
  /// 建议在自定义的 Application 中的 onCreate 中调用。
  Future<void> init(
    String appKey,
    String channel,
    JpushFlutterPluginHandler handler,
  );
}
