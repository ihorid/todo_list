import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  GroupsWidgetModel() {
    _setup();
  }
  Future<void> deleteGroup(int groupeIndex) async {
    final box = await _box;

    final groupKey = (await _box).keyAt(groupeIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);

    await box.deleteAt(groupeIndex);
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteName.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupeIndex) async {
    // await BoxManager.instance.openTaskBox(); //   !!!!!!!
    final group = (await _box).getAt(groupeIndex);
    if (group != null) {
      final configuration =
          TasksWidgetConfiguration(group.key as int, group.name);

      Navigator.of(context)
          .pushNamed(MainNavigationRouteName.tasks, arguments: configuration);
    }
  }

  Future<void> _readGroupFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    // await BoxManager.instance.openTaskBox();
    await _readGroupFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupFromHive);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _listenableBox?.removeListener(_readGroupFromHive);
    await BoxManager.instance.closeBox(await _box);
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
