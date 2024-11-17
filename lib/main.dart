import 'package:flutter/material.dart';

import 'app.dart';
import 'data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();

  runApp(const App());
}
