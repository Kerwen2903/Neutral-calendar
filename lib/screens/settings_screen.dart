import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickGalleryImage(BuildContext context) async {
    final appState = NeutralCalendarApp.of(context);
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      appState?.setLockScreenCustomImage(picked.path);
      setState(() {});
      _notifyLockScreenChanged();
    }
  }

  void _notifyLockScreenChanged() {
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    final loc = AppLocalizations.of(context)!;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.phone_android, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(loc.lockScreenChanged)),
          ],
        ),
        action: SnackBarAction(
          label: loc.preview,
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => LockScreen(
                  standaloneRoute: true,
                  child: const SizedBox.shrink(),
                ),
                transitionDuration: Duration.zero,
              ),
            );
          },
        ),
      ),
    );
  }

  String _getCurrentLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru': return 'Русский';
      case 'tk': return 'Türkmen';
      case 'en': return 'English';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      case 'pt': return 'Português';
      case 'de': return 'Deutsch';
      case 'it': return 'Italiano';
      case 'tr': return 'Türkçe';
      case 'vi': return 'Tiếng Việt';
      case 'id': return 'Bahasa Indonesia';
      default:   return 'Русский';
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final appState = NeutralCalendarApp.of(context);
    if (appState == null) return;

    final currentLocale = appState.selectedLocale;

    const languages = [
      ('ru', 'Русский'),
      ('tk', 'Türkmen'),
      ('en', 'English'),
      ('es', 'Español'),
      ('fr', 'Français'),
      ('pt', 'Português'),
      ('de', 'Deutsch'),
      ('it', 'Italiano'),
      ('tr', 'Türkçe'),
      ('vi', 'Tiếng Việt'),
      ('id', 'Bahasa Indonesia'),
    ];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Language / Язык'),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: languages.map((lang) {
                final isSelected = currentLocale.languageCode == lang.$1;
                return ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.green : null,
                  ),
                  title: Text(lang.$2),
                  onTap: () {
                    playClick();
                    appState.setLocale(Locale(lang.$1));
                    Navigator.pop(dialogContext);
                    setState(() {});
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(body),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildFontStyleChip(
    BuildContext context,
    int index,
    String label,
  ) {
    final appState = NeutralCalendarApp.of(context);
    final selected = (appState?.lockScreenFontStyle ?? 0) == index;
    // Show label in the actual font family for preview
    final fontFamily = LockScreen.fontFamilies[index];
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontFamily: fontFamily)),
      selected: selected,
      onSelected: (_) {
        playClick();
        appState?.setLockScreenFontStyle(index);
        setState(() {});
        _notifyLockScreenChanged();
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
        _notifyLockScreenChanged();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Use the actual selected locale from app state, not Localizations.localeOf,
    // because for Turkmen the Material locale is set to 'ru' to avoid a Flutter
    // crash, so localeOf would incorrectly return 'ru'.
    final currentLocale = NeutralCalendarApp.of(context)?.selectedLocale ??
        Localizations.localeOf(context);
    final appState = NeutralCalendarApp.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android),
            tooltip: localizations.lockScreen,
            onPressed: () {
              playClick();
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => LockScreen(
                    standaloneRoute: true,
                    child: const SizedBox.shrink(),
                  ),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localizations.language),
              subtitle: Text(_getCurrentLanguageName(currentLocale)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                playClick();
                _showLanguageDialog(context);
              },
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.compare_arrows),
              title: Text(localizations.combinationOfStyles),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(localizations.neutralCalendar),
                      selected: !(appState?.useAllChristianCombo ?? false),
                      onSelected: (_) {
                        playClick();
                        appState?.setComboCalendarMode(false);
                        setState(() {});
                      },
                    ),
                    ChoiceChip(
                      label: Text(localizations.allChristian),
                      selected: appState?.useAllChristianCombo ?? false,
                      onSelected: (_) {
                        playClick();
                        appState?.setComboCalendarMode(true);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(localizations.aboutCalendar),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                playClick();
                _showInfoDialog(
                  context,
                  localizations.aboutCalendar,
                  localizations.aboutCalendarText,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_stories),
              title: Text(localizations.aboutReformCalendar),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                playClick();
                _showInfoDialog(
                  context,
                  localizations.aboutReformCalendar,
                  localizations.aboutReformCalendarText,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localizations.website),
              subtitle: const Text('neutralcalendar.org'),
              onTap: () {
                playClick();
                launchUrl(
                  Uri.parse('https://neutralcalendar.org'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(localizations.contactEmail),
              subtitle: const Text('contact@neutralcalendar.org'),
              onTap: () {
                playClick();
                launchUrl(
                  Uri.parse('mailto:contact@neutralcalendar.org'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            const Divider(),
            // ── Lock screen styles (collapsible) ───────────────────────
            ExpansionTile(
              leading: const Icon(Icons.phone_android),
              title: Text(localizations.lockScreen),
              initiallyExpanded: false,
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // ── Background colour picker ──────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.lockColorLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(LockScreen.bgColors.length, (i) {
                    final selected = (appState?.lockScreenColorIndex ?? 0) == i;
                    final gradient = LockScreen.bgGradients[i];
                    return GestureDetector(
                      onTap: () {
                        playClick();
                        appState?.setLockScreenColor(i);
                        setState(() {});
                        _notifyLockScreenChanged();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              gradient == null ? LockScreen.bgColors[i] : null,
                          gradient: gradient,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.lockTextVariant,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTextVariantChip(
                        context, 0, localizations.lockTextBoth),
                    _buildTextVariantChip(
                        context, 1, localizations.lockTextNeutralOnly),
                    _buildTextVariantChip(
                        context, 2, localizations.lockTextGregorianOnly),
                    _buildTextVariantChip(
                        context, 3, localizations.lockTextTimer),
                    _buildTextVariantChip(
                        context, 4, localizations.lockTextStopwatch),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Font style picker ─────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.lockFontStyle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFontStyleChip(
                        context, 0, localizations.lockFontDefault),
                    _buildFontStyleChip(
                        context, 1, localizations.lockFontSerif),
                    _buildFontStyleChip(context, 2, localizations.lockFontMono),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Background image picker ──────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.lockImageLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // "None" option — solid color only
                    GestureDetector(
                      onTap: () {
                        playClick();
                        appState?.setLockScreenBgImage(-1);
                        setState(() {});
                        _notifyLockScreenChanged();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (appState?.lockScreenBgImage ?? -1) == -1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            width: (appState?.lockScreenBgImage ?? -1) == -1
                                ? 3
                                : 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.block,
                              color: Colors.white54, size: 24),
                        ),
                      ),
                    ),
                    // "Gallery" option — pick from phone gallery
                    GestureDetector(
                      onTap: () {
                        playClick();
                        _pickGalleryImage(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (appState?.lockScreenBgImage ?? -1) == -2
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            width: (appState?.lockScreenBgImage ?? -1) == -2
                                ? 3
                                : 1.5,
                          ),
                          image: appState?.lockScreenCustomImage != null
                              ? DecorationImage(
                                  image: FileImage(
                                      File(appState!.lockScreenCustomImage!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: appState?.lockScreenCustomImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_library,
                                      color: Colors.white54, size: 20),
                                  Text(
                                    localizations.lockGallery,
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 8),
                                  ),
                                ],
                              )
                            : (appState?.lockScreenBgImage ?? -1) == -2
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 20)
                                : null,
                      ),
                    ),
                    ...List.generate(LockScreen.bgImages.length, (i) {
                      final selected = (appState?.lockScreenBgImage ?? -1) == i;
                      return GestureDetector(
                        onTap: () {
                          playClick();
                          appState?.setLockScreenBgImage(i);
                          setState(() {});
                          _notifyLockScreenChanged();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                              width: selected ? 3 : 1.5,
                            ),
                            image: DecorationImage(
                              image: AssetImage(LockScreen.bgImages[i]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
