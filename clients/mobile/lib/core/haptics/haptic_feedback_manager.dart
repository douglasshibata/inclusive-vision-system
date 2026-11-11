import 'package:flutter/services.dart';

enum HapticPatternType {
  clearPath,      // 1 Long Vibration (500ms): Caminho livre confirmado
  waistObstacle,  // 3 Short Pulses (100ms): Obstáculo no nível da cintura
  imminentHazard, // Continuous High Frequency: Risco iminente / Degrau
}

class HapticCue {
  final HapticPatternType type;
  final int durationMs;
  final int pulseCount;
  final int intensity; // 1-100

  const HapticCue({
    required this.type,
    required this.durationMs,
    required this.pulseCount,
    required this.intensity,
  });

  static const HapticCue clearPathCue = HapticCue(
    type: HapticPatternType.clearPath,
    durationMs: 500,
    pulseCount: 1,
    intensity: 60,
  );

  static const HapticCue waistObstacleCue = HapticCue(
    type: HapticPatternType.waistObstacle,
    durationMs: 100,
    pulseCount: 3,
    intensity: 80,
  );

  static const HapticCue imminentHazardCue = HapticCue(
    type: HapticPatternType.imminentHazard,
    durationMs: 800,
    pulseCount: 5,
    intensity: 100,
  );
}

/// Manages tactile cues for smart canes and smartphones.
class HapticFeedbackManager {
  final Future<void> Function(HapticFeedbackType)? feedbackSimulator;

  HapticFeedbackManager({this.feedbackSimulator});

  Future<void> trigger(HapticCue cue) async {
    switch (cue.type) {
      case HapticPatternType.clearPath:
        await _emitHaptic(HapticFeedbackType.heavyImpact);
        break;
      case HapticPatternType.waistObstacle:
        for (int i = 0; i < cue.pulseCount; i++) {
          await _emitHaptic(HapticFeedbackType.mediumImpact);
          await Future.delayed(Duration(milliseconds: cue.durationMs));
        }
        break;
      case HapticPatternType.imminentHazard:
        for (int i = 0; i < cue.pulseCount; i++) {
          await _emitHaptic(HapticFeedbackType.heavyImpact);
          await Future.delayed(const Duration(milliseconds: 50));
        }
        break;
    }
  }

  Future<void> _emitHaptic(HapticFeedbackType type) async {
    if (feedbackSimulator != null) {
      await feedbackSimulator!(type);
      return;
    }
    switch (type) {
      case HapticFeedbackType.heavyImpact:
        await HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.mediumImpact:
        await HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.lightImpact:
        await HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.selectionClick:
        await HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.vibrate:
        await HapticFeedback.vibrate();
        break;
    }
  }
}

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}
