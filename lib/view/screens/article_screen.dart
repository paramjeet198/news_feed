import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feed/model/article.dart';
import 'package:news_feed/providers/paginated_article_notifier.dart';
import 'package:news_feed/utils/logger.dart';
import 'package:news_feed/view/widget/article_list_Item.dart';
import 'package:news_feed/view/widget/loader.dart';

import 'article_detail_page.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncArticle = ref.watch(articleNotifierProvider(limit: 2));
    final notifier = ref.read(articleNotifierProvider(limit: 2).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("News Feed"),
      ),
      body: asyncArticle.when(
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
                onTap: () => _moveToDetailPage(context, article),
              );
            },
          );
        },
        error: (error, stackTrace) {
          Log.v(tag: "Article Screen", msg: "getArticle error: $error");
          return Center(child: Text('Error: $error'));
        },
        loading: () => const Loader(),
      ),
    );
  }

  Future<dynamic> _moveToDetailPage(BuildContext context, Article article) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(article: article),
      ),
    );
  }
}
