import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feed/providers/providers.dart';
import 'package:news_feed/view/widget/article_list_Item.dart';

import 'article_detail_page.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncArticle = ref.watch(fetchArticleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Feed"),
      ),
      body: asyncArticle.when(
        data: (articles) {
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleListItem(
                article: article,
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(article: article),
                    ),
                  )
                },
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
