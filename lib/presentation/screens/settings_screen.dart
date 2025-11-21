import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import '../widgets/export_import_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final behaviorsAsync = ref.watch(participationRepositoryProvider).watchNegativeBehaviors();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text('Negative Verhaltensweisen', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<List<NegativeBehavior>>(
              stream: behaviorsAsync,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final behaviors = snapshot.data!;
                return ListView.builder(
                  itemCount: behaviors.length,
                  itemBuilder: (context, index) {
                    final behavior = behaviors[index];
                    return ListTile(
                      title: Text(behavior.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref.read(participationRepositoryProvider).deleteNegativeBehavior(behavior.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Daten exportieren'),
            leading: const Icon(Icons.upload_file),
            onTap: () async {
              final includeParticipations = await showDialog<bool>(
                context: context,
                builder: (context) => const ExportImportDialog(
                  title: 'Daten exportieren',
                  content: 'Möchten Sie die Daten exportieren?',
                ),
              );

              if (includeParticipations == null) return;

              try {
                final jsonString = await ref.read(dataExportServiceProvider).exportData(
                  includeParticipations: includeParticipations,
                );
                
                if (Platform.isWindows) {
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Export-Datei speichern',
                    fileName: 'student_participation_export.json',
                    allowedExtensions: ['json'],
                    type: FileType.custom,
                  );

                  if (outputFile != null) {
                     final file = File(outputFile);
                     await file.writeAsString(jsonString);
                     if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Daten erfolgreich exportiert')),
                        );
                     }
                  }
                } else {
                   final directory = await getApplicationDocumentsDirectory();
                   final file = File('${directory.path}/student_participation_export.json');
                   await file.writeAsString(jsonString);
                   await Share.shareXFiles([XFile(file.path)], text: 'Student Participation Data Export');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fehler beim Exportieren: $e')),
                  );
                }
              }
            },
          ),
          ListTile(
            title: const Text('Daten importieren'),
            leading: const Icon(Icons.download_for_offline),
            onTap: () async {
              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );

                if (result != null && result.files.single.path != null) {
                  File file = File(result.files.single.path!);
                  final jsonString = await file.readAsString();
                  
                  if (context.mounted) {
                    final includeParticipations = await showDialog<bool>(
                      context: context,
                      builder: (context) => const ExportImportDialog(
                        title: 'Daten importieren',
                        content: 'Möchten Sie die Daten importieren? Dies fügt neue Daten hinzu.',
                      ),
                    );

                    if (includeParticipations != null && context.mounted) {
                      await ref.read(dataImportServiceProvider).importData(
                        jsonString,
                        includeParticipations: includeParticipations,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Daten erfolgreich importiert')),
                        );
                      }
                    }
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fehler beim Importieren: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBehaviorDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBehaviorDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neues Verhalten'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Beschreibung'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(participationRepositoryProvider).addNegativeBehavior(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}
