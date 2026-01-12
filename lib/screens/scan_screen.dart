import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../services/mock_food_api_service.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isProcessing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    if (widget.cameras.isEmpty) {
      setState(() {
        _isInitializing = false;
        _error = 'No camera found on this device.';
      });
      return;
    }

    _controller = CameraController(widget.cameras.first, ResolutionPreset.medium);
    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _error = 'Failed to initialize camera.';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final picture = await _controller!.takePicture();
      final result = await MockFoodApiService().analyzeFood(picture.path);
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            foodName: result.foodName,
            calories: result.estimatedCalories,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan failed. Try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Food')),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    Expanded(
                      child: controller == null
                          ? const Center(child: Text('Camera not ready.'))
                          : CameraPreview(controller),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _captureAndAnalyze,
                        icon: const Icon(Icons.camera),
                        label: Text(_isProcessing ? 'Processing...' : 'Capture'),
                      ),
                    ),
                  ],
                ),
    );
  }
}
