import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/entities.dart';

class CsvExporter {
  static Future<void> exportSubjectData({
    required String className,
    required String subjectName,
    required List<Student> students,
    required List<Participation> participations,
  }) async {
    final List<List<dynamic>> rows = [];

    // Header
    rows.add([
      'Datum',
      'Uhrzeit',
      'Klasse',
      'Fach',
      'Schüler Vorname',
      'Schüler Nachname',
      'Typ',
      'Details',
    ]);

    // Data
    // Create a map for quick student lookup
    final studentMap = {for (var s in students) s.id: s};

    for (var p in participations) {
      final student = studentMap[p.studentId];
      if (student != null) {
        rows.add([
          DateFormat('yyyy-MM-dd').format(p.date),
          DateFormat('HH:mm').format(p.date),
          className,
          subjectName,
          student.firstName,
          student.lastName,
          p.isPositive ? 'Positiv' : 'Negativ',
          p.note ?? '',
        ]);
      }
    }

    // Generate CSV string
    final csvData = const ListToCsvConverter().convert(rows);

    // Save to file
    final directory = await getTemporaryDirectory();
    final fileName = 'Mitarbeit_${className}_${subjectName}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(csvData);

    // Share (migrated from deprecated Share.shareXFiles)
    await Share.shareXFiles(
      [XFile(path)],
      text: 'Mitarbeits-Export für $className - $subjectName',
    );
  }
}
