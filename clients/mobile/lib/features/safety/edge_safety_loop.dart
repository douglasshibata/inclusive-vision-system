import '../../core/haptics/haptic_feedback_manager.dart';
import '../../core/audio/spatial_audio_manager.dart';

enum AlertSeverity {
  info,
  guidance,
  critical,
}

class SafetyDecision {
  final AlertSeverity severity;
  final String verbalMessage;
  final HapticCue? hapticCue;
  final SpatialCoordinate? soundVector;

  const SafetyDecision({
    required this.severity,
    required this.verbalMessage,
    this.hapticCue,
    this.soundVector,
  });
}

class EdgeSafetyLoop {
  final HapticFeedbackManager haptics;
  final SpatialAudioManager audio;

  EdgeSafetyLoop({
    required this.haptics,
    required this.audio,
  });

  SafetyDecision evaluateTelemetry({
    required double distanceToGroundM,
    required bool isWalking,
    required double obstacleDistanceM,
    required double obstacleAzimuthDeg,
  }) {
    if (distanceToGroundM > 1.2 && isWalking) {
      final cue = HapticCue.imminentHazardCue;
      final sound = SpatialCoordinate(azimuthDeg: 0, distanceM: distanceToGroundM);
      haptics.trigger(cue);
      audio.playSpatializedAlert(alertSound: 'critical_drop.wav', coordinate: sound);

      return SafetyDecision(
        severity: AlertSeverity.critical,
        verbalMessage: 'Atenção: Queda de nível à frente.',
        hapticCue: cue,
        soundVector: sound,
      );
    }

    if (obstacleDistanceM > 0 && obstacleDistanceM <= 1.5) {
      final cue = HapticCue.waistObstacleCue;
      final sound = SpatialCoordinate(azimuthDeg: obstacleAzimuthDeg, distanceM: obstacleDistanceM);
      haptics.trigger(cue);
      audio.playSpatializedAlert(alertSound: 'obstacle_beep.wav', coordinate: sound);

      return SafetyDecision(
        severity: AlertSeverity.critical,
        verbalMessage: 'Obstáculo a ${obstacleDistanceM.toStringAsFixed(1)} metros.',
        hapticCue: cue,
        soundVector: sound,
      );
    }

    return const SafetyDecision(
      severity: AlertSeverity.info,
      verbalMessage: 'Caminho livre.',
      hapticCue: HapticCue.clearPathCue,
      soundVector: null,
    );
  }
}
