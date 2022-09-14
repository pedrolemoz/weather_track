bool listEquals<T>(List<T>? firstList, List<T>? secondList) {
  if (firstList == null) return secondList == null;
  if (secondList == null || firstList.length != secondList.length) return false;
  if (identical(firstList, secondList)) return true;
  for (int index = 0; index < firstList.length; index += 1) {
    if (firstList[index] != secondList[index]) return false;
  }
  return true;
}
