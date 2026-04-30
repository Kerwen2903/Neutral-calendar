import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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

  // Available background gradients (first 3) and solid colours (last 3)
  static const List<LinearGradient?> bgGradients = [
    LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF0A1628), Color(0xFF1B3A5C)], // navy gradient
    ),
    LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFF2D1B4E), Color(0xFF6B1A1A)], // purple-crimson
    ),
    LinearGradient(
      begin: Alignment.topRight, end: Alignment.bottomLeft,
      colors: [Color(0xFF0B3D2E), Color(0xFF1A3A4A)], // emerald-teal
    ),
    null, // solid black
    null, // solid dark crimson
    null, // solid dark purple
  ];

  static const List<Color> bgColors = [
    Color(0xFF0A1628), // fallback for gradient 0
    Color(0xFF2D1B4E), // fallback for gradient 1
    Color(0xFF0B3D2E), // fallback for gradient 2
    Color(0xFF000000), // solid black
    Color(0xFF6B1A1A), // solid dark crimson
    Color(0xFF2D1B4E), // solid dark purple
  ];

  // Available background images
  static const List<String> bgImages = [
    'assets/calendar_lock_screen_images/abstract-izgibi-otrazhenie-linii-neon-forma-figura-141932.jpeg',
    'assets/calendar_lock_screen_images/anime-night-reflection-stars-810571.jpeg',
    'assets/calendar_lock_screen_images/earth-moraine_lake-alberta-banff_national_park-canada-canadian_rockies-cliff-lake-mountain-reflection-321876.jpeg',
    'assets/calendar_lock_screen_images/earth-landscape-forest-milky_way-mountain-night-norway-reflection-sky-starry_sky-stars-valley-782731.jpeg',
    'assets/calendar_lock_screen_images/flowers-rozi-tsveti-tri-buket-otrazhenie-svecha-romantika-87429.jpeg',
    'assets/calendar_lock_screen_images/man_made-marina_bay_sands-building-night-reflection-singapore-661403.jpeg',
    'assets/calendar_lock_screen_images/nature-zakat-nebo-more-oblaka-pesok-vlazhnii-zerkalo-otrazhenie-131012.jpeg',
    'assets/calendar_lock_screen_images/photography-beach-mangrove-reflection-shipwreck-tropical-1077008.jpeg',
  ];

  // Available font families for lock screen text
  static const List<String?> fontFamilies = [
    null,       // default (sans-serif)
    'serif',    // serif
    'monospace', // monospace
  ];

  const LockScreen({super.key, required this.child, this.standaloneRoute = false});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _dismissed = false;
  late DateTime _now;
  late Timer _timer;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  // Stopwatch state (variant 4) — wall-clock based so it keeps
  // running while the app/device is backgrounded or sleeping.
  DateTime? _swStart;          // non-null => running
  int _swAccumMs = 0;          // time accumulated across previous runs
  Timer? _swTimer;             // UI refresh ticker
  final List<int> _swLaps = []; // saved lap times (ms), newest first
  bool get _swRunning => _swStart != null;

  // Countdown timer state (variant 3) — wall-clock based.
  int _timerSetMinutes = 5;
  int _timerSetSeconds = 0;
  int _cdTotalMs = 0;
  DateTime? _cdEndTime;        // non-null => running
  int _cdPausedRemainingMs = 0;
  Timer? _countdownTimer;
  bool _countdownFinished = false;
  bool get _countdownRunning => _cdEndTime != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    // OS may have frozen our Timer while backgrounded. Fire a
    // catch-up check so the countdown alarm triggers immediately
    // if it elapsed while we were away, and so both displays jump
    // to the true current value on the next frame.
    if (_cdEndTime != null && !_countdownFinished) {
      final remaining = _cdEndTime!.difference(DateTime.now()).inMilliseconds;
      if (remaining <= 0) {
        _cdEndTime = null;
        _cdPausedRemainingMs = 0;
        _countdownFinished = true;
        _countdownTimer?.cancel();
        _countdownTimer = null;
        FlutterRingtonePlayer().playAlarm(looping: true, asAlarm: true);
        HapticFeedback.heavyImpact();
      }
    }
    if (mounted) setState(() {});
  }

  void _startSwTimer() {
    _swTimer?.cancel();
    _swTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void _stopSwTimer() {
    _swTimer?.cancel();
    _swTimer = null;
  }

  // ── Countdown timer helpers ──────────────────────────────────
  int _countdownRemainingMs() {
    if (_cdEndTime != null) {
      return _cdEndTime!.difference(DateTime.now()).inMilliseconds;
    }
    return _cdPausedRemainingMs;
  }

  void _startCountdownTicker() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted) return;
      if (_cdEndTime != null) {
        final remaining = _cdEndTime!.difference(DateTime.now()).inMilliseconds;
        if (remaining <= 0) {
          _cdEndTime = null;
          _cdPausedRemainingMs = 0;
          _countdownFinished = true;
          _countdownTimer?.cancel();
          _countdownTimer = null;
          FlutterRingtonePlayer().playAlarm(looping: true, asAlarm: true);
          HapticFeedback.heavyImpact();
        }
      }
      setState(() {});
    });
  }

  void _startCountdown() {
    _cdTotalMs = (_timerSetMinutes * 60 + _timerSetSeconds) * 1000;
    if (_cdTotalMs <= 0) return;
    _cdEndTime = DateTime.now().add(Duration(milliseconds: _cdTotalMs));
    _cdPausedRemainingMs = _cdTotalMs;
    _countdownFinished = false;
    _startCountdownTicker();
  }

  void _pauseCountdown() {
    if (_cdEndTime == null) return;
    _cdPausedRemainingMs =
        _cdEndTime!.difference(DateTime.now()).inMilliseconds.clamp(0, _cdTotalMs);
    _cdEndTime = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _resumeCountdown() {
    if (_cdEndTime != null || _cdPausedRemainingMs <= 0) return;
    _cdEndTime =
        DateTime.now().add(Duration(milliseconds: _cdPausedRemainingMs));
    _startCountdownTicker();
  }

  void _resetCountdown() {
    _cdEndTime = null;
    _cdPausedRemainingMs = 0;
    _cdTotalMs = 0;
    _countdownFinished = false;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    FlutterRingtonePlayer().stop();
  }

  String _formatCountdown() {
    final remaining = _countdownRemainingMs();
    final clamped = remaining.clamp(0, _cdTotalMs == 0 ? 1 : _cdTotalMs);
    final m = (clamped ~/ 60000) % 60;
    final s = (clamped ~/ 1000) % 60;
    final ms = (clamped % 1000) ~/ 10;
    return '${_pad(m)}:${_pad(s)}.${_pad(ms)}';
  }

  // ── Stopwatch helpers ────────────────────────────────────────
  int _stopwatchMs() {
    if (_swStart != null) {
      return _swAccumMs +
          DateTime.now().difference(_swStart!).inMilliseconds;
    }
    return _swAccumMs;
  }

  void _toggleStopwatch() {
    if (_swStart != null) {
      _swAccumMs += DateTime.now().difference(_swStart!).inMilliseconds;
      _swStart = null;
      _stopSwTimer();
    } else {
      _swStart = DateTime.now();
      _startSwTimer();
    }
  }

  void _resetStopwatch() {
    _swStart = null;
    _swAccumMs = 0;
    _swLaps.clear();
    _stopSwTimer();
  }

  void _saveLap() {
    final t = _stopwatchMs();
    if (t <= 0) return;
    _swLaps.insert(0, t);
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    _swTimer?.cancel();
    _countdownTimer?.cancel();
    FlutterRingtonePlayer().stop();
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

  String _formatStopwatch() {
    final elapsed = _stopwatchMs();
    final m = (elapsed ~/ 60000) % 60;
    final s = (elapsed ~/ 1000) % 60;
    final ms = (elapsed % 1000) ~/ 10; // centiseconds (2 digits)
    return '${_pad(m)}:${_pad(s)}.${_pad(ms)}';
  }

  String _formatLap(int elapsed) {
    final m = (elapsed ~/ 60000) % 60;
    final s = (elapsed ~/ 1000) % 60;
    final ms = (elapsed % 1000) ~/ 10;
    return '${_pad(m)}:${_pad(s)}.${_pad(ms)}';
  }

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
    final bgGradient = LockScreen.bgGradients[colorIndex];
    final bgImageIndex = NeutralCalendarApp.of(context)?.lockScreenBgImage ?? -1;
    final customImagePath = NeutralCalendarApp.of(context)?.lockScreenCustomImage;
    final textVariant = NeutralCalendarApp.of(context)?.lockScreenTextVariant ?? 0;
    // 0=both, 1=neutral only, 2=gregorian only, 3=timer, 4=stopwatch
    final showGregorian = textVariant == 0 || textVariant == 2;
    final showNeutral = textVariant == 0 || textVariant == 1;
    final fontStyleIndex = NeutralCalendarApp.of(context)?.lockScreenFontStyle ?? 0;
    final fontFamily = LockScreen.fontFamilies[fontStyleIndex];

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

    // Neutral weekday: calculated from Neutral calendar's own weekday system
    // (year always starts on Sunday, so weekdays differ from Gregorian)
    final neutralFirstWd = CalendarConverter.getFirstWeekdayNeutral(
        neutralDate.year, neutralDate.month);
    // neutralFirstWd: 0=Mon..6=Sun; convert to 1=Mon..7=Sun
    final neutralWd = (neutralFirstWd + neutralDate.day - 1) % 7 + 1;
    final neutralWeekdayStr = _weekdayAbbr(neutralWd, loc);

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
            color: bgImageIndex >= 0 || bgImageIndex == -2 || bgGradient != null
                ? Colors.black
                : bg,
            child: Container(
              decoration: bgImageIndex == -2 && customImagePath != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(customImagePath)),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.3), BlendMode.darken),
                      ),
                    )
                  : bgImageIndex >= 0
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(LockScreen.bgImages[bgImageIndex]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.3), BlendMode.darken),
                          ),
                        )
                      : bgGradient != null
                          ? BoxDecoration(gradient: bgGradient)
                          : null,
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
                        style: TextStyle(
                          fontFamily: fontFamily,
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
                      style: TextStyle(
                        fontFamily: fontFamily,
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
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white70,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.2,
                        ),
                      ),

                    // ── Countdown Timer (variant 3) ─────────────────
                    if (textVariant == 3) ...[
                      const SizedBox(height: 24),
                      if (!_countdownRunning && !_countdownFinished) ...[
                        // Time setter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Minutes
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      _timerSetMinutes = (_timerSetMinutes + 1).clamp(0, 99)),
                                  child: const Icon(Icons.keyboard_arrow_up,
                                      color: Colors.white54, size: 32),
                                ),
                                Text(
                                  _pad(_timerSetMinutes),
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text('min',
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: Colors.white38, fontSize: 12)),
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      _timerSetMinutes = (_timerSetMinutes - 1).clamp(0, 99)),
                                  child: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white54, size: 32),
                                ),
                              ],
                            ),
                            Text(' : ',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.white54,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300)),
                            // Seconds
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      _timerSetSeconds = (_timerSetSeconds + 5) % 60),
                                  child: const Icon(Icons.keyboard_arrow_up,
                                      color: Colors.white54, size: 32),
                                ),
                                Text(
                                  _pad(_timerSetSeconds),
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text('sec',
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: Colors.white38, fontSize: 12)),
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      _timerSetSeconds = (_timerSetSeconds - 5).clamp(0, 55)),
                                  child: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white54, size: 32),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => setState(() => _startCountdown()),
                          child: const Icon(Icons.play_circle_outline,
                              color: Colors.white54, size: 48),
                        ),
                      ] else if (_countdownFinished) ...[
                        // Finished – ringing
                        Text(
                          '00:00.00',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: Colors.redAccent,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => setState(() => _resetCountdown()),
                          child: const Icon(Icons.stop_circle_outlined,
                              color: Colors.redAccent, size: 48),
                        ),
                      ] else ...[
                        // Running countdown
                        Text(
                          _formatCountdown(),
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: Colors.white60,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_countdownRunning) {
                                    _pauseCountdown();
                                  } else {
                                    _resumeCountdown();
                                  }
                                });
                              },
                              child: Icon(
                                _countdownRunning
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 24),
                            GestureDetector(
                              onTap: () => setState(() => _resetCountdown()),
                              child: const Icon(Icons.stop_circle_outlined,
                                  color: Colors.white54, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ],

                    // ── Stopwatch (variant 4) ────────────────────────
                    if (textVariant == 4) ...[
                      const SizedBox(height: 24),
                      Text(
                        _formatStopwatch(),
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white60,
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => setState(_toggleStopwatch),
                            child: Icon(
                              _swRunning
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.white54,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: _swRunning || _swAccumMs > 0
                                ? () => setState(_saveLap)
                                : null,
                            child: Icon(
                              Icons.flag_outlined,
                              color: _swRunning || _swAccumMs > 0
                                  ? Colors.white54
                                  : Colors.white24,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => setState(_resetStopwatch),
                            child: const Icon(
                              Icons.stop_circle_outlined,
                              color: Colors.white54,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                      if (_swLaps.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 110),
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                _swLaps.length > 5 ? 5 : _swLaps.length,
                                (i) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '#${_swLaps.length - i}  ${_formatLap(_swLaps[i])}',
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      color: Colors.white54,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],

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
      ),
    );
  }
}
