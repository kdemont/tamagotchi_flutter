import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value; // 0..100
  final IconData? icon;

  const StatBar({Key? key, required this.label, required this.value, this.icon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100);

    // determine fill color by thresholds
    final Color fillColor;
    if (clamped > 50) {
      fillColor = Colors.green;
    } else if (clamped >= 20) {
      fillColor = Colors.yellow.shade700;
    } else {
      fillColor = Colors.red;
    }

    return Container(
      // make the widget more compact to avoid vertical overflow in grids
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(
          0xFF0F4C81,
        ), // dark blue background similar to the sample
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // icon box

          if (icon != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            )
          else
            const SizedBox(width: 36, height: 36),

          const SizedBox(width: 8),

          // label + bar
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                // bar background (thinner)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = constraints.maxWidth;
                    final filledWidth = totalWidth * (clamped / 100);
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Row(
                          children: [
                            // filled portion
                            Container(
                              width: filledWidth,
                              height: 14,
                              decoration: BoxDecoration(
                                color: fillColor,
                                borderRadius: BorderRadius.horizontal(
                                  left: const Radius.circular(8),
                                  right: Radius.circular(
                                    clamped == 100 ? 8 : 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          // numeric value box (slightly smaller)
          Container(
            width: 40,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$clamped',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
