import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/reviews/controller/reviews_controller.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pops with `true` when a review was submitted.
class WriteReviewScreen extends StatefulWidget {
  final Product product;
  const WriteReviewScreen({super.key, required this.product});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _comment = TextEditingController();
  late final ReviewsController _controller = ReviewsController(
    context.read<AppDependencies>().products,
    widget.product.id,
  );
  int _rating = 0;
  bool _showRatingError = false;

  @override
  void dispose() {
    _comment.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = context.l10n;
    if (_rating == 0) {
      setState(() => _showRatingError = true);
      return;
    }
    final nav = Navigator.of(context);
    final name = context.read<AuthController>().user?.name ?? 'Guest';
    final ok = await _controller.submit(
      userName: name,
      rating: _rating,
      comment: _comment.text,
    );
    if (!mounted) return;
    if (ok) {
      showSnack(context, l.reviewThanks);
      nav.pop(true);
    } else {
      showSnack(context, l.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppTopBar(title: l.writeReview),
        body: ContentWidth(
          maxWidth: 560,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: AppNetworkImage(widget.product.image),
                    ),
                  ),
                  kWidth15,
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: ts(16, w: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              kHeight30,
              Center(
                child: Text(l.yourRating, style: ts(16, w: FontWeight.w600)),
              ),
              kHeight10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final on = i < _rating;
                  return IconButton(
                    tooltip: l.starsCount(i + 1),
                    iconSize: 40,
                    onPressed: () => setState(() {
                      _rating = i + 1;
                      _showRatingError = false;
                    }),
                    icon: AnimatedScale(
                      scale: on ? 1.1 : 1,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        on ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: on ? color.star : color.kLightGrey,
                      ),
                    ),
                  );
                }),
              ),
              if (_showRatingError)
                Center(
                  child: Text(l.ratingRequired, style: ts(13, c: color.error)),
                ),
              kHeight20,
              AppTextField(
                label: l.yourReview,
                hint: l.reviewHint,
                controller: _comment,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
              ),
              kHeight30,
              ListenableBuilder(
                listenable: _controller,
                builder: (_, _) => PrimaryButton(
                  label: l.submitReview,
                  onPressed: _submit,
                  loading: _controller.submitting,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
