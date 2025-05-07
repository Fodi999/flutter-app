import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  /// Быстрый вызов диалога
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => AppDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Flexible(child: content),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions.map((btn) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: btn,
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

