import 'package:flutter/material.dart';

import '../../../../core/router/route_structure.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const RouteStructure route = .new(path: '/', name: 'home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Home Page')));
  }
}
