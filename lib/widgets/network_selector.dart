import 'package:flutter/material.dart';

class NetworkSelector extends StatelessWidget {
  final String? selectedNetwork;
  final Function(String) onNetworkSelected;
  final List<Map<String, dynamic>> networks;

  const NetworkSelector({
    super.key,
    required this.selectedNetwork,
    required this.onNetworkSelected,
    required this.networks,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          networks.map((network) {
            final isSelected = selectedNetwork == network['id'];
            final rate = ((network['rate'] as double) * 100).toInt();

            return GestureDetector(
              onTap: () => onNetworkSelected(network['id']),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? network['color'] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? network['color'] : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          network['icon'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          network['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$rate% rate",
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
