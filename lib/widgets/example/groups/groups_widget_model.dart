import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/domain/entity/group.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();
  GroupsWidgetModel() {
    _setup();
  }
  void deleteGroup(int groupeIndex) async{
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter<Group>(GroupAdapter());}
      final box = await Hive.openBox<Group>('group_box');
      await box.deleteAt(groupeIndex);

      
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void _readGroupFromBox(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter<Group>(GroupAdapter());}
      final box = await Hive.openBox<Group>('group_box');
      _readGroupFromBox(box);
      box.listenable().addListener(() => _readGroupFromBox(box));
    
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
