import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savora/core/extensions/context_extensions.dart';
import 'package:savora/core/extensions/date_formatting.dart';
import 'package:savora/core/theme/app_theme.dart';
import 'package:savora/core/widgets/gradient_button.dart';
import 'package:savora/core/widgets/rating_stars.dart';
import 'package:savora/localization.dart';
import 'package:savora/reviews/bloc/meal_review_cubit.dart';
import 'package:savora/reviews/models/meal_review.dart';
import 'package:savora/reviews/ui/review_sheet.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealReviewCubit, MealReviewState>(
      builder: (BuildContext context, MealReviewState state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(sizeFactor: animation, alignment: Alignment.topCenter, child: child),
          ),
          child: switch (state.review) {
            final MealReview review => _ReviewCard(key: ValueKey<MealReview>(review), review: review),
            null => const _ReviewCallToAction(key: ValueKey<String>('cta')),
          },
        );
      },
    );
  }
}

class _ReviewCallToAction extends StatelessWidget {
  const _ReviewCallToAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(gradient: context.colors.brandLinearGradient, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(AppRadius.lg - 1.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(AppLocalizations.of(context)!.review_cta_title, style: context.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppLocalizations.of(context)!.review_cta_subtitle,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              label: AppLocalizations.of(context)!.review_cta_button,
              icon: Icons.star_rounded,
              onPressed: () => showReviewSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final MealReview review;

  const _ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(AppLocalizations.of(context)!.review_section_title, style: context.textTheme.titleLarge),
              const Spacer(),
              RatingStars(rating: review.rating, size: 22),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(ratingLabel(context, review.rating), style: context.textTheme.titleSmall?.copyWith(color: context.colors.primary)),
          if (review.comment.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text('“${review.comment}”', style: context.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, height: 1.5)),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.review_updated_at(formatShortDate(context, review.updatedAt)),
                  style: context.textTheme.bodySmall?.copyWith(color: context.colors.textTertiary),
                ),
              ),
              TextButton.icon(
                onPressed: () => showReviewSheet(context),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: Text(AppLocalizations.of(context)!.review_edit),
              ),
              TextButton.icon(
                onPressed: () => _delete(context),
                style: TextButton.styleFrom(foregroundColor: context.colors.danger),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: Text(AppLocalizations.of(context)!.review_delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String message = AppLocalizations.of(context)!.review_deleted;
    await context.read<MealReviewCubit>().delete();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
