import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/app/my_app.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  const app = MyApp();
  runApp(app);
  

}
