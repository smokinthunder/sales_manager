import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final void Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Spacer(),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
