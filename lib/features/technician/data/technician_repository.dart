import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/tech_team.dart';
import '../domain/technician.dart';
import '../domain/technician_document.dart';

class ProvidersPage {
  const ProvidersPage({required this.technicians, required this.teams});

  final List<Technician> technicians;
  final List<TechTeam> teams;
}

/// Talks to the `technician` feature of the backend (`/providers`,
/// `/technician/profile`, `/technician/documents[/toggle]`).
class TechnicianRepository {
  TechnicianRepository(this._dio);

  final Dio _dio;

  Future<ProvidersPage> getProviders({String? category}) async {
    try {
      final response = await _dio.get('/providers', queryParameters: {
        'category': ?category,
      });
      final data = response.data as Map<String, dynamic>;
      return ProvidersPage(
        technicians: (data['technicians'] as List).map((e) => Technician.fromJson(e as Map<String, dynamic>)).toList(),
        teams: (data['teams'] as List).map((e) => TechTeam.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  /// Returns `null` if the caller has no saved technician profile yet.
  Future<Technician?> getMyProfile() async {
    try {
      final response = await _dio.get('/technician/profile');
      return Technician.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final error = apiExceptionOf(e);
      if (error.isNotFound) return null;
      throw error;
    }
  }

  Future<void> saveProfile({
    required String oficio,
    required int coverageKm,
    required List<String> availableDays,
    required List<String> categories,
  }) async {
    try {
      await _dio.post('/technician/profile', data: {
        'oficio': oficio,
        'coverage_km': coverageKm,
        'available_days': availableDays,
        'categories': categories,
      });
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<List<TechnicianDocumentStatus>> getDocuments() async {
    try {
      final response = await _dio.get('/technician/documents');
      return (response.data as List).map((e) => TechnicianDocumentStatus.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final error = apiExceptionOf(e);
      if (error.isNotFound) return [];
      throw error;
    }
  }

  Future<void> toggleDocument({required String documentKey, required String status}) async {
    try {
      await _dio.post('/technician/documents/toggle', data: {
        'document_key': documentKey,
        'status': status,
      });
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }
}
