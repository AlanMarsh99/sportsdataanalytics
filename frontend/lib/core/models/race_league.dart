class RaceLeague {
  int year;
  int round;
  String country;

  RaceLeague({required this.year, required this.round, required this.country});

// Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RaceLeague) return false;
    return year == other.year &&
        round == other.round &&
        country == other.country;
  }

  // Override hashCode
  @override
  int get hashCode => Object.hash(year, round, country);

  // Comparison method for sorting
  static int compare(RaceLeague a, RaceLeague b) {
    if (a.year != b.year) return a.year.compareTo(b.year);
    if (a.round != b.round) return a.round.compareTo(b.round);
    return a.country.compareTo(b.country);
  }
}
