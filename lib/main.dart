import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'presentation/root_module.dart';
import 'presentation/root_widget.dart';
import 'utils/configuration/hive_initialization.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  hiveInitialization(
    onInitialized: () => runApp(
      ModularApp(
        child: const RootWidget(),
        module: RootModule(),
      ),
    ),
  );
}
