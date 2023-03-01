import 'package:hive/hive.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};
  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox<Group>(
      name: 'group_box',
      typeId: 3,
      adapter: GroupAdapter(),
    );
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox<Task>(
      name: makeTaskBoxName(groupKey),
      typeId: 4,
      adapter: TaskAdapter(),
    );
  }

  String makeTaskBoxName(int groupKey) => 'task_box_$groupKey';

  Future<void> closeBox(Box<Object> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }
    var count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if (count > 0) return;
    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>({
    required String name,
    required int typeId,
    required TypeAdapter<T> adapter,
  }) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }
    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
