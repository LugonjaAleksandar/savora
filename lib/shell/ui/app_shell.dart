import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/glass_container.dart';
import 'package:savora/core/widgets/sliding_selector.dart';
import 'package:savora/localization.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = <_NavItem>[
      _NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: AppLocalizations.of(context)!.nav_discover),
      _NavItem(
        icon: Icons.favorite_outline_rounded,
        activeIcon: Icons.favorite_rounded,
        label: AppLocalizations.of(context)!.nav_favorites,
      ),
      _NavItem(icon: Icons.tune_outlined, activeIcon: Icons.tune_rounded, label: AppLocalizations.of(context)!.nav_settings),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
        child: _FloatingNavBar(
          items: items,
          currentIndex: navigationShell.currentIndex,
          onSelected: (int index) {
            HapticFeedback.selectionClick();
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
          },
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}

class _FloatingNavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  const _FloatingNavBar({required this.items, required this.currentIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: <BoxShadow>[BoxShadow(color: context.colors.shadow, blurRadius: 30, offset: const Offset(0, 12))],
      ),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        padding: const EdgeInsets.all(6),
        child: SlidingSelector(
          itemCount: items.length,
          selectedIndex: currentIndex,
          onSelected: onSelected,
          height: 52,
          thumbRadius: BorderRadius.circular(AppRadius.lg),
          expandSelected: true,
          itemBuilder: (BuildContext context, int index, double selectedness) {
            return _NavButton(item: items[index], selectedness: selectedness);
          },
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final double selectedness;

  const _NavButton({required this.item, required this.selectedness});

  @override
  Widget build(BuildContext context) {
    final Color color = Color.lerp(context.colors.textSecondary, Colors.white, selectedness)!;
    // The label "unrolls" with the thumb: its width factor follows selectedness.
    final double labelProgress = Curves.easeOut.transform(selectedness);
    return Semantics(
      selected: selectedness == 1,
      button: true,
      label: item.label,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(selectedness > 0.5 ? item.activeIcon : item.icon, color: color),
          Flexible(
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: labelProgress,
                child: Opacity(
                  opacity: labelProgress,
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: context.textTheme.labelLarge?.copyWith(color: color),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
