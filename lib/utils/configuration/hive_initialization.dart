import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> hiveInitialization({required void Function() onInitialized}) async {
  final applicationDocumentsDirectory = await path.getApplicationDocumentsDirectory();
  Hive.init(applicationDocumentsDirectory.path);
  onInitialized();
}
