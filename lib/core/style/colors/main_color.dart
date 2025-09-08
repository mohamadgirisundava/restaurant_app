import 'package:flutter/material.dart';

enum MainColor {
  green("Green", Colors.green),
  grey("Grey", Colors.grey),
  grey200("Grey200", Color(0xFFEEEEEE)),
  grey300("Grey300", Color(0xFFE0E0E0)),
  grey600("Grey600", Color(0xFF757575)),
  grey900("Grey900", Color(0xFF212121)),
  amber700("Amber700", Color(0xFFFFA000));

  const MainColor(this.label, this.color);

  final String label;
  final Color color;
}
