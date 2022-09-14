DateTime calculateTimeFromEpoch(int epoch) {
  final epochInSeconds = epoch * 1000;
  return DateTime.fromMillisecondsSinceEpoch(epochInSeconds, isUtc: true);
}
