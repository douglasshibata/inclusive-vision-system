import 'dart:math' as math;

class SpatialCoordinate {
  final double azimuthDeg;   // -180 to +180 (Left to Right)
  final double elevationDeg; // Up / Down
  final double distanceM;    // Distance in meters

  const SpatialCoordinate({
    required this.azimuthDeg,
    this.elevationDeg = 0.0,
    required this.distanceM,
  });

  double get stereoPan {
    final clamped = azimuthDeg.clamp(-90.0, 90.0);
    return clamped / 90.0;
  }

  double get volumeAttenuation {
    if (distanceM <= 0.5) return 1.0;
    return (1.0 / (distanceM * 0.8)).clamp(0.1, 1.0);
  }
}

class SpatialAudioManager {
  final List<String> audioLog = [];

  void playSpatializedAlert({
    required String alertSound,
    required SpatialCoordinate coordinate,
  }) {
    final pan = coordinate.stereoPan;
    final attenuation = coordinate.volumeAttenuation;

    final logEntry = 'SpatialAudio: "$alertSound" at pan=${pan.toStringAsFixed(2)}, '
        'dist=${coordinate.distanceM}m, vol=${attenuation.toStringAsFixed(2)}';
    audioLog.add(logEntry);
  }

  void clearLogs() {
    audioLog.clear();
  }
}
