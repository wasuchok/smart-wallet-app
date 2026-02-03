import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newText = newValue.text.replaceAll(',', '');

    // Avoid double dots
    if ('.'.allMatches(newText).length > 1) {
      return oldValue;
    }

    // Split integer and decimal
    List<String> parts = newText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Format integer part
    if (integerPart.isNotEmpty) {
      final formatter = NumberFormat('#,###');
      try {
        integerPart = formatter.format(int.parse(integerPart));
      } catch (e) {
        // If parsing fails, use original
      }
    }

    String formattedText = integerPart;
    if (newText.contains('.') || parts.length > 1) {
      formattedText += '.$decimalPart';
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
