import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import 'main_calendar_screen.dart';
import 'comparison_screen.dart';
import 'converter_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    MainCalendarScreen(),
    ComparisonScreen(),
    ConverterScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calendar_month),
            label: localizations.calendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.compare_arrows),
            label: localizations.comparison,
          ),
          NavigationDestination(
            icon: const Icon(Icons.sync_alt),
            label: localizations.converter,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: localizations.settings,
          ),
        ],
      ),
    );
  }
}
