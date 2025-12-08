import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/home_bloc.dart';

class PoopOverlay extends StatelessWidget {
  final int poopCount;
  final bool isCleaningMode;
  final List<int> poopRubCounts;

  const PoopOverlay({
    super.key,
    required this.poopCount,
    required this.isCleaningMode,
    required this.poopRubCounts,
  });

  @override
  Widget build(BuildContext context) {
    if (poopCount == 0) return const SizedBox.shrink();

    // Three positions for poops based on wireframe
    // Position 0: Bottom left
    // Position 1: Bottom center-left
    // Position 2: Bottom right

    return Stack(
      children: [
        // Position 0 - Bottom Left
        if (poopCount >= 1)
          Positioned(
            left: 50,
            bottom: 180,
            child: _PoopWidget(
              index: 0,
              isCleaningMode: isCleaningMode,
              rubCount: poopRubCounts[0],
            ),
          ),
        // Position 1 - Bottom Center-Right (bigger stack)
        if (poopCount >= 2)
          Positioned(
            left: 140,
            bottom: 140,
            child: _PoopWidget(
              index: 1,
              isCleaningMode: isCleaningMode,
              rubCount: poopRubCounts[1],
            ),
          ),
        // Position 2 - Bottom Right
        if (poopCount >= 3)
          Positioned(
            right: 50,
            bottom: 160,
            child: _PoopWidget(
              index: 2,
              isCleaningMode: isCleaningMode,
              rubCount: poopRubCounts[2],
            ),
          ),
      ],
    );
  }
}

class _PoopWidget extends StatefulWidget {
  final int index;
  final bool isCleaningMode;
  final int rubCount;

  const _PoopWidget({
    required this.index,
    required this.isCleaningMode,
    required this.rubCount,
  });

  @override
  State<_PoopWidget> createState() => _PoopWidgetState();
}

class _PoopWidgetState extends State<_PoopWidget> {
  double _previousDelta = 0.0;
  bool _movingRight = false;
  static const double _swipeThreshold = 20.0; // Minimum distance to count as a swipe

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isCleaningMode) return;

    final currentDelta = details.localPosition.dx;
    final delta = currentDelta - _previousDelta;

    // Detect direction change (swipe back and forth)
    if (delta.abs() > _swipeThreshold) {
      final nowMovingRight = delta > 0;

      // If direction changed, count as one rub
      if (_previousDelta != 0.0 && nowMovingRight != _movingRight) {
        context.read<HomeBloc>().add(RubPoop(widget.index));
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
    return GestureDetector(
      onPanStart: widget.isCleaningMode ? _onPanStart : null,
      onPanUpdate: widget.isCleaningMode ? _onPanUpdate : null,
      onPanEnd: widget.isCleaningMode ? _onPanEnd : null,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/poop.svg',
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
