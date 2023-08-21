import 'package:flutter/material.dart';
import 'package:vtech_test/model/item_model.dart';
import 'package:vtech_test/helper/g_enum.dart';
import 'item_dropdown.dart';

class Item extends StatelessWidget {
  final ItemModel data;
  final Function(ActionList?) onChanged;
  const Item({super.key, required this.data, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _item();
  }

  Widget _item() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Card(
        color: Colors.purple.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          title: Text(
            data.title ?? '',
            style: (data.isCompleted ?? false) ? _strike() : _notStrike(),
          ),
          trailing: _dropdown(),
        ),
      ),
    );
  }

  ///
  Widget _dropdown() {
    return ItemDropdown(
      isCompleted: data.isCompleted ?? false,
      onChanged: (value) => onChanged(value),
    );
  }

  TextStyle _notStrike() {
    return const TextStyle(
        fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400);
  }

  TextStyle _strike() {
    return _notStrike().copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.white,
        decorationThickness: 1.3);
  }
}
