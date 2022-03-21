import 'package:dropin_pos/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CreateClientPage extends StatelessWidget {
  const CreateClientPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(text: "Create Client")
    );
  }
}