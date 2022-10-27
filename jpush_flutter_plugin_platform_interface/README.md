# jpush_flutter_plugin_platform_interface

[![pub package][pkg_logo_link]][pkg_link]
[![License: MIT][license_badge]][license_link]

A common platform interface for the `jpush_flutter_plugin` plugin.

This interface allows platform-specific implementations of the `jpush_flutter_plugin` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `jpush_flutter_plugin`, extend `JpushFlutterPluginPlatform` with an implementation that performs the platform-specific behavior.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pkg_logo_link]: https://img.shields.io/pub/v/jpush_flutter_plugin_platform_interface.svg
[pkg_link]: https://pub.dev/packages/jpush_flutter_plugin_platform_interface
