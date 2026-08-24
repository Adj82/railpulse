import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/core/theme/app_theme.dart';
import 'package:railpulse/features/eta_tracking/data/services/eta_service.dart';
import 'eta_result_screen.dart';

class TrainInputScreen extends ConsumerStatefulWidget {
  const TrainInputScreen({super.key});

  @override
  ConsumerState<TrainInputScreen> createState() => _TrainInputScreenState();
}

class _TrainInputScreenState extends ConsumerState<TrainInputScreen> {
  final _controller = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final input = _controller.text.trim();
    if (input.length != 5 || int.tryParse(input) == null) {
      setState(() => _errorMessage = 'Please enter a 5-digit train number');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final response = await ref.read(etaServiceProvider).fetchEta(input);
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => EtaResultScreen(etaResponse: response)));
    } catch (e) {
      setState(() => _errorMessage = 'Failed to fetch ETA');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pageDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('TRACKER')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: AppColors.secondary.withOpacity(0.05), blurRadius: 30)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.analytics, size: 64, color: AppColors.primary),
                  const SizedBox(height: 24),
                  const Text('AI Predictive ETA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Enter your train number for ML-based timing predictions.', 
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Train Number',
                      hintText: 'e.g. 12345',
                      errorText: _errorMessage,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('GET PROJECTIONS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
