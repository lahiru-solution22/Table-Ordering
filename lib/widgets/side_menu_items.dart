import 'package:dropin_pos/helpers/responsiveness.dart';
import 'package:dropin_pos/widgets/vertical_menu_items.dart';
import 'package:flutter/material.dart';
import 'horizontal_menu_items.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({Key? key, required this.itemName, required this.onTap})
      : super(key: key);
  final String itemName;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VerticalMenuItem(itemName: itemName, onTap: onTap);
    } else {
      return HorizontalMenuItem(itemName: itemName, onTap: onTap);
    }
  }
}
