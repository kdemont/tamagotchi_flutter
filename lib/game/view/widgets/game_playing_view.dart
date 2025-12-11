import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/game_bloc.dart';

class GamePlayingView extends StatefulWidget {
  final GamePlaying state;

  const GamePlayingView({super.key, required this.state});

  @override
  State<GamePlayingView> createState() => _GamePlayingViewState();
}

class _GamePlayingViewState extends State<GamePlayingView> {
  String _currentInput = '';

  void _onNumberPressed(String number) {
    if (_currentInput.length < 3) {
      setState(() {
        _currentInput += number;
      });
    }
  }

  void _onBackspace() {
    if (_currentInput.isNotEmpty) {
      setState(() {
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      });
    }
  }

  void _onSubmit() {
    if (_currentInput.isNotEmpty) {
      final guess = int.parse(_currentInput);
      if (guess >= 1 && guess <= 100) {
        context.read<GameBloc>().add(MakeGuess(guess));
        setState(() {
          _currentInput = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5E6D3),
      child: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A574),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
            // Tamagotchi image - flexible
            Flexible(
              child: Image.asset(
                'assets/images/tamagotchi_base.png',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 75,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Hint box
            SizedBox(
              height: 45,
              child: widget.state.hint != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF2962FF), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.state.hint!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_upward, size: 20),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            // Input display
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _currentInput.isEmpty ? '' : _currentInput,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Custom numpad
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF6D4C41),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNumpadRow(['1', '2', '3']),
                  const SizedBox(height: 6),
                  _buildNumpadRow(['4', '5', '6']),
                  const SizedBox(height: 6),
                  _buildNumpadRow(['7', '8', '9']),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumpadButton(
                          child: const Icon(Icons.backspace_outlined, size: 24),
                          onPressed: _onBackspace,
                          color: const Color(0xFFE8B86D),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildNumpadButton(
                          child: const Text(
                            '0',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _onNumberPressed('0'),
                          color: const Color(0xFFF5DEB3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildNumpadButton(
                          child: const Icon(Icons.arrow_forward, size: 24),
                          onPressed: _onSubmit,
                          color: const Color(0xFFE8B86D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpadRow(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _buildNumpadButton(
              child: Text(
                number,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _onNumberPressed(number),
              color: const Color(0xFFF5DEB3),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumpadButton({
    required Widget child,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: child,
      ),
    );
  }
}
