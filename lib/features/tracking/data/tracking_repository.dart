import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/technician_location.dart';

/// Talks to the `tracking` feature of the backend (`/jobs/{id}/location`).
class TrackingRepository {
  TrackingRepository(this._dio);

  final Dio _dio;

  /// Returns `null` if the technician hasn't shared a location yet.
  Future<TechnicianLocation?> getLocation(String jobId) async {
    try {
      final response = await _dio.get('/jobs/$jobId/location');
      return TechnicianLocation.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final error = apiExceptionOf(e);
      if (error.isNotFound) return null;
      throw error;
    }
  }

  Future<void> updateLocation(String jobId, {required double latitude, required double longitude}) async {
    try {
      await _dio.post('/jobs/$jobId/location', data: {'latitude': latitude, 'longitude': longitude});
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }
}
