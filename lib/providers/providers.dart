import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feed/service/firestore_db_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/article.dart';

part 'providers.g.dart';

@riverpod
FirestoreService fireStoreService(Ref ref) {
  return FirestoreService(collectionPath: "articles");
}

@riverpod
Future<List<Article>> fetchArticle(Ref ref) async {
  var fireStore = ref.read(fireStoreServiceProvider);
  return fireStore.fetchArticles();
}
