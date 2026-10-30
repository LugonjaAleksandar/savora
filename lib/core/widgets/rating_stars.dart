import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';

/// Five-star rating. Interactive when [onChanged] is provided.
class RatingStars extends StatelessWidget {
  static const int maxRating = 5;

  final int rating;
  final double size;
  final ValueChanged<int>? onChanged;

  const RatingStars({super.key, required this.rating, this.size = 20, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int index = 1; index <= maxRating; index++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onChanged == null ? null : () => onChanged!(index),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size * 0.08),
              child: AnimatedScale(
                scale: index <= rating ? 1 : 0.86,
                duration: Duration(milliseconds: 180 + index * 40),
                curve: Curves.easeOutBack,
                child: Icon(
                  index <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: size,
                  color: index <= rating ? context.colors.star : context.colors.textTertiary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
