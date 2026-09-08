import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';

/// Converts #voicePage. The original prototype does not use a real
/// speech-to-text API — it fakes a transcript with a timeout while
/// "recording" is toggled on. This screen reproduces exactly that demo
/// behavior (same fake sentence, same ~2 second delay) rather than adding
/// a new speech-recognition feature, per the conversion scope.
class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  Timer? _fakeTranscriptTimer;
  String _status = 'Ready to listen';

  static const String _placeholder = 'Your converted speech will appear here...';
  static const String _fakeTranscript =
      'This is a handmade cotton saree made using traditional weaving techniques.';

  String _transcript = _placeholder;

  @override
  void dispose() {
    _timer?.cancel();
    _fakeTranscriptTimer?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;

      if (_isRecording) {
        _status = 'Listening... Speak now';
        _seconds = 0;
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() => _seconds++);
        });
        _fakeTranscriptTimer = Timer(const Duration(seconds: 2), () {
          if (_isRecording && mounted) {
            setState(() => _transcript = _fakeTranscript);
          }
        });
      } else {
        _status = 'Voice recording stopped';
        _timer?.cancel();
        _fakeTranscriptTimer?.cancel();
      }
    });
  }

  void _clearTranscript() {
    setState(() {
      _transcript = _placeholder;
      _status = 'Ready to listen';
    });
  }

  void _useThisText() {
    final appState = context.read<AppState>();
    if (_transcript != _placeholder && _transcript.trim().isNotEmpty) {
      appState.draftDescription = _transcript;
      appState.setVoiceTranscript(_transcript);
    }
    appState.goTo(AppPage.addProduct);
  }

  String get _timerLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: 'Voice Input',
        onBack: () => appState.goTo(AppPage.addProduct),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(appState.t('voice_heading'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(appState.t('voice_subtext'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, fontSize: 13.5)),
            const SizedBox(height: 26),

            GestureDetector(
              onTap: _toggleRecording,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? AppColors.danger : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (_isRecording ? AppColors.danger : AppColors.primary).withOpacity(0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(_status),
            if (_isRecording) ...[
              const SizedBox(height: 4),
              Text(_timerLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.muted)),
            ],
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appState.t('voice_transcript_label'),
                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(_transcript),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearTranscript,
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                    label: Text(appState.t('delete_btn'), style: const TextStyle(color: AppColors.danger)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _useThisText,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(appState.t('use_this_text_btn')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
