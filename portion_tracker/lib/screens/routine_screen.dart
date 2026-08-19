import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/routine_item.dart';
import '../providers/routine_provider.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutineProvider>();
    final total = provider.items.length;
    final checkedCount = provider.items.where((i) => provider.isChecked(i.id)).length;
    final startTimes = _computeStartTimes(provider.items, provider.startTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.schedule),
            tooltip: 'Set school start time',
            onPressed: () => _pickStartTime(context, provider),
          ),
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            tooltip: _editing ? 'Done editing' : 'Edit checklist',
            onPressed: () => setState(() => _editing = !_editing),
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset checklist',
            onPressed: () => _confirmAndReset(context, provider),
          ),
        ],
      ),
      body: !provider.isReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress today', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '$checkedCount / $total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : checkedCount / total,
                minHeight: 8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: InkWell(
              onTap: () => _pickStartTime(context, provider),
              child: Text(
                provider.startTime == null
                    ? 'Tap the clock icon to set your school start time'
                    : 'School starts at ${provider.startTime!.format(context)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                for (final item in provider.items)
                  _buildTile(context, provider, item, startTimes[item.id]),
                if (_editing)
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Add item'),
                    onTap: () => _addItem(context, provider),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, TimeOfDay> _computeStartTimes(List<RoutineItem> items, TimeOfDay? schoolStart) {
    if (schoolStart == null) return {};
    final result = <String, TimeOfDay>{};
    var cumulativeMinutes = 0;
    for (final item in items.reversed) {
      cumulativeMinutes += item.durationMinutes;
      var totalMinutes = schoolStart.hour * 60 + schoolStart.minute - cumulativeMinutes;
      totalMinutes = ((totalMinutes % 1440) + 1440) % 1440;
      result[item.id] = TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
    }
    return result;
  }

  Widget _buildTile(BuildContext context, RoutineProvider provider, RoutineItem item, TimeOfDay? startTime) {
    final isChecked = provider.isChecked(item.id);
    final subtitle = startTime != null
        ? 'Start at ${startTime.format(context)} • ${item.durationMinutes} min'
        : '${item.durationMinutes} min';

    return ListTile(
      onTap: _editing ? () => _editItem(context, provider, item) : () => provider.toggle(item.id),
      leading: Icon(
        _editing ? Icons.edit_outlined : (isChecked ? Icons.check_circle : Icons.radio_button_unchecked),
        color: isChecked ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
      ),
      title: Text(
        item.label,
        style: TextStyle(
          color: isChecked && !_editing ? Colors.grey.shade500 : null,
          decoration: isChecked && !_editing ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: _editing
          ? IconButton(icon: const Icon(Icons.close), onPressed: () => provider.removeItem(item.id))
          : null,
    );
  }

  Future<void> _pickStartTime(BuildContext context, RoutineProvider provider) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: provider.startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      await provider.setStartTime(picked);
    }
  }

  Future<void> _addItem(BuildContext context, RoutineProvider provider) async {
    final result = await _showItemDialog(context, title: 'Add item');
    if (result == null) return;
    final label = result.label.trim();
    if (label.isEmpty) return;
    final duration = int.tryParse(result.duration.trim()) ?? 10;
    await provider.addItem(label, duration);
  }

  Future<void> _editItem(BuildContext context, RoutineProvider provider, RoutineItem item) async {
    final result = await _showItemDialog(
      context,
      title: 'Edit item',
      initialLabel: item.label,
      initialDuration: item.durationMinutes.toString(),
    );
    if (result == null) return;
    final label = result.label.trim();
    if (label.isEmpty) return;
    final duration = int.tryParse(result.duration.trim()) ?? item.durationMinutes;
    await provider.renameItem(item.id, label, duration);
  }

  Future<_ItemFormResult?> _showItemDialog(
      BuildContext context, {
        required String title,
        String initialLabel = '',
        String initialDuration = '10',
      }) {
    final labelController = TextEditingController(text: initialLabel);
    final durationController = TextEditingController(text: initialDuration);

    return showDialog<_ItemFormResult>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelController, autofocus: true, decoration: const InputDecoration(labelText: 'Task')),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, _ItemFormResult(labelController.text, durationController.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndReset(BuildContext context, RoutineProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset checklist?'),
        content: const Text("This unchecks every item. This can't be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Reset')),
        ],
      ),
    );
    if (confirmed == true) {
      await provider.resetChecked();
    }
  }
}

class _ItemFormResult {
  final String label;
  final String duration;
  const _ItemFormResult(this.label, this.duration);
}