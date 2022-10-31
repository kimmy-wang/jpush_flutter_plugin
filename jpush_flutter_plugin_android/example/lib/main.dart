// Copyright (c) 2022, Kimmy
// https://kimmy.me
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter_plugin_platform_interface/jpush_flutter_plugin_platform_interface.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JpushFlutterPluginPlatform.instance.setDebugMode(debugMode: true);
  await JpushFlutterPluginPlatform.instance.init('', '',
      (MethodCall call) async {
    print('[method]: ${call.method}');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _platformName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JpushFlutterPluginAndroid Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_platformName == null)
              const SizedBox.shrink()
            else
              Text(
                'Platform Name: $_platformName',
                style: Theme.of(context).textTheme.headline5,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await JpushFlutterPluginPlatform.instance
                      .getPlatformName();
                  setState(() => _platformName = result);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Get Platform Name'),
            ),
          ],
        ),
      ),
    );
  }
}
