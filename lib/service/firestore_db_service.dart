import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/article.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;

  FirestoreService({required this.collectionPath});

  // Add an Article to Firestore
  Future<void> addArticle(Article article) async {
    await _db.collection(collectionPath).add(article.toJson());
  }

  // Read an Article by ID
  Future<Article?> getArticle(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return Article.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching article: $e');
    }
    return null;
  }

  // Get all articles with real-time updates
  Stream<List<Article>> getArticles() {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Article.fromJson(doc.data());
      }).toList();
    });
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

  // Update an Article by ID
  Future<void> updateArticle(String id, Article article) async {
    await _db.collection(collectionPath).doc(id).update(article.toJson());
  }

  // Delete an Article by ID
  Future<void> deleteArticle(String id) async {
    await _db.collection(collectionPath).doc(id).delete();
  }
}
