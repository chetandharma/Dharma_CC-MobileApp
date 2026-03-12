import 'package:flutter/material.dart';

Widget readOnlyField(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ).copyWith(labelText: label),
    ),
  );
}

Widget statusIndicator(String status) {
  Color color;
  String label;

  switch (status) {
    case 'IN_PROGRESS':
      color = Colors.orange;
      label = 'In Progress';
      break;
    case 'DONE':
      color = Colors.green;
      label = 'Done';
      break;
    default:
      color = Colors.red;
      label = 'Pending';
  }

  return Row(
    children: [
      Icon(Icons.circle, color: color, size: 12),
      const SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
