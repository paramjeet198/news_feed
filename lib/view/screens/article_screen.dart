import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_feed/model/article.dart';
import 'package:news_feed/providers/paginated_article_notifier.dart';
import 'package:news_feed/routes.dart';
import 'package:news_feed/utils/logger.dart';
import 'package:news_feed/utils/no_internet_exception.dart';
import 'package:news_feed/view/widget/article_list_Item.dart';
import 'package:news_feed/view/widget/loader.dart';

import 'article_detail_page.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key});

  static const int limit = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncArticle = ref.watch(articleNotifierProvider(limit: limit));
    final notifier = ref.read(articleNotifierProvider(limit: limit).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("News Feed"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await notifier.refreshArticles();
        },
        child: asyncArticle.when(
          data: (articles) {
            return ListView.builder(
              itemCount: articles.length + (notifier.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // When the last item is reached, trigger the load more action
                if (index == articles.length) {
                  notifier.loadMoreArticles();
                  return const Loader();
                }

                final article = articles[index];
                return ArticleListItem(
                  article: article,
                  onTap: () => {_moveToDetailPage(context, article)},
                );
              },
            );
          },
          error: (error, stackTrace) {
            var msg = "";
            if (error is NoInternetException) {
              Log.v(tag: "Article Screen", msg: "No Internet connection");

              return _buildRetryButton(notifier);
            } else {
              Log.v(tag: "Article Screen", msg: "getArticle error: $error");
              return Center(child: Text('Error: $msg'));
            }
          },
          loading: () => const Loader(),
        ),
      ),
    );
  }

  Widget _buildRetryButton(ArticleNotifier notifier) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No Internet Connection'),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              notifier.refreshArticles();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Retry",
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _moveToDetailPage(BuildContext context, Article article) {
    context.go('/detail', extra: article);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ArticleDetailPage(article: article),
    //   ),
    // );
  }
}
