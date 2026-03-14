import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../utils/click_sound.dart';
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<_NavItem> navItems = [
      _NavItem(Icons.calendar_month, localizations.calendar),
      _NavItem(Icons.compare_arrows, localizations.comparison),
      _NavItem(Icons.sync_alt, localizations.converter),
      _NavItem(Icons.settings, localizations.settings),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(navItems.length, (i) {
                final selected = _selectedIndex == i;
                final color = selected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.55);
                return Expanded(
                  child: InkWell(
                    onTap: () { playClick(); setState(() => _selectedIndex = i); },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(navItems[i].icon, color: color, size: 22),
                        const SizedBox(height: 3),
                        Text(
                          navItems[i].label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 9.5,
                            height: 1.2,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
