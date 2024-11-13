import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_feed/utils/logger.dart';

import '../model/article.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;
  DocumentSnapshot? lastDocument;

  FirestoreService({required this.collectionPath});

  // Fetch articles with pagination
  Future<List<Article>> fetchPaginatedArticles({
    required int limit,
  }) async {
    try {

      await Future.delayed(
          const Duration(seconds: 2)); // Fake delay to show loading indicator

      Query query = _db
          .collection(collectionPath)
          .orderBy('timeStamp', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot
            .docs[snapshot.size - 1]; // Set the last document for pagination
      }
      return snapshot.docs
          .map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Log.v("FirestoreService: Error: $e");
      rethrow;
    }
  }

  // Fetch articles from Firestore
  Future<List<Article>> fetchArticles() async {
    try {
      final snapshot = await _db.collection(collectionPath).get();
      final articles = snapshot.docs.map((doc) {
        final data = doc.data();
        return Article.fromJson(data);
      }).toList();
      return articles;
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  // Get all articles with real-time updates
  Stream<List<Article>> getArticles() {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Article.fromJson(doc.data());
      }).toList();
    });
  }

  // Read an Article by ID
  Future<Article?> getArticle(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return Article.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      Log.v('Error fetching article: $e');
    }
    return null;
  }

  // Add an Article to Firestore
  Future<void> addArticle(Article article) async {
    await _db.collection(collectionPath).add(article.toJson());
  }

  // Update an Article by ID
  Future<void> updateArticle(String id, Article article) async {
    await _db.collection(collectionPath).doc(id).update(article.toJson());
  }

  // Delete an Article by ID
  Future<void> deleteArticle(String id) async {
    await _db.collection(collectionPath).doc(id).delete();
  }
}
