import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/gradient_button.dart';
import 'package:savora/core/widgets/rating_stars.dart';
import 'package:savora/localization.dart';
import 'package:savora/reviews/bloc/meal_review_cubit.dart';
import 'package:savora/reviews/models/meal_review.dart';

String ratingLabel(BuildContext context, int rating) {
  return switch (rating) {
    1 => AppLocalizations.of(context)!.review_rating_label_1,
    2 => AppLocalizations.of(context)!.review_rating_label_2,
    3 => AppLocalizations.of(context)!.review_rating_label_3,
    4 => AppLocalizations.of(context)!.review_rating_label_4,
    _ => AppLocalizations.of(context)!.review_rating_label_5,
  };
}

Future<void> showReviewSheet(BuildContext context) {
  final MealReviewCubit cubit = context.read<MealReviewCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => BlocProvider<MealReviewCubit>.value(value: cubit, child: const ReviewSheet()),
  );
}

class ReviewSheet extends StatefulWidget {
  const ReviewSheet({super.key});

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  late int _rating;
  late final TextEditingController _commentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final MealReview? existing = context.read<MealReviewCubit>().state.review;
    _rating = existing?.rating ?? 0;
    _commentController = TextEditingController(text: existing?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(AppLocalizations.of(context)!.review_sheet_title, style: context.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          RatingStars(
            rating: _rating,
            size: 48,
            onChanged: (int value) {
              HapticFeedback.selectionClick();
              setState(() => _rating = value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _rating == 0 ? ' ' : ratingLabel(context, _rating),
              key: ValueKey<int>(_rating),
              style: context.textTheme.titleMedium?.copyWith(color: context.colors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _commentController,
            minLines: 3,
            maxLines: 6,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.review_comment_hint,
              filled: true,
              fillColor: context.colors.surfaceRaised,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GradientButton(
            label: AppLocalizations.of(context)!.review_save,
            icon: Icons.check_rounded,
            expand: true,
            onPressed: _rating == 0 || _isSaving ? null : _save,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String savedMessage = AppLocalizations.of(context)!.review_saved;
    await context.read<MealReviewCubit>().save(rating: _rating, comment: _commentController.text);
    if (mounted == false) {
      return;
    }
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(savedMessage)));
  }
}
