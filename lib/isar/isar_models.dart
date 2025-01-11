import 'package:isar/isar.dart';

part 'database.g.dart';

@Collection()
class IsarVideo {
  Id id = Isar.autoIncrement;
  late String topic;
  late String url;
  late String script;
}