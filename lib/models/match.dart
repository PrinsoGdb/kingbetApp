class Match {
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final String matchDate;
  final String leagueName;

  Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.matchDate,
    required this.leagueName,
  });

  // Factory method to create a Match object from JSON data
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      homeTeam: json['teams']['home']['name'],
      awayTeam: json['teams']['away']['name'],
      homeLogo: json['teams']['home']['logo'],
      awayLogo: json['teams']['away']['logo'],
      matchDate: DateTime.parse(json['fixture']['date']).toLocal().toString(),
      leagueName: json['league']['name'],
    );
  }

  // Method to convert a Match object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'teams': {
        'home': {'name': homeTeam, 'logo': homeLogo},
        'away': {'name': awayTeam, 'logo': awayLogo},
      },
      'fixture': {'date': matchDate},
      'league': {'name': leagueName},
    };
  }
}
