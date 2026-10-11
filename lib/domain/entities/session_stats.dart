class SessionStats {
  final int wins;
  final int losses;
  final int totalErrors;
  final int hintsUsed;

  const SessionStats({this.wins = 0, this.losses = 0, this.totalErrors = 0, this.hintsUsed = 0});

  int get totalRounds => wins + losses;

  double get winPercentage => totalRounds == 0 ? 0 : wins / totalRounds * 100;

  double get lossPercentage => totalRounds == 0 ? 0 : losses / totalRounds * 100;

  SessionStats recordRound({
    required bool won,
    required int errors,
  }) {
    return SessionStats(
      wins: wins + (won ? 1 : 0),
      losses: losses + (won ? 0 : 1),
      totalErrors: totalErrors + errors,
      hintsUsed: hintsUsed,
    );
  }

  SessionStats recordHint() {
    return SessionStats(
      wins: wins,
      losses: losses,
      totalErrors: totalErrors,
      hintsUsed: hintsUsed + 1,
    );
  }
}
