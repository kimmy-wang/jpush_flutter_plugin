// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:jpush_flutter_plugin/jpush_flutter_plugin.dart';
import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJpushFlutterPluginPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements JpushFlutterPluginPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JpushFlutterPlugin', () {
    late JpushFlutterPluginPlatform jpushFlutterPluginPlatform;

    setUp(() {
      jpushFlutterPluginPlatform = MockJpushFlutterPluginPlatform();
      JpushFlutterPluginPlatform.instance = jpushFlutterPluginPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => jpushFlutterPluginPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => jpushFlutterPluginPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
