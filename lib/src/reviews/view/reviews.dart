import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/models/review.dart';
import 'package:darklet/src/reviews/controller/reviews_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewsScreen extends StatelessWidget {
  final Product product;
  const ReviewsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChangeNotifierProvider(
      create: (ctx) =>
          ReviewsController(ctx.read<AppDependencies>().products, product.id)
            ..load(),
      child: Builder(
        builder: (context) {
          final c = context.watch<ReviewsController>();
          return AppBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppTopBar(title: l.reviews),
              body: ContentWidth(
                maxWidth: 700,
                child: Column(
                  children: [
                    Expanded(
                      child: switch (c.status) {
                        LoadStatus.idle || LoadStatus.loading => const Padding(
                          padding: EdgeInsets.all(16),
                          child: ListSkeleton(count: 4, itemHeight: 110),
                        ),
                        LoadStatus.error => ErrorState(onRetry: c.load),
                        LoadStatus.loaded => RefreshIndicator(
                          color: color.primaryDarkColor,
                          onRefresh: c.load,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            children: [
                              _Summary(controller: c),
                              kHeight20,
                              if (c.reviews.isEmpty)
                                SizedBox(
                                  height: 260,
                                  child: EmptyState(
                                    icon: Icons.rate_review_outlined,
                                    title: l.noReviewsTitle,
                                    message: l.noReviewsMessage,
                                  ),
                                )
                              else
                                for (final r in c.reviews) ...[
                                  _ReviewTile(review: r),
                                  kHeight10,
                                ],
                            ],
                          ),
                        ),
                      },
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: PrimaryButton(
                          label: l.writeReview,
                          icon: Icons.edit_outlined,
                          onPressed: () async {
                            if (!await ensureSignedIn(context)) return;
                            if (!context.mounted) return;
                            final ok = await context.push<bool>(
                              AppRoutes.writeReview,
                              args: product,
                            );
                            if (ok == true && context.mounted) {
                              context.read<ReviewsController>().load();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final ReviewsController controller;
  const _Summary({required this.controller});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dist = controller.distribution;
    final total = controller.reviews.length;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.average.toStringAsFixed(1),
                style: ts(42, w: FontWeight.w700),
              ),
              RatingStars(controller.average, size: 16),
              kHeight5,
              Text(
                l.reviewsCount(total),
                style: ts(12, w: FontWeight.w400, c: color.kGrey),
              ),
            ],
          ),
          kWidth20,
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Text('$star', style: ts(12, c: color.kGrey)),
                        kWidth5,
                        Icon(Icons.star_rounded, size: 14, color: color.star),
                        kWidth5,
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total == 0 ? 0 : dist[star - 1] / total,
                              minHeight: 6,
                              color: color.star,
                              backgroundColor: color.kLightGrey.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.secondaryColor,
                child: Text(
                  review.userName.isEmpty
                      ? '?'
                      : review.userName[0].toUpperCase(),
                  style: ts(14, w: FontWeight.w600, c: color.primaryDarkColor),
                ),
              ),
              kWidth10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: ts(14, w: FontWeight.w600)),
                    Text(
                      shortDate(review.createdAt),
                      style: ts(11, w: FontWeight.w400, c: color.kGrey),
                    ),
                  ],
                ),
              ),
              RatingStars(review.rating.toDouble(), size: 15),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            kHeight10,
            Text(
              review.comment,
              style: ts(13, w: FontWeight.w400, c: color.kBlackSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
