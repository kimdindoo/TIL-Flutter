// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:calender_scheduler/model/category_color.dart';
import 'package:calender_scheduler/model/schedule.dart';
import 'package:calender_scheduler/model/schedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 값까지 불러올 수 있다.
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Stream<List<Schedule>> watchSchedules(DateTime date){
    // final query = select(schedules);
    // query.where((tbl) => tbl.date.equals(date));
    // return query.watch();

    int number = 3;
    // '3' -> String
    final resp = number.toString();
    // 3 -> int
    final resp2 = number..toString();

    return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
