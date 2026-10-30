import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/app_network_image.dart';
import 'package:savora/core/widgets/shimmer.dart';
import 'package:savora/meals/models/meal_category.dart';

/// Horizontally scrolling category picker with a single gradient "blob" that
/// travels between chips.
///
/// The blob's leading edge sets off first and its trailing edge catches up, so
/// it stretches like a droplet while moving and settles into the new chip.
/// Chips don't switch styles; each one reads how much of the blob is under it
/// and blends its surface, border and text accordingly, so the colour flows
/// across every chip the blob passes instead of blinking on and off.
class CategoryChips extends StatefulWidget {
  static const double height = 56;

  final List<MealCategory> categories;
  final MealCategory? selected;
  final bool isDimmed;
  final ValueChanged<MealCategory> onSelected;

  const CategoryChips({super.key, required this.categories, required this.selected, required this.onSelected, this.isDimmed = false});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> with SingleTickerProviderStateMixin {
  static const Interval _leadingEdge = Interval(0, 0.7, curve: Curves.easeOutCubic);
  static const Interval _trailingEdge = Interval(0.18, 1, curve: Curves.easeInOutCubic);

  /// How far (px) the blob thins vertically at full stretch.
  static const double _maxSquash = 3;

  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 560))..value = 1;
  final ScrollController _scrollController = ScrollController();

  /// Measured chip widths. Positions are derived from them, so they stay right
  /// when a web font finishes loading and chips re-layout on their own.
  final Map<int, double> _widths = <int, double>{};

  /// Mirrors the selection locally so the blob moves on the tap frame, before
  /// the bloc round-trip rebuilds us.
  int? _selectedIndex;
  int? _pressedIndex;
  Rect? _fromRect;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _indexOf(widget.selected);
  }

  @override
  void didUpdateWidget(covariant CategoryChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.length != oldWidget.categories.length) {
      _widths.clear();
    }
    final int? index = _indexOf(widget.selected);
    if (index != _selectedIndex) {
      _moveTo(index);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return SizedBox(
        height: CategoryChips.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, _) => ShimmerBox(width: 110, borderRadius: BorderRadius.circular(100)),
        ),
      );
    }

    return SizedBox(
      height: CategoryChips.height,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // Let the blob's glow spill below the strip instead of being cut at the
        // list bounds; the screen edges still clip horizontally.
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: widget.isDimmed ? 0 : 1),
          duration: const Duration(milliseconds: 250),
          builder: (BuildContext context, double visibility, Widget? _) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? _) {
                return _ChipStrip(
                  categories: widget.categories,
                  thumb: _thumbRect(_controller.value),
                  chipRects: <Rect?>[for (int index = 0; index < widget.categories.length; index++) _chipRect(index)],
                  visibility: visibility,
                  pressedIndex: _pressedIndex,
                  isThumbPressed: _pressedIndex != null && _pressedIndex == _selectedIndex && _controller.isCompleted,
                  onSelected: _select,
                  onPressed: _setPressed,
                  onChipSized: _onChipSized,
                );
              },
            );
          },
        ),
      ),
    );
  }

  int? _indexOf(MealCategory? category) {
    final int index = category == null ? -1 : widget.categories.indexOf(category);
    return index < 0 ? null : index;
  }

  void _select(int index) {
    if (index != _selectedIndex) {
      _moveTo(index);
    }
    widget.onSelected(widget.categories[index]);
  }

  void _moveTo(int? index) {
    // Start from wherever the blob is right now, so a quick second tap bends
    // the motion instead of jumping.
    _fromRect = _thumbRect(_controller.value);
    _selectedIndex = index;
    _controller.forward(from: 0);
    _scrollIntoView(index);
  }

  /// Scrolls only when the chip is cut off by a screen edge, so tapping a chip
  /// that is already fully visible moves the blob and nothing else.
  void _scrollIntoView(int? index) {
    final Rect? target = _chipRect(index);
    if (target == null || _scrollController.hasClients == false) {
      return;
    }
    final ScrollPosition position = _scrollController.position;
    // Chip edges in scroll coordinates, keeping the strip's side padding.
    final double start = target.left;
    final double end = target.right + 2 * AppSpacing.lg;
    final double offset;
    if (start < position.pixels) {
      offset = start;
    } else if (end > position.pixels + position.viewportDimension) {
      offset = end - position.viewportDimension;
    } else {
      return;
    }
    _scrollController.animateTo(
      offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeOutCubic,
    );
  }

  void _setPressed(int? index) {
    if (_pressedIndex != index) {
      setState(() => _pressedIndex = index);
    }
  }

  Rect? _chipRect(int? index) {
    if (index == null || _widths.length < widget.categories.length) {
      return null;
    }
    double left = 0;
    for (int i = 0; i < index; i++) {
      left += _widths[i]! + AppSpacing.sm;
    }
    return Rect.fromLTWH(left, 0, _widths[index]!, CategoryChips.height);
  }

  Rect? _thumbRect(double t) {
    final Rect? to = _chipRect(_selectedIndex);
    final Rect? from = _fromRect;
    if (to == null || from == null || t >= 1) {
      return to;
    }
    final bool movingRight = to.center.dx >= from.center.dx;
    final double leftT = (movingRight ? _trailingEdge : _leadingEdge).transform(t);
    final double rightT = (movingRight ? _leadingEdge : _trailingEdge).transform(t);
    final double left = lerpDouble(from.left, to.left, leftT)!;
    final double right = lerpDouble(from.right, to.right, rightT)!;

    // Thin out a little while stretched, like a droplet pulled along.
    final double restingWidth = lerpDouble(from.width, to.width, t)!;
    final double stretch = ((right - left) / restingWidth - 1).clamp(0, 1);
    final double squash = _maxSquash * stretch;
    return Rect.fromLTRB(left, squash, right, CategoryChips.height - squash);
  }

  void _onChipSized(int index, Size size) {
    if (mounted == false || _widths[index] == size.width) {
      return;
    }
    setState(() => _widths[index] = size.width);
  }
}

