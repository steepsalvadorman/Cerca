import 'package:flutter_test/flutter_test.dart';

import 'package:cerca/features/job_request/domain/job_request.dart';

/// The backend answers `/technician/jobs` → `open_for_bid` (and
/// `GET /jobs/{id}` for an auction the technician is not part of) with a
/// trimmed `OpenBidJobResponse`. Parsing it as a full job used to throw,
/// and one open auction blanked the technician's whole inbox.
void main() {
  test('parses the trimmed open-bid shape', () {
    final job = JobRequest.fromJson({
      'id': '709f7240-bb97-4efe-9da5-b70039805d24',
      'job_kind': 'bidding',
      'status': 'pending',
      'title': 'Gasfitería: fuga bajo el lavadero',
      'created_at': '2026-11-22T23:55:55.985130+00:00',
    });

    expect(job.jobKind, 'bidding');
    expect(job.isPending, isTrue);
    expect(job.clientId, isNull);
    expect(job.technicianProfileId, isNull);
    expect(job.timelineStep, 0);
    expect(job.statusLabel, 'Pendiente');
    expect(job.kindLabel, 'Licitación');
  });

  test('still parses the full job shape', () {
    final job = JobRequest.fromJson({
      'id': 'cf75e0ac-e7d1-410b-b353-5473cd9bdf21',
      'client_id': '00000000-0000-0000-0000-000000000005',
      'technician_profile_id': 1,
      'tech_team_id': null,
      'job_kind': 'direct',
      'status': 'active',
      'timeline_step': 2,
      'fee_type': 'direct',
      'fee_amount': 0,
      'fee_paid': true,
      'payment_method': null,
      'payment_done': false,
      'mobility_included': true,
      'agreed_price': null,
      'rating': null,
      'title': 'Gasfitería: fuga',
      'address': 'Av. Providencia 1234',
      'comment': null,
      'created_at': '2026-11-22T23:53:52.355499+00:00',
    });

    expect(job.clientId, '00000000-0000-0000-0000-000000000005');
    expect(job.timelineStep, 2);
    expect(job.mobilityIncluded, isTrue);
    expect(job.address, 'Av. Providencia 1234');
    expect(job.statusLabel, 'En curso');
  });
}
