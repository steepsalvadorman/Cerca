import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/credits_overview.dart';

/// `/technician/credits` on the Cerca backend.
class CreditsRepository {
  CreditsRepository(this._dio);

  final Dio _dio;

  Future<CreditsOverview> getOverview() async {
    try {
      final response = await _dio.get('/technician/credits');
      return CreditsOverview.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  /// [purchaseId] is generated once per attempt and reused on retries, so
  /// a dropped connection can never charge twice.
  Future<PurchaseResult> purchase({
    required String purchaseId,
    required String packId,
    required String sourceId,
  }) async {
    try {
      final response = await _dio.post('/technician/credits/purchases', data: {
        'purchase_id': purchaseId,
        'pack_id': packId,
        'source_id': sourceId,
      });
      return PurchaseResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }
}
