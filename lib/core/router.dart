import 'package:go_router/go_router.dart';
import 'package:partywity/featues/booking/presentation/screen/booking_screen.dart';
import 'package:partywity/featues/login/screen/login_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
    ),
  ],
);