import 'package:news_feed/providers/providers.dart';
import 'package:news_feed/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/article.dart';
import '../service/firestore_db_service.dart';

part 'paginated_article_notifier.g.dart';

@riverpod
class ArticleNotifier extends _$ArticleNotifier {
  late FirestoreService fireStoreService;

  bool hasMore = true; // Tracks if more data is available
  bool isLoadingMore = false; // Tracks loading state for additional data

  @override
  FutureOr<List<Article>> build({required int limit}) async {
    fireStoreService = ref.watch(fireStoreServiceProvider);

    return await _loadInitialArticles();
  }

  // Loads the initial set of articles
  Future<List<Article>> _loadInitialArticles() async {
    final articles = await fireStoreService.fetchPaginatedArticles(limit: limit);
    hasMore = articles.length == limit;
    Log.v("_loadInitialArticles: ${articles.length}");
    return articles;
  }

  // Loads more articles when user scrolls down
  Future<void> loadMoreArticles() async {
    if (!hasMore || isLoadingMore) return;

    Log.v("loadMoreArticles: loading more");
    isLoadingMore = true;
    try {
      final moreArticles =
          await fireStoreService.fetchPaginatedArticles(limit: limit);
      hasMore = moreArticles.length == limit;

      // Combine new articles with the existing list
      Log.v("loadMoreArticles: loaded: ${moreArticles.length}");
      state = AsyncData([...state.value ?? [], ...moreArticles]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      isLoadingMore = false;
    }
  }
}
