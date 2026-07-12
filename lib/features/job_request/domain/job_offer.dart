import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_offer.freezed.dart';
part 'job_offer.g.dart';

/// Mirrors the backend's `JobOfferResponse` — a technician's bid on a
/// `bidding`-kind job.
@freezed
abstract class JobOffer with _$JobOffer {
  const factory JobOffer({
    required int id,
    required String jobRequestId,
    required int technicianProfileId,
    required int price,
    required String eta,
    required String name,
    required String mono,
    required String oficio,
    required double rating,
    required bool verified,
  }) = _JobOffer;

  factory JobOffer.fromJson(Map<String, dynamic> json) => _$JobOfferFromJson(json);
}
