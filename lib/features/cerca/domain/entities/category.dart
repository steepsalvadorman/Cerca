/// A selectable service or project category chip (e.g. "Gasfitería").
class Category {
  const Category({required this.id, required this.label, required this.mono, String? shortLabel})
      : shortLabel = shortLabel ?? label;

  final String id;

  /// Full name, used wherever there is room (menus, titles, requests).
  final String label;

  /// Fits under a 64dp category chip; defaults to [label].
  final String shortLabel;
  final String mono;
}
