import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final Map<String, String?> fields;

  const ProfileInfo({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.entries.map((entry) {
        final title = entry.key;
        final value = (entry.value == null || entry.value!.isEmpty) ? '—' : entry.value!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(value),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
