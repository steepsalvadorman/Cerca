import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/domain/auth_user.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/client_account/presentation/screens/client_account_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/job_request/presentation/screens/bidding_screen.dart';
import '../../features/job_request/presentation/screens/direct_quote_screen.dart';
import '../../features/job_request/presentation/screens/mode_chooser_screen.dart';
import '../../features/job_request/presentation/screens/project_quote_screen.dart';
import '../../features/onboarding/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/register_screen.dart';
import '../../features/payment/presentation/screens/app_fee_screen.dart';
import '../../features/payment/presentation/screens/job_rating_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/technician/presentation/screens/tech_docs_screen.dart';
import '../../features/technician/presentation/screens/tech_profile_screen.dart';
import '../../features/technician/presentation/screens/technician_profile_screen.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

// Routes reachable without an authenticated session; the splash screen
// owns its own timing/navigation, so it's exempt from the guard below.
const _publicRoutes = {RoutePaths.splash, RoutePaths.login, RoutePaths.register};

// Routes that only make sense for a client account. A technician account
// hitting one of these (e.g. a stale deep link) is bounced to techDocs.
const _clientOnlyRoutes = {
  RoutePaths.home,
  RoutePaths.providerProfile,
  RoutePaths.jobMode,
  RoutePaths.jobDirect,
  RoutePaths.jobBidding,
  RoutePaths.jobProjectQuote,
  RoutePaths.jobFee,
  RoutePaths.chat,
  RoutePaths.tracking,
  RoutePaths.jobRating,
  RoutePaths.clientAccount,
};

// Routes that only make sense for a technician account.
const _technicianOnlyRoutes = {RoutePaths.techDocs, RoutePaths.techProfile};

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (_publicRoutes.contains(location)) return null;

      return authState.when(
        data: (session) {
          if (session == null) return RoutePaths.login;
          if (session.user.isTechnician && _clientOnlyRoutes.contains(location)) {
            return RoutePaths.techDocs;
          }
          if (session.user.isClient && _technicianOnlyRoutes.contains(location)) {
            return RoutePaths.home;
          }
          return null;
        },
        loading: () => null,
        error: (_, _) => RoutePaths.login,
      );
    },
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
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
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
