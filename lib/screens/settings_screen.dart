import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _getCurrentLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'tk':
        return 'Türkmen';
      case 'en':
        return 'English';
      default:
        return 'Русский';
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final appState = NeutralCalendarApp.of(context);
    if (appState == null) return;

    final currentLocale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Language / Выберите язык / Dil saýlaň'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  currentLocale.languageCode == 'ru'
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: currentLocale.languageCode == 'ru'
                      ? Colors.green
                      : null,
                ),
                title: const Text('Русский'),
                onTap: () {
                  appState.setLocale(const Locale('ru'));
                  Navigator.pop(dialogContext);
                  setState(() {});
                },
              ),
              ListTile(
                leading: Icon(
                  currentLocale.languageCode == 'tk'
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: currentLocale.languageCode == 'tk'
                      ? Colors.green
                      : null,
                ),
                title: const Text('Türkmen'),
                onTap: () {
                  appState.setLocale(const Locale('tk'));
                  Navigator.pop(dialogContext);
                  setState(() {});
                },
              ),
              ListTile(
                leading: Icon(
                  currentLocale.languageCode == 'en'
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: currentLocale.languageCode == 'en'
                      ? Colors.green
                      : null,
                ),
                title: const Text('English'),
                onTap: () {
                  appState.setLocale(const Locale('en'));
                  Navigator.pop(dialogContext);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final appState = NeutralCalendarApp.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(localizations.language),
            subtitle: Text(_getCurrentLanguageName(currentLocale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(localizations.darkMode),
            subtitle: Text(
              appState?.isDarkMode ?? false
                  ? localizations.darkModeOn
                  : localizations.lightModeOn,
            ),
            trailing: Switch(
              value: appState?.isDarkMode ?? false,
              onChanged: (value) {
                appState?.toggleTheme(value);
                setState(() {});
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(localizations.monthNames),
            subtitle: Text(
              appState?.useNeutralMonthNames ?? true
                  ? localizations.neutralMonths
                  : localizations.gregorianMonths,
            ),
            trailing: Switch(
              value: appState?.useNeutralMonthNames ?? true,
              onChanged: (value) {
                appState?.toggleMonthNames(value);
                setState(() {});
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(localizations.aboutCalendar),
            onTap: () {
              // TODO: Show info about the calendar system
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(localizations.howToUse),
            onTap: () {
              // TODO: Show usage guide
            },
          ),
        ],
      ),
    );
  }
}
