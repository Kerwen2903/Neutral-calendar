import 'package:flutter/services.dart';

/// Plays a short system click sound (Apple-style keyboard tap).
void playClick() {
  SystemSound.play(SystemSoundType.click);
  HapticFeedback.lightImpact();
}
