import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class NumericValueInput extends StatelessWidget {
  final int targetValue;
  final Function(int) onValueChanged;

  const NumericValueInput({
    Key? key,
    required this.targetValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Value *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            onChanged: (value) {
              final intValue = int.tryParse(value) ?? 0;
              onValueChanged(intValue);
            },
            keyboardType: TextInputType.number,
            style: TextStyle(color: AppColors.primaryText),
            decoration: InputDecoration(
              hintText: 'e.g., 20, 50, 10',
              hintStyle: TextStyle(color: AppColors.secondaryText),
              filled: true,
              fillColor: AppColors.inputFillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
