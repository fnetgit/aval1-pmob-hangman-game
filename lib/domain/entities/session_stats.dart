class SessionStats {
  final int wins;
  final int losses;
  final int totalErrors;
  final int hintsUsed;

  const SessionStats({this.wins = 0, this.losses = 0, this.totalErrors = 0, this.hintsUsed = 0});

  int get totalRounds => wins + losses;

  double get winPercentage => totalRounds == 0 ? 0 : wins / totalRounds * 100;

  double get lossPercentage => totalRounds == 0 ? 0 : losses / totalRounds * 100;

  SessionStats copyWith({
    int? wins,
    int? losses,
    int? totalErrors,
    int? hintsUsed,
  }) {
    return SessionStats(
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      totalErrors: totalErrors ?? this.totalErrors,
      hintsUsed: hintsUsed ?? this.hintsUsed,
    );
  }

  SessionStats recordRound({
    required bool won,
    required int errors,
  }) {
    return copyWith(
      wins: won ? wins + 1 : wins,
      losses: won ? losses : losses + 1,
      totalErrors: totalErrors + errors,
    );
  }

  SessionStats recordHint() => copyWith(hintsUsed: hintsUsed + 1);
}
