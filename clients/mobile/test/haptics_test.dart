import 'package:flutter_test/flutter_test.dart';
import 'package:ivs_mobile/core/haptics/haptic_feedback_manager.dart';

void main() {
  test('HapticFeedbackManager triggers correct sequence for waistObstacle', () async {
    final calls = <HapticFeedbackType>[];
    final manager = HapticFeedbackManager(
      feedbackSimulator: (type) async {
        calls.add(type);
      },
    );

    await manager.trigger(HapticCue.waistObstacleCue);
    expect(calls.length, equals(3));
    expect(calls.every((t) => t == HapticFeedbackType.mediumImpact), isTrue);
  });

  test('HapticFeedbackManager triggers heavy impact for clearPath', () async {
    final calls = <HapticFeedbackType>[];
    final manager = HapticFeedbackManager(
      feedbackSimulator: (type) async {
        calls.add(type);
      },
    );

    await manager.trigger(HapticCue.clearPathCue);
    expect(calls.length, equals(1));
    expect(calls.first, equals(HapticFeedbackType.heavyImpact));
  });
}
