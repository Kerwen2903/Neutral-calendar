import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../main.dart';
import '../utils/click_sound.dart';
import 'lock_screen.dart';

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
                  playClick();
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
                  playClick();
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
                  playClick();
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

  Widget _buildTextVariantChip(
    BuildContext context,
    int index,
    String label,
  ) {
    final appState = NeutralCalendarApp.of(context);
    final selected = (appState?.lockScreenTextVariant ?? 0) == index;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        playClick();
        appState?.setLockScreenTextVariant(index);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Use the actual selected locale from app state, not Localizations.localeOf,
    // because for Turkmen the Material locale is set to 'ru' to avoid a Flutter
    // crash, so localeOf would incorrectly return 'ru'.
    final currentLocale =
        NeutralCalendarApp.of(context)?.selectedLocale ??
        Localizations.localeOf(context);
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
            onTap: () { playClick(); _showLanguageDialog(context); },
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
                playClick();
                appState?.toggleTheme(value);
                setState(() {});
              },
            ),
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.calendar_month),
          //   title: Text(localizations.monthNames),
          //   subtitle: Text(
          //     appState?.useNeutralMonthNames ?? true
          //         ? localizations.neutralMonths
          //         : localizations.gregorianMonths,
          //   ),
          //   trailing: Switch(
          //     value: appState?.useNeutralMonthNames ?? true,
          //     onChanged: (value) {
          //       playClick();
          //       appState?.toggleMonthNames(value);
          //       setState(() {});
          //     },
          //   ),
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(localizations.aboutCalendar),
            onTap: () { playClick();
              // TODO: Show info about the calendar system
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(localizations.howToUse),
            onTap: () { playClick();
              // TODO: Show usage guide
            },
          ),
          const Divider(),
          // ── Lock screen styles ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone_android, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      localizations.lockScreen,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ── Background colour picker ──────────────────────────
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(LockScreen.bgColors.length, (i) {
                    final selected =
                        (appState?.lockScreenColorIndex ?? 0) == i;
                    return GestureDetector(
                      onTap: () {
                        playClick();
                        appState?.setLockScreenColor(i);
                        setState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: LockScreen.bgColors[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            width: selected ? 3 : 1.5,
                          ),
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // ── Text variant picker ───────────────────────────────
                Text(
                  localizations.lockTextVariant,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTextVariantChip(context, 0, localizations.lockTextBoth),
                    _buildTextVariantChip(context, 1, localizations.lockTextNeutralOnly),
                    _buildTextVariantChip(context, 2, localizations.lockTextGregorianOnly),
                    _buildTextVariantChip(context, 3, localizations.lockTextTimeOnly),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
