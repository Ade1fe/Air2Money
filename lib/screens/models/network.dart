// models/network.dart
import 'package:flutter/material.dart';

class Network {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final double rate;

  const Network({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.rate,
  });
}
