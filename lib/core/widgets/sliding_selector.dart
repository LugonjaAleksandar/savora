import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/widgets/glass_container.dart';

/// Builds one segment. [selectedness] goes 0 → 1 as the thumb arrives on it,
/// so content (colors, labels) morphs in step with the slide instead of
/// cross-fading.
typedef SlidingSelectorItemBuilder = Widget Function(BuildContext context, int index, double selectedness);

/// Segmented control with a single gradient thumb that slides between items.
///
/// The selection is mirrored locally and animated on tap, so the thumb starts
/// moving on the same frame even if the owner (router, cubit, locale reload)
/// rebuilds a frame later. When [expandSelected] is true the selected segment
/// grows to twice the width of the others; widths are interpolated with the
/// thumb, so the whole bar morphs as one piece.
class SlidingSelector extends StatefulWidget {
  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final SlidingSelectorItemBuilder itemBuilder;
  final double height;
  final BorderRadius thumbRadius;
  final bool expandSelected;
  final Duration duration;
  final Curve curve;

  const SlidingSelector({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.onSelected,
    required this.itemBuilder,
    required this.height,
    required this.thumbRadius,
    this.expandSelected = false,
    this.duration = const Duration(milliseconds: 420),
    this.curve = Curves.easeOutQuart,
  });

  @override
  State<SlidingSelector> createState() => _SlidingSelectorState();
}

class _SlidingSelectorState extends State<SlidingSelector> {
  late int _selectedIndex = widget.selectedIndex;

  @override
  void didUpdateWidget(covariant SlidingSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _selectedIndex.toDouble()),
            duration: widget.duration,
            curve: widget.curve,
            builder: (BuildContext context, double position, Widget? _) {
              return _SlidingFrame(
                position: position,
                maxWidth: constraints.maxWidth,
                itemCount: widget.itemCount,
                thumbRadius: widget.thumbRadius,
                expandSelected: widget.expandSelected,
                itemBuilder: widget.itemBuilder,
                onSelected: _select,
              );
            },
          );
        },
      ),
    );
  }

  void _select(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
    widget.onSelected(index);
  }
}

/// One frame of the selector for a given (fractional) thumb [position].
class _SlidingFrame extends StatelessWidget {
  final double position;
  final double maxWidth;
  final int itemCount;
  final BorderRadius thumbRadius;
  final bool expandSelected;
  final SlidingSelectorItemBuilder itemBuilder;
  final ValueChanged<int> onSelected;

  const _SlidingFrame({
    required this.position,
    required this.maxWidth,
    required this.itemCount,
    required this.thumbRadius,
    required this.expandSelected,
    required this.itemBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Triangular weights sum to 1 for any position, so the total width is
    // constant while individual segments grow/shrink.
    final List<double> selectedness = <double>[for (int i = 0; i < itemCount; i++) (1 - (i - position).abs()).clamp(0, 1)];
    final double extraWeight = expandSelected ? 1 : 0;
    final double unit = maxWidth / (itemCount + extraWeight);
    final List<double> widths = <double>[for (final double s in selectedness) unit * (1 + s * extraWeight)];
    final List<double> starts = <double>[0];
    for (int i = 1; i < itemCount; i++) {
      starts.add(starts[i - 1] + widths[i - 1]);
    }

    final int from = position.floor().clamp(0, itemCount - 1);
    final int to = (from + 1).clamp(0, itemCount - 1);
    final double fraction = (position - from).clamp(0, 1);
    final double thumbLeft = starts[from] + (starts[to] - starts[from]) * fraction;
    final double thumbWidth = widths[from] + (widths[to] - widths[from]) * fraction;

    return Stack(
      children: <Widget>[
        Positioned(
          left: thumbLeft,
          width: thumbWidth,
          top: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: context.colors.brandLinearGradient,
              borderRadius: thumbRadius,
              boxShadow: <BoxShadow>[
                BoxShadow(color: context.colors.primary.withValues(alpha: 0.32), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
          ),
        ),
        for (int i = 0; i < itemCount; i++)
          Positioned(
            left: starts[i],
            width: widths[i],
            top: 0,
            bottom: 0,
            child: PressableScale(
              onTap: () => onSelected(i),
              child: ClipRect(child: itemBuilder(context, i, selectedness[i])),
            ),
          ),
      ],
    );
  }
}
