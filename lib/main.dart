import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feed/service/firestore_db_service.dart';
import 'package:news_feed/view/screens/article_screen.dart';
import 'firebase_options.dart';
import 'model/article.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirestoreService articleService =
      FirestoreService(collectionPath: 'articles');

  // // Add an article
  // await articleService.addArticle(Article(
  //   title: 'New Article',
  //   description: 'This is an article about Firestore caching',
  //   imageUrl: 'https://example.com/image.jpg',
  //   timeStamp: Timestamp.now(),
  // ));

  // Listen to articles in real-time
  articleService.getArticles().listen((articles) {
    for (var article in articles) {
      print(article.title);
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Feed',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ArticleScreen());
  }
}
