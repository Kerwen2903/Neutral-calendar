import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Language / Выберите язык / Dil saýlaň'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Русский'),
                onTap: () {
                  appState.setLocale(const Locale('ru'));
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle_outlined),
                title: const Text('Türkmen'),
                onTap: () {
                  appState.setLocale(const Locale('tk'));
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle_outlined),
                title: const Text('English'),
                onTap: () {
                  appState.setLocale(const Locale('en'));
                  Navigator.pop(dialogContext);
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
