import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'portion_list_screen.dart';

/// Bottom navigation between the app's pages. Add a new page by adding
/// another entry to `_pages` and `NavigationDestination`.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    PortionListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Full List',
          ),
        ],
      ),
    );
  }
}
