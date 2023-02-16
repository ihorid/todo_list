import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'group.g.dart';

@HiveType(typeId: 3)
class Group {
  @HiveField(0)
  String name;
  Group({required this.name});
}
