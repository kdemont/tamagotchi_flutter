import 'package:flutter/material.dart';
import 'package:tamagotchi_flutter/utils/lottie_preloader.dart';

/// Splash screen that preloads all Lottie animations before navigating to home.
class SplashPage extends StatefulWidget {
  final Widget Function() nextPageBuilder;

  const SplashPage({Key? key, required this.nextPageBuilder}) : super(key: key);

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
    _preloadAnimations();
  }

  Future<void> _preloadAnimations() async {
    try {
      //      await MyLottieCache.instance.preloadAllWithProgress((
      await LottiePreloader.preloadAllWithProgress((
        progress,
        assetName,
      ) {
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
      // Small delay to show 100% before navigating
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.nextPageBuilder()),
        );
      }
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
                  'Tamagotchi',
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
                      ? 'Chargement... ${(_progress * 100).toInt()}%'
                      : 'Prêt !',
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
