import 'package:flutter/material.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/localization.dart';

class MealsSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MealsSearchField({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.stroke),
        boxShadow: <BoxShadow>[BoxShadow(color: context.colors.shadow, blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.meals_search_hint,
          hintStyle: context.textTheme.bodyLarge?.copyWith(color: context.colors.textTertiary),
          prefixIcon: Icon(Icons.search_rounded, color: context.colors.primary),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (BuildContext context, TextEditingValue value, Widget? _) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(Icons.close_rounded, color: context.colors.textSecondary),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
