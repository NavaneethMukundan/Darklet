import 'package:darklet/src/models/review.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:flutter/foundation.dart';

class ReviewsController extends ChangeNotifier {
  final ProductRepository _repo;
  final String productId;
  ReviewsController(this._repo, this.productId);

  LoadStatus status = LoadStatus.idle;
  List<Review> reviews = [];
  bool submitting = false;

  double get average => reviews.isEmpty
      ? 0
      : reviews.fold<int>(0, (s, r) => s + r.rating) / reviews.length;

  /// Number of reviews for each star rating (index 0 = 1 star).
  List<int> get distribution {
    final d = List.filled(5, 0);
    for (final r in reviews) {
      d[(r.rating - 1).clamp(0, 4)]++;
    }
    return d;
  }

  Future<void> load() async {
    status = LoadStatus.loading;
    notifyListeners();
    try {
      reviews = await _repo.getReviews(productId);
      status = LoadStatus.loaded;
    } catch (e) {
      debugPrint('Reviews failed: $e');
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<bool> submit({
    required String userName,
    required int rating,
    required String comment,
  }) async {
    submitting = true;
    notifyListeners();
    try {
      final review = await _repo.addReview(
        Review(
          id: 'r${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          userName: userName,
          rating: rating,
          comment: comment.trim(),
          createdAt: DateTime.now(),
        ),
      );
      reviews = [review, ...reviews];
      return true;
    } catch (e) {
      debugPrint('Add review failed: $e');
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
