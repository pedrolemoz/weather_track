import 'dart:io';

class MockParser {
  static String parseJSON(String pathToFile) =>
      File('${Directory.current.uri.path.substring(1)}test/$pathToFile').readAsStringSync();
}
