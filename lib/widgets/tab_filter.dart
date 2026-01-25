import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class TabFilter extends StatelessWidget {
  final TabOption selected;
  final int activeCount;
  final int paidCount;
  final ValueChanged<TabOption> onChanged;

  const TabFilter({
    super.key,
    required this.selected,
    required this.activeCount,
    required this.paidCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabButton(
          label: 'Active ($activeCount)',
          isSelected: selected == TabOption.active,
          onTap: () => onChanged(TabOption.active),
        ),
        const SizedBox(width: 8),
        _TabButton(
          label: 'Paid ($paidCount)',
          isSelected: selected == TabOption.paid,
          onTap: () => onChanged(TabOption.paid),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
