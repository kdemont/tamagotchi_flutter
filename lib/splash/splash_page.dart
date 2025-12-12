import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tamagotchi_flutter/gen/strings.g.dart';
import 'package:tamagotchi_flutter/utils/lottie_preloader.dart';

/// Splash screen that preloads all Lottie animations before navigating to home.
class SplashPage extends StatefulWidget {
  final Widget Function() nextPageBuilder;

  const SplashPage({super.key, required this.nextPageBuilder});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _progress = 0.0;
  String _currentAsset = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // First preload animations
    await _preloadAnimations();

    // Then check and request permissions
    await _checkAndRequestPermissions();

    // Finally navigate to home
    _navigateToHome();
  }

  Future<void> _preloadAnimations() async {
    try {
      //      await MyLottieCache.instance.preloadAllWithProgress((
      await LottiePreloader.preloadAllWithProgress((progress, assetName) {
        if (mounted) {
          setState(() {
            _progress = progress;
            _currentAsset = assetName;
          });
        }
      });
    } catch (e) {
      debugPrint('[SplashPage] Error preloading animations: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
      // Small delay to show 100% before continuing
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _checkAndRequestPermissions() async {
    // Activity recognition permission is needed for pedometer
    // On Android: ACTIVITY_RECOGNITION
    // On iOS: Motion & Fitness

    Permission permission;
    if (Platform.isAndroid) {
      permission = Permission.activityRecognition;
    } else if (Platform.isIOS) {
      permission = Permission.sensors;
    } else {
      return; // No permission needed on other platforms
    }

    final status = await permission.status;

    if (status.isGranted) {
      return; // Already granted
    }

    if (status.isDenied) {
      // Show custom dialog before requesting permission
      if (mounted) {
        //final shouldRequest = await _showPermissionExplanationDialog();
        //if (shouldRequest) {
          final result = await permission.request();
          //if (result.isPermanentlyDenied && mounted) {
         //   _showPermissionDeniedDialog();
         // }
       // }
      }
    } //else if (status.isPermanentlyDenied && mounted) {
     // _showPermissionDeniedDialog();
    //}
  }

  // Pas fan de ce dialogue
  Future<bool> _showPermissionExplanationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                backgroundColor: const Color(0xFFFFF8E7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    const Icon(
                      Icons.directions_walk,
                      color: Color(0xFF9B7C47),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.permissions.activityTitle,
                        style: const TextStyle(
                          color: Color(0xFF654B1F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Text(
                  t.permissions.activityDescription,
                  style: const TextStyle(
                    color: Color(0xFF654B1F),
                    fontSize: 16,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      t.permissions.deny,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9B7C47),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(t.permissions.allow),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<void> _showPermissionDeniedDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFFFFF8E7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              t.permissions.deniedTitle,
              style: const TextStyle(
                color: Color(0xFF654B1F),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              t.permissions.deniedMessage,
              style: const TextStyle(color: Color(0xFF654B1F)),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B7C47),
                  foregroundColor: Colors.white,
                ),
                child: Text(t.permissions.ok),
              ),
            ],
          ),
    );
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.nextPageBuilder()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7), // Warm cream background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Static icon instead of animated Lottie during preload
                const Icon(Icons.pets, size: 100, color: Color(0xFF9B7C47)),
                const SizedBox(height: 32),

                // Title
                Text(
                  t.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF654B1F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFE0D5C0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF9B7C47),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Progress text
                Text(
                  _isLoading
                      ? t.splash.loading(progress: (_progress * 100).toInt())
                      : t.splash.ready,
                  style: const TextStyle(
                    color: Color(0xFF654B1F),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),

                // Current asset being loaded
                if (_isLoading && _currentAsset.isNotEmpty)
                  Text(
                    _currentAsset,
                    style: TextStyle(
                      color: const Color(0xFF654B1F).withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
