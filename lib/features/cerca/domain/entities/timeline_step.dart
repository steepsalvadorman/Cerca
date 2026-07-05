/// One step of the job tracking timeline (e.g. "Confirmado", "En camino").
class TimelineStepDef {
  const TimelineStepDef({required this.step, required this.label});

  final int step;
  final String label;
}
