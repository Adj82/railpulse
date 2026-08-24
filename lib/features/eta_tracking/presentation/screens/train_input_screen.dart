import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:railpulse/core/theme/app_colors.dart';
import 'package:railpulse/shared/widgets/glass_card.dart';
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
    
    // Validation: 5 digits
    if (input.length != 5 || int.tryParse(input) == null) {
      setState(() {
        _errorMessage = 'Please enter a valid 5-digit train number';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final service = ref.read(etaServiceProvider);
      final response = await service.fetchEta(input);
      
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EtaResultScreen(etaResponse: response),
        ),
      );
    } catch (e, stack) {
      debugPrint('Error fetching ETA: $e');
      debugPrint('Stack trace: $stack');
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.paleBlue,
              Colors.white,
              AppColors.lightPink,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: GlassCard(
                  hasGlow: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Rail ETA Tracker',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.softPurple,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Enter Train Number',
                          labelStyle: const TextStyle(color: AppColors.textSecondary),
                          hintText: 'e.g. 12345',
                          hintStyle: const TextStyle(color: AppColors.textSecondary),
                          errorText: _errorMessage,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.softPurple),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.softPurple, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const CircularProgressIndicator(color: AppColors.softPurple)
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.softPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'TRACK TRAIN',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
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
