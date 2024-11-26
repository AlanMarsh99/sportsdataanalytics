class RaceLeague {
  int year;
  int round;
  String country;

  RaceLeague({required this.year, required this.round, required this.country});

  // Compare function for sorting
  static int compare(RaceLeague a, RaceLeague b) {
    // First compare by year (descending)
    if (a.year != b.year) {
      return b.year.compareTo(a.year);
    }
    // Then compare by round (descending)
    return b.round.compareTo(a.round);
  }
}
