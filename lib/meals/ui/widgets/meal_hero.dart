import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';

/// Decode width shared by every place that shows a meal's preview image, so
/// the detail header finds the thumbnail already decoded in memory and the
/// hero never flies with an empty frame.
const int mealPreviewCacheWidth = 500;

/// Shared hero tag so grid → detail image flies seamlessly.
String mealHeroTag(String mealId) => 'meal-image-$mealId';

/// Image hero shared by meal thumbnails (grid card, saved tile) and the
/// detail header.
///
/// The flight morphs between the two ends instead of swapping them:
/// - the clip radius goes from the thumbnail's corners to the square header,
/// - the thumbnail's overlay (gradient, title) cross-fades into the header's,
/// - the detail sheet's rounded lip grows in, so the landing frame matches the
///   real header pixel for pixel and nothing pops when the flight ends.
///
/// Both directions use the same builder, the route animation simply runs
/// backwards on pop.
class MealHero extends StatelessWidget {
  final String mealId;

  /// Corner radius of the clip this hero sits in at rest.
  final double borderRadius;

  /// Height of the sheet that overlaps the bottom of the image at rest.
  final double sheetOverlap;
  final Widget child;

  const MealHero({super.key, required this.mealId, required this.child, this.borderRadius = 0, this.sheetOverlap = 0});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: mealHeroTag(mealId),
      // Straight path instead of Material's arc: the image grows towards the
      // header rather than swinging around it.
      createRectTween: (Rect? begin, Rect? end) => RectTween(begin: begin, end: end),
      flightShuttleBuilder:
          (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection direction,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final bool isPush = direction == HeroFlightDirection.push;
            return _MealHeroFlight(
              animation: animation,
              thumbnail: (isPush ? fromHeroContext : toHeroContext).findAncestorWidgetOfExactType<MealHero>()!,
              header: (isPush ? toHeroContext : fromHeroContext).findAncestorWidgetOfExactType<MealHero>()!,
            );
          },
      child: child,
    );
  }
}

/// What actually flies between the two [MealHero]s.
///
/// [animation] is already curved and runs 0 → 1 on push, 1 → 0 on pop, so 0
/// always means "thumbnail" and 1 always means "header".
class _MealHeroFlight extends StatelessWidget {
  static const Interval _overlayFade = Interval(0.05, 0.55);

  final Animation<double> animation;
  final MealHero thumbnail;
  final MealHero header;

  const _MealHeroFlight({required this.animation, required this.thumbnail, required this.header});

  @override
  Widget build(BuildContext context) {
    final Color sheetColor = context.colors.background;
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? _) {
          final double t = animation.value;
          final double lip = lerpDouble(thumbnail.sheetOverlap, header.sheetOverlap, t)!;
          return ClipRRect(
            borderRadius: BorderRadius.circular(lerpDouble(thumbnail.borderRadius, header.borderRadius, t)!),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                header.child,
                Opacity(opacity: 1 - _overlayFade.transform(t), child: thumbnail.child),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: lip,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: sheetColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(lip)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
