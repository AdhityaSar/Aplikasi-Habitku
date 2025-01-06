import 'dart:math';
import 'package:flutter/material.dart';

Color getRandomColor(BuildContext context) {
  final random = Random();
  // Warna acak dengan saturasi tinggi dan kecerahan bisa diatur
  int colorValue = random.nextInt(0xFFFFFF);
  Color color = Color(colorValue).withOpacity(1.0);

  // Menyesuaikan kecerahan untuk mode gelap
  if (Theme.of(context).brightness == Brightness.dark) {
    // Jika mode gelap, buat warna lebih gelap dengan mengurangi kecerahan
    color = color.withOpacity(0.7);  // Atur opacity atau gunakan algoritma lain untuk gelapkan
  }

  return color;
}
