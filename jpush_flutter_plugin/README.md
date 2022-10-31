# jpush_flutter_plugin

[![pub package][pkg_logo_link]][pkg_link]
[![License: MIT][license_badge]][license_link]

## Requirement

|             | Android | iOS   |
|-------------|---------|-------|
| **Support** | SDK 21+ | 12.0+ |

## Usage

### dart

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setDebugMode(debugMode: true);
  await init('your appkey', 'tour channel', (call) {
    print('[method]: ${call.method}');
  });
  /// ...
  runApp(const MyApp());
}
```

### Android

```yaml
dependencies:
  flutter:
    sdk: flutter
  jpush_flutter_plugin: latest
```

```xml
<manifest>
    <permission
            android:name="yourpackage.permission.JPUSH_MESSAGE"
            android:protectionLevel="signature" />
    <uses-permission android:name="yourpackage.permission.JPUSH_MESSAGE" />
    <application>
        <activity>
            <!-- ... -->
        </activity>
        <!-- Required. For publish channel feature -->
        <!-- JPUSH_CHANNEL 是为了方便开发者统计 APK 分发渠道。-->
        <!-- 例如: -->
        <!-- 发到 Google Play 的 APK 可以设置为 google-play; -->
        <!-- 发到其他市场的 APK 可以设置为 xxx-market。 -->
        <meta-data
                android:name="JPUSH_CHANNEL"
                android:value="developer-default" />
        <!-- Required. AppKey copied from Portal -->
        <meta-data
                android:name="JPUSH_APPKEY"
                android:value="your appkey" />
    </application>
</manifest>
```

### iOS

```xml
<dict>
    <key>NSUserTrackingUsageDescription</key>
    <string>申请访问Tracking权限</string>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
</dict>
```

Add `Capability`

- `Access WiFi Information`
- `Push Notification`

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pkg_logo_link]: https://img.shields.io/pub/v/jpush_flutter_plugin.svg
[pkg_link]: https://pub.dev/packages/jpush_flutter_plugin
