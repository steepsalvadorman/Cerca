enum DocStatus { uploaded, pending }

/// One document a technician must upload to get verified (e.g. "Cédula").
class DocRequirement {
  const DocRequirement({required this.key, required this.label, required this.mono});

  final String key;
  final String label;
  final String mono;
}
