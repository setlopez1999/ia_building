class Date {
  Date(this.dateTime);

  factory Date.fromISO8601(String date) {
    return Date(DateTime.parse(date));
  }

  factory Date.now() {
    return Date(DateTime.now());
  }

  final DateTime dateTime;

  String toISO8601() {
    return dateTime.toIso8601String();
  }

  int compareTo(Date other) {
    return dateTime.compareTo(other.dateTime);
  }

  Date add(Duration duration) {
    return Date(dateTime.add(duration));
  }

  Date subtract(Duration duration) {
    return Date(dateTime.subtract(duration));
  }
}
