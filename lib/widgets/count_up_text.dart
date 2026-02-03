import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountUpText extends StatelessWidget {
  final double endValue;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int precision;

  const CountUpText({
    super.key,
    required this.endValue,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.precision = 2,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: endValue),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutExpo,
      builder: (context, value, child) {
        return Text(
          '$prefix${NumberFormat.currency(symbol: '', decimalDigits: precision).format(value)}$suffix',
          style: style,
        );
      },
    );
  }
}
