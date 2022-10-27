// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:jpush_flutter_plugin_platform_interface/src/method_channel_jpush_flutter_plugin.dart';
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
}
