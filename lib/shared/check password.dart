import 'package:flutter/material.dart';

class CheckPasswordValidate extends StatelessWidget {
  const CheckPasswordValidate(
      {super.key, required this.theCondition, required this.theConditionText});
  final bool theCondition;
  final String theConditionText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theCondition ? Colors.green : Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 189, 189, 189)),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(
          width: 11,
        ),
        Text(theConditionText),
      ],
    );
  }
}
