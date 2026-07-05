import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/cerca/presentation/screens/app_fee_screen.dart';
import '../../features/cerca/presentation/screens/bidding_screen.dart';
import '../../features/cerca/presentation/screens/chat_screen.dart';
import '../../features/cerca/presentation/screens/client_account_screen.dart';
import '../../features/cerca/presentation/screens/direct_quote_screen.dart';
import '../../features/cerca/presentation/screens/home_screen.dart';
import '../../features/cerca/presentation/screens/job_rating_screen.dart';
import '../../features/cerca/presentation/screens/mode_chooser_screen.dart';
import '../../features/cerca/presentation/screens/project_quote_screen.dart';
import '../../features/cerca/presentation/screens/tech_docs_screen.dart';
import '../../features/cerca/presentation/screens/tech_profile_screen.dart';
import '../../features/cerca/presentation/screens/technician_profile_screen.dart';
import '../../features/cerca/presentation/screens/tracking_screen.dart';
import '../../features/cerca/presentation/screens/welcome_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.techDocs,
        builder: (context, state) => const TechDocsScreen(),
      ),
      GoRoute(
        path: RoutePaths.techProfile,
        builder: (context, state) => const TechProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.providerProfile,
        builder: (context, state) => const TechnicianProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.jobMode,
        builder: (context, state) => const ModeChooserScreen(),
      ),
      GoRoute(
        path: RoutePaths.jobDirect,
        builder: (context, state) => const DirectQuoteScreen(),
      ),
      GoRoute(
        path: RoutePaths.jobBidding,
        builder: (context, state) => const BiddingScreen(),
      ),
      GoRoute(
        path: RoutePaths.jobProjectQuote,
        builder: (context, state) => const ProjectQuoteScreen(),
      ),
      GoRoute(
        path: RoutePaths.jobFee,
        builder: (context, state) => const AppFeeScreen(),
      ),
      GoRoute(
        path: RoutePaths.chat,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: RoutePaths.tracking,
        builder: (context, state) => const TrackingScreen(),
      ),
      GoRoute(
        path: RoutePaths.jobRating,
        builder: (context, state) => const JobRatingScreen(),
      ),
      GoRoute(
        path: RoutePaths.clientAccount,
        builder: (context, state) => const ClientAccountScreen(),
      ),
    ],
  );
}
