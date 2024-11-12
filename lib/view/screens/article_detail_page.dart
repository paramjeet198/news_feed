import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/article.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: article.title, // Ensure this tag matches the one in ArticleListItem
            child: CachedNetworkImage(
              imageUrl: article.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              article.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // Add more details of the article here if needed
        ],
      ),
    );
  }
}
