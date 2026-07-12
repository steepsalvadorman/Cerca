import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/technician_document.dart';
import 'providers_controller.dart';

part 'tech_docs_controller.g.dart';

/// The signed-in technician's document checklist
/// (`GET/POST /technician/documents[/toggle]`).
@riverpod
class TechDocsController extends _$TechDocsController {
  @override
  Future<List<TechnicianDocumentStatus>> build() => ref.read(technicianRepositoryProvider).getDocuments();

  Future<void> toggle(String documentKey) async {
    final current = state.value ?? const [];
    final currentlyUploaded = current.any((d) => d.documentKey == documentKey && d.isUploaded);
    final nextStatus = currentlyUploaded ? 'pending' : 'uploaded';

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(technicianRepositoryProvider).toggleDocument(documentKey: documentKey, status: nextStatus);
      return ref.read(technicianRepositoryProvider).getDocuments();
    });
  }
}
