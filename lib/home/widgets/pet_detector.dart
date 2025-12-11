import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/tamagotchi_config.dart';
import '../bloc/home_bloc.dart';

class PetDetector extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PetDetector({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<PetDetector> createState() => _PetDetectorState();
}

class _PetDetectorState extends State<PetDetector> {
  double _previousDelta = 0.0;
  bool _movingRight = false;
  int _rubCount = 0;
  static const double _swipeThreshold = 20.0;

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;

    final currentDelta = details.localPosition.dx;
    final delta = currentDelta - _previousDelta;

    if (delta.abs() > _swipeThreshold) {
      final nowMovingRight = delta > 0;

      if (_previousDelta != 0.0 && nowMovingRight != _movingRight) {
        _rubCount++;

        if (_rubCount >= TamagotchiConfig.rubsForPet) {
          context.read<HomeBloc>().add(const Pet());
          _rubCount = 0; // Reset counter
        }
      }

      _movingRight = nowMovingRight;
      _previousDelta = currentDelta;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _previousDelta = details.localPosition.dx;
  }

  void _onPanEnd(DragEndDetails details) {
    _previousDelta = 0.0;
    // Don't reset _rubCount here to allow continuous petting
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}
