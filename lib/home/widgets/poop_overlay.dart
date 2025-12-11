import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/home_bloc.dart';

class PoopOverlay extends StatefulWidget {
  final int poopCount;
  final bool isCleaningMode;
  final int globalRubCount;

  const PoopOverlay({
    super.key,
    required this.poopCount,
    required this.isCleaningMode,
    required this.globalRubCount,
  });

  @override
  State<PoopOverlay> createState() => _PoopOverlayState();
}

class _PoopOverlayState extends State<PoopOverlay> {
  double _previousDelta = 0.0;
  bool _movingRight = false;
  static const double _swipeThreshold = 20.0;

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isCleaningMode) return;

    final currentDelta = details.localPosition.dx;
    final delta = currentDelta - _previousDelta;

    // Detect direction change (swipe back and forth)
    if (delta.abs() > _swipeThreshold) {
      final nowMovingRight = delta > 0;

      // If direction changed, count as one rub
      if (_previousDelta != 0.0 && nowMovingRight != _movingRight) {
        context.read<HomeBloc>().add(const RubPoop());
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.poopCount == 0) return const SizedBox.shrink();

    // Three positions for poops based on wireframe
    // Position 0: Bottom left
    // Position 1: Bottom center-left
    // Position 2: Bottom right

    Widget poopsStack = Stack(
      children: [
        // Position 0 - Bottom Left
        if (widget.poopCount >= 1)
          Positioned(
            left: 50,
            bottom: 180,
            child: _PoopWidget(index: 0),
          ),
        // Position 1 - Bottom Center-Right (bigger stack)
        if (widget.poopCount >= 2)
          Positioned(
            left: 140,
            bottom: 140,
            child: _PoopWidget(index: 1),
          ),
        // Position 2 - Bottom Right
        if (widget.poopCount >= 3)
          Positioned(
            right: 50,
            bottom: 160,
            child: _PoopWidget(index: 2),
          ),
      ],
    );

    // In cleaning mode, wrap everything with a gesture detector
    if (widget.isCleaningMode) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: poopsStack,
      );
    }

    return poopsStack;
  }
}

class _PoopWidget extends StatelessWidget {
  final int index;

  const _PoopWidget({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: SvgPicture.asset(
        'assets/images/poop.svg',
        width: 80,
        height: 80,
      ),
    );
  }
}
