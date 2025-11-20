import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';

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
