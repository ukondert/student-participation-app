import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

// Tables
class Classes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get teacher => text().nullable()(); // Class teacher/leader
  TextColumn get room => text().nullable()();
  TextColumn get schoolYear => text().nullable()();
}

class Subjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // e.g. "Math"
  TextColumn get shortName => text()(); // e.g. "M"
  TextColumn get notes => text().nullable()();
  IntColumn get classId => integer().references(Classes, #id, onDelete: KeyAction.cascade)();
}

class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get shortCode => text()(); // e.g. "ABC"
  IntColumn get classId => integer().references(Classes, #id, onDelete: KeyAction.cascade)();
}

class NegativeBehaviors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}

class Participations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(Students, #id, onDelete: KeyAction.cascade)();
  IntColumn get subjectId => integer().references(Subjects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isPositive => boolean()(); // true = positive, false = negative
  TextColumn get note => text().nullable()(); // For negative behavior description or other notes
  IntColumn get behaviorId => integer().nullable().references(NegativeBehaviors, #id)(); // Optional link to predefined behavior
}

@DriftDatabase(tables: [Classes, Subjects, Students, NegativeBehaviors, Participations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Default negative behaviors
      await into(negativeBehaviors).insert(NegativeBehaviorsCompanion.insert(description: 'Stört den Unterricht'));
      await into(negativeBehaviors).insert(NegativeBehaviorsCompanion.insert(description: 'Hausübung fehlt'));
      await into(negativeBehaviors).insert(NegativeBehaviorsCompanion.insert(description: 'Material fehlt'));
      await into(negativeBehaviors).insert(NegativeBehaviorsCompanion.insert(description: 'Zuspätkommen'));
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temp directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
