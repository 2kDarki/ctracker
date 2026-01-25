import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/change_record.dart';
import 'stores/change_record_store.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ChangeRecordAdapter());

  final store = await ChangeRecordStore.create();

  runApp(
    ChangeNotifierProvider<ChangeRecordStore>.value(
      value: store,
      child: const ChangeTrackerApp(),
    ),
  );
}
