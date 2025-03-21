enum TransactionType { sent, received }

enum TransactionStatus { pending, completed, failed }

class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String name;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.name,
    required this.status,
  });
}

