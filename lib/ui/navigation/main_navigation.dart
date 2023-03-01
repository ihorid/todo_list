import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';
import 'package:todo_list/ui/widgets/tasks_form/task_form_widget.dart';

abstract class MainNavigationRouteName {
  static const groups = '/';
  static const groupsForm = '/groupsForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteName.groups;
  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteName.groups: (context) => const GroupsWidget(),
    MainNavigationRouteName.groupsForm: (context) => const GroupFormWidget(),
    };  

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteName.tasks:
        final configuration = settings.arguments as TasksWidgetConfiguration;
        return MaterialPageRoute(
          builder: (context) => TasksWidget(configuration: configuration),
        );
      case MainNavigationRouteName.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TaskFormWidget(groupKey: groupKey),
        );

      default:
        const widget = Text('Navigation Error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
