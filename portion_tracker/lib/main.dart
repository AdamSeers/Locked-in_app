import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/portion_provider.dart';
import 'screens/main_scaffold.dart';

void main() {
  runApp(const PortionTrackerApp());
}

class PortionTrackerApp extends StatefulWidget {
  const PortionTrackerApp({super.key});

  @override
  State<PortionTrackerApp> createState() => _PortionTrackerAppState();
}

class _PortionTrackerAppState extends State<PortionTrackerApp>
    with WidgetsBindingObserver {
  late final PortionProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = PortionProvider();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _provider.checkReset();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PortionProvider>.value(
      value: _provider,
      child: MaterialApp(
        title: 'Portion Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF4CAF50),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFF4CAF50),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const MainScaffold(),
      ),
    );
  }
}
