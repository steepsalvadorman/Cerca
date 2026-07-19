import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/job_request.dart';
import 'job_session_controller.dart';

part 'client_history_controller.g.dart';

/// The signed-in client's past requests (`GET /client/history`), shown on
/// `client_account_screen`.
@riverpod
Future<List<JobRequest>> clientHistory(Ref ref) => ref.read(jobRepositoryProvider).getClientHistory();
