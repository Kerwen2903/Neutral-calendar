import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations_manual.dart';
import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';
import '../main.dart';

/// Full-screen lock screen / заставка.
/// • Wrap the app home with [standaloneRoute]=false (default) for startup.
/// • Push it as a route with [standaloneRoute]=true to show from nav bar.
class LockScreen extends StatefulWidget {
  final Widget child;
  /// When true the screen pops itself on dismiss instead of showing [child].
  final bool standaloneRoute;

  // Available background colours (also used by SettingsScreen)
  static const List<Color> bgColors = [
    Color(0xFF0A1628), // dark navy
    Color(0xFF6B1A1A), // dark crimson
    Color(0xFF000000), // black
    Color(0xFF0B3D2E), // dark emerald
    Color(0xFF2D1B4E), // dark purple
    Color(0xFF1A3A4A), // dark teal
  ];

  const LockScreen({super.key, required this.child, this.standaloneRoute = false});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  bool _dismissed = false;
  late DateTime _now;
  late Timer _timer;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInCubic));
  }

  @override
  void dispose() {
    _timer.cancel();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_dismissed) return;
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
    _slideCtrl.forward().then((_) {
      if (!mounted) return;
      if (widget.standaloneRoute) {
        Navigator.of(context).pop();
      } else {
        setState(() => _dismissed = true);
      }
    });
  }

  String _pad(int v) => v.toString().padLeft(2, '0');

  String _weekdayAbbr(int wd, AppLocalizations loc) {
    // wd: 1=Mon … 7=Sun
    switch (wd) {
      case 1: return loc.monday;
      case 2: return loc.tuesday;
      case 3: return loc.wednesday;
      case 4: return loc.thursday;
      case 5: return loc.friday;
      case 6: return loc.saturday;
      default: return loc.sunday;
    }
  }

  String _gregMonthName(int month, AppLocalizations loc) {
    switch (month) {
      case 1:  return loc.january.toUpperCase();
      case 2:  return loc.february.toUpperCase();
      case 3:  return loc.march.toUpperCase();
      case 4:  return loc.april.toUpperCase();
      case 5:  return loc.may.toUpperCase();
      case 6:  return loc.june.toUpperCase();
      case 7:  return loc.july.toUpperCase();
      case 8:  return loc.august.toUpperCase();
      case 9:  return loc.september.toUpperCase();
      case 10: return loc.october.toUpperCase();
      case 11: return loc.november.toUpperCase();
      default: return loc.december.toUpperCase();
    }
  }

  String _neutralMonthName(int month, AppLocalizations loc) {
    switch (month) {
      case 1:  return loc.adam.toUpperCase();
      case 2:  return loc.eve.toUpperCase();
      case 3:  return loc.noah.toUpperCase();
      case 4:  return loc.abraham.toUpperCase();
      case 5:  return loc.moses.toUpperCase();
      case 6:  return loc.icon.toUpperCase();
      case 7:  return loc.ilham.toUpperCase();
      case 8:  return loc.avesta.toUpperCase();
      case 9:  return loc.shinto.toUpperCase();
      case 10: return loc.aqdas.toUpperCase();
      case 11: return loc.nirvana.toUpperCase();
      default: return loc.dharma.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return widget.child;

    final loc = AppLocalizations.of(context)!;
    // Read choices from global app state (set in SettingsScreen)
    final colorIndex = NeutralCalendarApp.of(context)?.lockScreenColorIndex ?? 0;
    final bg = LockScreen.bgColors[colorIndex];
    final textVariant = NeutralCalendarApp.of(context)?.lockScreenTextVariant ?? 0;
    // 0=both, 1=neutral only, 2=gregorian only, 3=time only
    final showGregorian = textVariant == 0 || textVariant == 2;
    final showNeutral = textVariant == 0 || textVariant == 1;

    // Gregorian date
    final gregDay        = _now.day;
    final gregMonth      = _gregMonthName(_now.month, loc);
    final gregWeekdayStr = _weekdayAbbr(_now.weekday, loc);

    // Neutral date
    final neutralDate = CalendarConverter.normalToNeutral(CalendarDate(
      year: _now.year,
      month: _now.month,
      day: _now.day,
      calendarType: CalendarType.normal,
    ));
    final neutralMonthName = _neutralMonthName(neutralDate.month, loc);

    // Neutral weekday: same real-world weekday
    final neutralWeekdayStr = _weekdayAbbr(_now.weekday, loc);

    // Time string
    final timeStr = '${_pad(_now.hour)}:${_pad(_now.minute)}';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: _dismiss,
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity != null && d.primaryVelocity! < -200) _dismiss();
        },
        child: SlideTransition(
          position: _slideAnim,
          child: Material(
            color: bg,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    // ── top spacer + colour switcher dots ──────────────
                    const Spacer(flex: 2),

                    // ── Gregorian date ─────────────────────────────────
                    if (showGregorian)
                      Text(
                        '$gregWeekdayStr. $gregDay $gregMonth',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.2,
                        ),
                      ),

                    SizedBox(height: showGregorian ? 12 : 0),

                    // ── Clock ──────────────────────────────────────────
                    Text(
                      timeStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 78,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 4,
                        height: 1.0,
                      ),
                    ),

                    SizedBox(height: showNeutral ? 16 : 0),

                    // ── Neutral date ───────────────────────────────────
                    if (showNeutral)
                      Text(
                        '$neutralWeekdayStr. ${neutralDate.day} $neutralMonthName',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.2,
                        ),
                      ),

                    const Spacer(flex: 3),

                    // ── Swipe up hint ──────────────────────────────────
                    const Text(
                      '↑  tap or swipe up',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
