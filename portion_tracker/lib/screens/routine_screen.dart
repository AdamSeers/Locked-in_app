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
    final startTimes = _computeStartTimes(provider);

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
          if (_editing)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Drag the handle to reorder',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          Expanded(
            child: _editing
                ? ReorderableListView.builder(
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              itemCount: provider.items.length,
              onReorder: (oldIndex, newIndex) => provider.reorderItems(oldIndex, newIndex),
              itemBuilder: (context, index) {
                final item = provider.items[index];
                return _buildTile(context, provider, item, startTimes[item.id], dragIndex: index);
              },
            )
                : ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                for (final item in provider.items)
                  _buildTile(context, provider, item, startTimes[item.id]),
              ],
            ),
          ),
          if (_editing)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _addItem(context, provider),
                  icon: const Icon(Icons.add),
                  label: const Text('Add item'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Works backwards from the school start time so the last item finishes
  /// exactly on time. A checked item's duration is skipped rather than
  /// added to the running total, so once something is done, the items
  /// still unchecked *before* it in the list get pushed to a later (more
  /// relaxed) start time — reflecting that there's less work left, not
  /// just following the original plan blindly.
  Map<String, TimeOfDay> _computeStartTimes(RoutineProvider provider) {
    final schoolStart = provider.startTime;
    if (schoolStart == null) return {};

    final result = <String, TimeOfDay>{};
    var cumulativeMinutes = 0;
    for (final item in provider.items.reversed) {
      if (!provider.isChecked(item.id)) {
        cumulativeMinutes += item.durationMinutes;
      }
      var totalMinutes =
          schoolStart.hour * 60 + schoolStart.minute - cumulativeMinutes;
      totalMinutes = ((totalMinutes % 1440) + 1440) % 1440;
      result[item.id] =
          TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
    }
    return result;
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final total = (((time.hour * 60 + time.minute + minutes) % 1440) + 1440) % 1440;
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }

  Widget _buildTile(
      BuildContext context,
      RoutineProvider provider,
      RoutineItem item,
      TimeOfDay? startTime, {
        int? dragIndex,
      }) {
    final isChecked = provider.isChecked(item.id);
    final isBedtime = item.label == 'Heure de coucher';
    final subtitle = startTime == null
        ? '${item.durationMinutes} min'
        : isBedtime
        ? '${startTime.format(context)}'
        : 'Start at ${startTime.format(context)} • ${item.durationMinutes} min';

    final leadingIcon = Icon(
      _editing ? Icons.drag_handle : (isChecked ? Icons.check_circle : Icons.radio_button_unchecked),
      color: isChecked ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
    );

    return ListTile(
      key: ValueKey(item.id),
      onTap: _editing ? () => _editItem(context, provider, item) : () => provider.toggle(item.id),
      leading: _editing && dragIndex != null
          ? ReorderableDragStartListener(index: dragIndex, child: leadingIcon)
          : leadingIcon,
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