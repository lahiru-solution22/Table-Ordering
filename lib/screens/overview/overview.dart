import 'package:dropin_pos/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class OverViewPage extends StatelessWidget {
  const OverViewPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(text: "OverView")
    );
  }
}