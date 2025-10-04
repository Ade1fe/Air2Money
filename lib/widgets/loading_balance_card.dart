import 'package:flutter/material.dart';

class LoadingBalanceCard extends StatelessWidget {
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final String? loadingText;

  const LoadingBalanceCard({
    super.key,
    this.gradientStartColor,
    this.gradientEndColor,
    this.height,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      height: height ?? 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientStartColor ?? const Color(0xFF667EEA),
            gradientEndColor ?? const Color(0xFF764BA2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradientStartColor ?? const Color(0xFF667EEA)).withOpacity(
              0.3,
            ),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            if (loadingText != null) ...[
              const SizedBox(height: 12),
              Text(
                loadingText!,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
