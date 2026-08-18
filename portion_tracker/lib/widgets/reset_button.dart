import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/portion_provider.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.restart_alt),
      tooltip: 'Reset today',
      onPressed: () => _confirmAndReset(context),
    );
  }

  Future<void> _confirmAndReset(BuildContext context) async {
    final provider = context.read<PortionProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset today?'),
        content: const Text(
          "This clears every portion you've logged today on both pages. "
              "This can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.resetToday();
    }
  }
}