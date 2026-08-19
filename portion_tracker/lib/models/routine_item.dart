class RoutineItem {
  final String id;
  final String label;
  final int durationMinutes;

  const RoutineItem({
    required this.id,
    required this.label,
    this.durationMinutes = 10,
  });

  RoutineItem copyWith({String? label, int? durationMinutes}) {
    return RoutineItem(
      id: id,
      label: label ?? this.label,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}