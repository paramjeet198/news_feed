import 'package:go_router/go_router.dart';
import 'package:news_feed/model/article.dart';
import 'package:news_feed/view/screens/article_detail_page.dart';
import 'package:news_feed/view/screens/article_screen.dart';

class AppRoutes {
  GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: '/',
          name: 'Articles',
          builder: (context, state) {
            return const ArticleScreen();
          },
          routes: [
            GoRoute(
              path: '/detail',
              name: 'Detail',
              builder: (context, state) {
                final extra = state.extra as Article;
                return ArticleDetailPage(article: extra);
              },
            ),
          ]),
    ],
  );
}
