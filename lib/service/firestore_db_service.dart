import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_feed/utils/logger.dart';

import '../model/article.dart';

class FirestoreService {
  static const String tag = "FirestoreService";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;
  DocumentSnapshot? lastDocument;

  // Constructor to initialize FirestoreService with a specific collection path.
  FirestoreService({required this.collectionPath});

  /// Fetches a paginated list of articles from Firestore.
  ///
  /// Uses Firestore's query pagination with a given limit.
  /// If there are more articles, the next batch can be fetched.
  /// [limit] specifies the number of articles to fetch per request.
  Future<List<Article>> fetchPaginatedArticles({required int limit}) async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Fake delay to show loading indicator

      Query query = _db
          .collection(collectionPath)
          .orderBy('timeStamp', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        // Start after the last fetched document
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get(const GetOptions(source: Source.serverAndCache));
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot
            .docs[snapshot.size - 1]; // Set the last document for pagination
      }
      return snapshot.docs
          .map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Log.v(tag: tag, msg: "fetchPaginatedArticles error: $e");
      rethrow;
    }
  }

  // Dedicated method for refreshing articles (reset pagination)
  Future<List<Article>> refreshArticles({required int limit}) async {
    try {
      // Reset lastDocument to start from the beginning
      lastDocument = null;

      // Fetch articles from the server, forcing a fresh fetch
      Query query = _db
          .collection(collectionPath)
          .orderBy('timeStamp', descending: true)
          .limit(limit);

      final snapshot = await query.get(const GetOptions(source: Source.server)); // Force fetch from the server

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs[snapshot.size - 1]; // Set the last document for pagination
      }

      return snapshot.docs
          .map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Log.v(tag: tag, msg: "refreshArticles error: $e");
      rethrow;
    }
  }

  /// Fetches all articles from Firestore.
  ///
  /// Returns the articles as a list. Useful when you need to fetch the entire collection.
  Future<List<Article>> fetchArticles() async {
    try {
      final snapshot = await _db.collection(collectionPath).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Article.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  /// Streams real-time updates of articles from Firestore.
  ///
  /// Returns a stream of articles that automatically updates whenever the Firestore data changes.
  Stream<List<Article>> fetchPaginatedArticlesStream({required int limit}) {
    try {
      // Firestore query setup
      Query query = _db
          .collection(collectionPath)
          .orderBy('timeStamp', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // Start after the last fetched document
      }

      // Listen to Firestore for updates
      return query.snapshots().map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          lastDocument = snapshot.docs[snapshot.size - 1]; // Set the last document for pagination
        }
        return snapshot.docs
            .map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      Log.v(tag: tag, msg: "fetchPaginatedArticlesStream error: $e");
      rethrow;
    }
  }


  /// Fetches a specific article by its ID.
  ///
  /// Returns the article if found, or null if the article doesn't exist.
  Future<Article?> getArticle(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return Article.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      Log.v(tag: tag, msg: "getArticle error: $e");
    }
    return null;
  }

  /// Adds a new article to Firestore.
  ///
  /// Accepts an [Article] object and adds it to the Firestore collection.
  Future<void> addArticle(Article article) async {
    await _db.collection(collectionPath).add(article.toJson());
  }

  /// Updates an existing article in Firestore by its ID.
  ///
  /// Accepts an article ID and the updated [Article] object to update in Firestore.
  Future<void> updateArticle(String id, Article article) async {
    await _db.collection(collectionPath).doc(id).update(article.toJson());
  }

  /// Deletes an article from Firestore by its ID.
  ///
  /// Deletes the article with the specified [id] from Firestore.
  Future<void> deleteArticle(String id) async {
    await _db.collection(collectionPath).doc(id).delete();
  }
}
