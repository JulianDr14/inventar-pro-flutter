import 'package:go_router/go_router.dart';
import 'package:intentary_pro/features/auth/presentation/pages/login_page.dart';
import 'package:intentary_pro/features/error_screen/screens/error_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
