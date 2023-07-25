import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShowDataForm extends StatelessWidget {
  ShowDataForm({required this.label, required this.valueController, super.key});
  final TextEditingController valueController;

  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            enabled: false,
            readOnly: true,
            controller: valueController,
            decoration: InputDecoration(
              disabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              label: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}
