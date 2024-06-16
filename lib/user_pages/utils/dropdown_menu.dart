import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final BuildContext context;
  final List<String> items;
  final String title;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final bool isBlackSelectGroup;

  const CustomDropdownMenu({
    required this.context,
    required this.items,
    required this.title,
    this.selectedValue,
    this.onChanged,
    required this.isBlackSelectGroup,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isBlackSelectGroup? Theme.of(context).colorScheme.onPrimary: Theme.of(context).colorScheme.onSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: 15,
                  fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        value: selectedValue,
        onChanged: onChanged,
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 33,
        ),
        elevation: 2,
        iconSize: 14,
        dropdownColor: Colors.white,
        underline: Container(),
      ),
    );
  }
}
