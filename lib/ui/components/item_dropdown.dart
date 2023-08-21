import 'package:flutter/material.dart';
import 'package:vtech_test/helper/g_enum.dart';

class ItemDropdown extends StatelessWidget {
  final bool isCompleted;
  final Function(ActionList?) onChanged;
  const ItemDropdown(
      {super.key, required this.isCompleted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _dropdown();
  }

  Widget _dropdown() {
    List<ActionList> actions = [
      ActionList.edit,

      /// mark complete or incomplete
      (isCompleted) ? ActionList.markIncompleted : ActionList.markCompleted,
      ActionList.remove
    ];

    return DropdownButton<ActionList>(
      icon: const Icon(Icons.more_vert),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(),
      onChanged: (ActionList? value) => onChanged(value),
      items: actions.map<DropdownMenuItem<ActionList>>((value) {
        return DropdownMenuItem<ActionList>(
          value: value,
          child: Text(
            value.title,
            style: TextStyle(
                fontSize: 14,
                color: value == ActionList.remove ? Colors.red : null),
          ),
        );
      }).toList(),
    );
  }
}
