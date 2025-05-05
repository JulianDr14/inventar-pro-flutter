import 'package:go_router/go_router.dart';
import 'package:intentary_pro/features/auth/presentation/pages/login_page.dart';
import 'package:intentary_pro/features/error_screen/screens/error_screen.dart';
import 'package:intentary_pro/features/home/presentation/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
