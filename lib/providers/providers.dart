import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feed/service/firestore_db_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/article.dart';

part 'providers.g.dart';

/// Provides an instance of FirestoreService that interacts with the "articles" collection in Firestore.
///
/// This provider is used to access FirestoreService methods for fetching, adding, updating, or deleting articles.
@riverpod
FirestoreService fireStoreService(Ref ref) {
  return FirestoreService(collectionPath: "articles");
}

/// Fetches a list of all articles from Firestore using the FirestoreService provider.
///
/// This provider fetches all articles from Firestore and returns them as a [Future] list of [Article] objects.
@riverpod
Future<List<Article>> fetchArticle(Ref ref) async {
  var fireStore = ref.read(fireStoreServiceProvider);
  return fireStore.fetchArticles();
}