/// The chips row with the gradient blob underneath, for one animation frame.
class _ChipStrip extends StatelessWidget {
  static const double _pressedScale = 0.96;
  static const Duration _pressDuration = Duration(milliseconds: 140);

  final List<MealCategory> categories;
  final Rect? thumb;
  final List<Rect?> chipRects;
  final double visibility;
  final int? pressedIndex;

  /// Shrinks the blob together with the selected chip while it is pressed, so
  /// no sliver of gradient peeks out around the scaled-down chip.
  final bool isThumbPressed;
  final ValueChanged<int> onSelected;
  final ValueChanged<int?> onPressed;
  final void Function(int index, Size size) onChipSized;

  const _ChipStrip({
    required this.categories,
    required this.thumb,
    required this.chipRects,
    required this.visibility,
    required this.pressedIndex,
    required this.isThumbPressed,
    required this.onSelected,
    required this.onPressed,
    required this.onChipSized,
  });

  @override
  Widget build(BuildContext context) {
    final Rect? thumb = this.thumb;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        if (thumb != null)
          Positioned.fromRect(
            rect: thumb,
            child: Opacity(
              opacity: visibility,
              child: AnimatedScale(
                scale: isThumbPressed ? _pressedScale : 1,
                duration: _pressDuration,
                curve: Curves.easeOut,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: context.colors.brandLinearGradient,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: context.colors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Row(
          children: <Widget>[
            for (int index = 0; index < categories.length; index++) ...<Widget>[
              if (index > 0) const SizedBox(width: AppSpacing.sm),
              _SizeReporter(
                onSized: (Size size) => onChipSized(index, size),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(index),
                  onTapDown: (_) => onPressed(index),
                  onTapUp: (_) => onPressed(null),
                  onTapCancel: () => onPressed(null),
                  child: AnimatedScale(
                    scale: pressedIndex == index ? _pressedScale : 1,
                    duration: _pressDuration,
                    curve: Curves.easeOut,
                    child: _CategoryChip(category: categories[index], coverage: visibility * _coverage(thumb, chipRects[index])),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Share of the chip's width currently covered by the blob, 0–1.
  static double _coverage(Rect? thumb, Rect? chip) {
    if (thumb == null || chip == null) {
      return 0;
    }
    final double overlap = math.min(thumb.right, chip.right) - math.max(thumb.left, chip.left);
    return (overlap / chip.width).clamp(0, 1);
  }
}

class _CategoryChip extends StatelessWidget {
  final MealCategory category;

  /// 0 = resting chip, 1 = fully under the blob.
  final double coverage;

  const _CategoryChip({required this.category, required this.coverage});

  @override
  Widget build(BuildContext context) {
    final double rest = 1 - coverage;
    return Container(
      height: CategoryChips.height,
      padding: const EdgeInsets.fromLTRB(6, 6, AppSpacing.md, 6),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: rest),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: context.colors.stroke.withValues(alpha: context.colors.stroke.a * rest)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(context.colors.surfaceRaised, Colors.white.withValues(alpha: 0.25), coverage),
            ),
            child: AppNetworkImage(url: category.thumbnailUrl, fit: BoxFit.contain, cacheWidth: 120),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            category.name,
            style: context.textTheme.labelLarge?.copyWith(color: Color.lerp(context.colors.textPrimary, Colors.white, coverage)),
          ),
        ],
      ),
    );
  }
}

/// Reports its child's size after every layout that changes it.
class _SizeReporter extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSized;

  const _SizeReporter({required this.onSized, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSizeReporter(onSized);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter renderObject) => renderObject.onSized = onSized;
}

class _RenderSizeReporter extends RenderProxyBox {
  ValueChanged<Size> onSized;
  Size? _reported;

  _RenderSizeReporter(this.onSized);

  @override
  void performLayout() {
    super.performLayout();
    if (size != _reported) {
      _reported = size;
      // Layout can't trigger a rebuild, so hand the size over after the frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => onSized(size));
    }
  }
}
