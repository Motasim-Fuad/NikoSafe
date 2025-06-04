import 'package:flutter/material.dart';

class PrivacyPuppup extends StatefulWidget {
  @override
  _PrivacyPuppupState createState() => _PrivacyPuppupState();
}

class _PrivacyPuppupState extends State<PrivacyPuppup> {
  String selectedOption = 'Public';

  IconData getIcon(String option) {
    switch (option) {
      case 'Connect':
        return Icons.group;
      case 'Only Me':
        return Icons.lock;
      case 'Public':
      default:
        return Icons.public;
    }
  }

  Color getIconColor(String option) {
    switch (option) {
      case 'Connect':
        return Colors.blue;
      case 'Only Me':
        return Colors.red;
      case 'Public':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Color(0xFF1E2A33), // Background color
      onSelected: (value) {
        setState(() {
          selectedOption = value;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'Public',
          child: Row(
            children: const [
              Icon(Icons.public, color: Colors.green),
              SizedBox(width: 8),
              Text('Public', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'Connect',
          child: Row(
            children: const [
              Icon(Icons.group, color: Colors.blue),
              SizedBox(width: 8),
              Text('Connect', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'Only Me',
          child: Row(
            children: const [
              Icon(Icons.lock, color: Colors.red),
              SizedBox(width: 8),
              Text('Only Me', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getIcon(selectedOption), color: getIconColor(selectedOption)),
          const SizedBox(width: 8),
          Text(
            selectedOption,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }
}
