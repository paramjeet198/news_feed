import 'package:news_feed/providers/providers.dart';
import 'package:news_feed/utils/check_connectivity.dart';
import 'package:news_feed/utils/logger.dart';
import 'package:news_feed/utils/no_internet_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/article.dart';
import '../service/firestore_db_service.dart';

part 'paginated_article_notifier.g.dart';

/// The `ArticleNotifier` class manages fetching articles from Firestore in a paginated manner.
@riverpod
class ArticleNotifier extends _$ArticleNotifier {
  static const String tag = "ArticleNotifier";
  late FirestoreService fireStoreService;

  /// Indicates if more articles are available for loading
  bool hasMore = true;

  /// Prevents multiple simultaneous loading requests
  bool isLoadingMore = false;

  /// Initializes the notifier and fetches the initial set of articles.
  ///
  /// This method is automatically called when the notifier is created.
  /// It calls `_loadInitialArticles()` to load the first batch of articles.
  ///
  /// [limit]: The number of articles to load initially.
  @override
  FutureOr<List<Article>> build({required int limit}) async {
    fireStoreService = ref.watch(fireStoreServiceProvider);

    return await _loadInitialArticles();
  }

  /// Fetches the initial batch of articles from Firestore.
  ///
  /// This method interacts with Firestore's `fetchPaginatedArticles` method to load the
  /// first set of articles based on the provided `limit`. It also sets the `hasMore` flag
  /// depending on whether the number of articles fetched matches the `limit`.
  ///
  /// Returns a list of articles fetched from Firestore.
  Future<List<Article>> _loadInitialArticles() async {
    final articles =
        await fireStoreService.fetchPaginatedArticles(limit: limit);
    hasMore = articles.length == limit;
    Log.v(tag: tag, msg: "Initial Load Article length: ${articles.length}");
    return articles;
  }

  /// Loads more articles when the user scrolls down.
  ///
  /// This method is triggered when the user reaches the end of the list and more articles
  /// need to be fetched. It checks that `hasMore` is `true` and `isLoadingMore` is `false`
  /// to ensure that no duplicate requests are made while articles are being loaded.
  ///
  /// It calls `fetchPaginatedArticles` to load additional articles and appends them to the
  /// current state. If an error occurs, it updates the state with `AsyncError`.
  Future<void> loadMoreArticles() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    try {
      final moreArticles =
          await fireStoreService.fetchPaginatedArticles(limit: limit);
      hasMore = moreArticles.length == limit;

      // Combine new articles with the existing list
      Log.v(tag: tag, msg: "Load More Article Length: ${moreArticles.length}");
      state = AsyncData([...state.value ?? [], ...moreArticles]);
    } catch (e) {
      Log.v(tag: tag, msg: "loadMoreArticles error: $e");
      state = AsyncError(e, StackTrace.current);
    } finally {
      isLoadingMore = false;
    }
  }

  /// Refreshes the articles when the user pulls to refresh.
  Future<void> refreshArticles() async {
    try {
      if (!await hasInternetConnection()) {
        throw NoInternetException();
      }

      final freshArticles =
          await fireStoreService.refreshArticles(limit: limit);

      for (var item in freshArticles) {
        Log.v(tag: tag, msg: "Refreshed Articles Name: ${item.title}");
      }

      // If articles exist, update state with fresh data
      if (freshArticles.isNotEmpty) {
        state = AsyncData(freshArticles);
      }
    } catch (e) {
      Log.v(tag: tag, msg: "refreshArticles error: $e");
      state = AsyncError(e, StackTrace.current);
    }
  }
}
