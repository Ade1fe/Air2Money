import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.blue[50];
    final bColor = borderColor ?? Colors.blue[200];
    final txtColor = textColor ?? Colors.blue[900];
    final iColor = iconColor ?? Colors.blue[700];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bColor!),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iColor, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: txtColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String message;

  const ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red[50],
      borderColor: Colors.red[200],
      textColor: Colors.red[700],
      iconColor: Colors.red,
    );
  }
}

class SuccessCard extends StatelessWidget {
  final String message;

  const SuccessCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: Colors.green[50],
      borderColor: Colors.green[200],
      textColor: Colors.green[700],
      iconColor: Colors.green,
    );
  }
}
