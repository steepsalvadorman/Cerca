import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/client_address.dart';
import '../domain/client_payment_method.dart';

/// Talks to the `client` feature of the backend (`/client/profile`,
/// `/client/addresses`, `/client/payment-methods`).
class ClientRepository {
  ClientRepository(this._dio);

  final Dio _dio;

  Future<bool> getProfileStatus() async {
    try {
      final response = await _dio.get('/client/profile');
      return (response.data as Map<String, dynamic>)['profile_saved'] as bool;
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<void> saveProfile(bool saved) async {
    try {
      await _dio.post('/client/profile', data: {'saved': saved});
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<List<ClientAddress>> getAddresses() async {
    try {
      final response = await _dio.get('/client/addresses');
      return (response.data as List).map((e) => ClientAddress.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<ClientAddress> addAddress({required String label, required String detail}) async {
    try {
      final response = await _dio.post('/client/addresses', data: {'label': label, 'detail': detail});
      return ClientAddress.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<List<ClientPaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _dio.get('/client/payment-methods');
      return (response.data as List).map((e) => ClientPaymentMethod.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<ClientPaymentMethod> addPaymentMethod({required String label, required String detail}) async {
    try {
      final response = await _dio.post('/client/payment-methods', data: {'label': label, 'detail': detail});
      return ClientPaymentMethod.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }
}
