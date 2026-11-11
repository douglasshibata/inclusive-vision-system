import 'package:flutter/material.dart';
import 'core/haptics/haptic_feedback_manager.dart';
import 'core/audio/spatial_audio_manager.dart';
import 'features/safety/edge_safety_loop.dart';

void main() {
  runApp(const IVSMobileApp());
}

class IVSMobileApp extends StatelessWidget {
  const IVSMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inclusive Vision System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AssistiveHomeScreen(),
    );
  }
}

class AssistiveHomeScreen extends StatefulWidget {
  const AssistiveHomeScreen({super.key});

  @override
  State<AssistiveHomeScreen> createState() => _AssistiveHomeScreenState();
}

class _AssistiveHomeScreenState extends State<AssistiveHomeScreen> {
  late final HapticFeedbackManager _haptics;
  late final SpatialAudioManager _audio;
  late final EdgeSafetyLoop _safetyLoop;

  String _currentStatus = 'Pronto para navegação';

  @override
  void initState() {
    super.initState();
    _haptics = HapticFeedbackManager();
    _audio = SpatialAudioManager();
    _safetyLoop = EdgeSafetyLoop(haptics: _haptics, audio: _audio);
  }

  void _simulateObstacleCheck() {
    final decision = _safetyLoop.evaluateTelemetry(
      distanceToGroundM: 0.9,
      isWalking: true,
      obstacleDistanceM: 1.2,
      obstacleAzimuthDeg: -30.0,
    );

    setState(() {
      _currentStatus = decision.verbalMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inclusive Vision System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              label: 'Status da Navegação e Segurança',
              hint: 'Mostra o último aviso ou feedback do sistema',
              liveRegion: true,
              child: Text(
                _currentStatus,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Semantics(
              button: true,
              label: 'Verificar Obstáculos',
              hint: 'Toque duas vezes para verificar obstáculos imediatos',
              child: ElevatedButton.icon(
                onPressed: _simulateObstacleCheck,
                icon: const Icon(Icons.radar),
                label: const Text('Verificar Obstáculos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
