// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpush_flutter_plugin_android/jpush_flutter_plugin_android.dart';
import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JpushFlutterPluginAndroid', () {
    const kPlatformName = 'Android';
    late JpushFlutterPluginAndroid jpushFlutterPlugin;
    late List<MethodCall> log;

    setUp(() async {
      jpushFlutterPlugin = JpushFlutterPluginAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(jpushFlutterPlugin.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      JpushFlutterPluginAndroid.registerWith();
      expect(JpushFlutterPluginPlatform.instance,
          isA<JpushFlutterPluginAndroid>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await jpushFlutterPlugin.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
