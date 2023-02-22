import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  GroupsWidgetModel() {
    _setup();
  }
  void deleteGroup(int groupeIndex) async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter<Group>(GroupAdapter());
    }

    final box = await Hive.openBox<Group>('group_box');
    await box.getAt(groupeIndex)?.tasks?.deleteAllFromHive();

    await box.deleteAt(groupeIndex);
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void showTasks(BuildContext context, int groupeIndex) async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter<Group>(GroupAdapter());
    }

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final box = await Hive.openBox<Group>('group_box');
    await Hive.openBox<Task>('task_box'); //   !!!!!!!

    final groupKey = await box.keyAt(groupeIndex) as int;

    Navigator.of(context).pushNamed('/groups/tasks', arguments: groupKey);
  }

  void _readGroupFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter<Group>(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('group_box');
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('task_box');
    _readGroupFromHive(box);
    box.listenable().addListener(() => _readGroupFromHive(box));
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier<GroupsWidgetModel> {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {super.key, required this.model, required Widget child})
      : super(child: child, notifier: model);

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
