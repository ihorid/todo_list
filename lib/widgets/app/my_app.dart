import 'package:flutter/material.dart';

import '../example/groups/groups_widget.dart';
import '../group_form/group_form_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo',
      initialRoute: '/groups',
      routes: {
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
      },
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
    );
  }
}
