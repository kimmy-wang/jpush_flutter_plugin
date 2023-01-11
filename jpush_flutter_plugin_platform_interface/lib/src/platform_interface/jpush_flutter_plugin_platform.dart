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
  Future<void> setAuth({bool auth = false});

  /// 初始化推送服务 API
  /// 调用了本 API 后，JPush 推送服务进行初始化。
  /// 建议在自定义的 Application 中的 onCreate 中调用。
  Future<void> init(
    String appKey,
    String channel,
    JpushFlutterPluginHandler handler,
  );

  /// 设置别名
  /// 调用此 API 来设置别名。
  /// 需要理解的是，这个接口是覆盖逻辑，而不是增量逻辑。即新的调用会覆盖之前的设置。
  /// 参数定义
  /// [sequence]
  ///
  /// 用户自定义的操作序列号，同操作结果一起返回，用来标识一次操作的唯一性，推荐每次都用不同的数字序号。
  /// [alias]
  ///
  /// 每次调用设置有效的别名，覆盖之前的设置。
  /// 有效的别名组成：字母（区分大小写）、数字、下划线、汉字、特殊字符 @!#$&*+=.|。
  /// 限制：[alias] 命名长度限制为 40 字节。（判断长度需采用 UTF-8 编码）
  Future<void> setAlias(
    int sequence,
    String alias,
  );

  /// 调用此 API 来删除别名。
  ///
  // [sequence] 用户自定义的操作序列号，同操作结果一起返回，用来标识一次操作的唯一性。
  Future<void> deleteAlias(
    int sequence,
  );
}
