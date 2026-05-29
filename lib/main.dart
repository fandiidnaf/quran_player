import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
