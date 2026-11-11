import 'package:flutter_test/flutter_test.dart';
import 'package:ivs_mobile/core/haptics/haptic_feedback_manager.dart';
import 'package:ivs_mobile/core/audio/spatial_audio_manager.dart';
import 'package:ivs_mobile/features/safety/edge_safety_loop.dart';

void main() {
  late HapticFeedbackManager haptics;
  late SpatialAudioManager audio;
  late EdgeSafetyLoop loop;

  setUp(() {
    haptics = HapticFeedbackManager(feedbackSimulator: (_) async {});
    audio = SpatialAudioManager();
    loop = EdgeSafetyLoop(haptics: haptics, audio: audio);
  });

  test('EdgeSafetyLoop detects level drop (>1.2m while walking)', () {
    final decision = loop.evaluateTelemetry(
      distanceToGroundM: 1.5,
      isWalking: true,
      obstacleDistanceM: 5.0,
      obstacleAzimuthDeg: 0.0,
    );

    expect(decision.severity, equals(AlertSeverity.critical));
    expect(decision.verbalMessage, contains('Queda de nível'));
    expect(audio.audioLog.length, equals(1));
    expect(audio.audioLog.first, contains('critical_drop.wav'));
  });

  test('EdgeSafetyLoop detects close obstacle (<1.5m)', () {
    final decision = loop.evaluateTelemetry(
      distanceToGroundM: 0.8,
      isWalking: true,
      obstacleDistanceM: 1.1,
      obstacleAzimuthDeg: 45.0,
    );

    expect(decision.severity, equals(AlertSeverity.critical));
    expect(decision.verbalMessage, contains('Obstáculo'));
    expect(audio.audioLog.length, equals(1));
    expect(audio.audioLog.first, contains('pan=0.50'));
  });

  test('EdgeSafetyLoop reports clear path when no immediate danger', () {
    final decision = loop.evaluateTelemetry(
      distanceToGroundM: 0.8,
      isWalking: true,
      obstacleDistanceM: 4.0,
      obstacleAzimuthDeg: 0.0,
    );

    expect(decision.severity, equals(AlertSeverity.info));
    expect(decision.verbalMessage, contains('Caminho livre'));
    expect(audio.audioLog.isEmpty, isTrue);
  });
}
