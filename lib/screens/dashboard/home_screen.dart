
import 'package:flutter/material.dart';
import 'package:air2money/widgets/app_scaffold.dart';
import '../../theme/theme.dart';
// import '../theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data
  final double _balance = 5280.75;
  final List<Transaction> _recentTransactions = [
    Transaction(
      id: '1',
      type: TransactionType.received,
      amount: 1200.00,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      name: 'John Doe',
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '2',
      type: TransactionType.sent,
      amount: 500.50,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      name: 'Sarah Smith',
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '3',
      type: TransactionType.received,
      amount: 750.25,
      date: DateTime.now().subtract(const Duration(days: 1)),
      name: 'Mike Johnson',
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '4',
      type: TransactionType.sent,
      amount: 320.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      name: 'Emma Williams',
      status: TransactionStatus.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Air2Money',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // appBarColor: AppColors.primary,
      padding:
          EdgeInsets
              .zero, // Remove padding since we'll handle it in our content
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16), // Add padding here instead
            children: [
              // Balance Card
              _buildBalanceCard(),

              // Quick Actions
              _buildQuickActions(),

              // Recent Transactions
              _buildRecentTransactions(),

              // Promotions
              _buildPromotions(),

              // Bottom Padding for FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // FAB for new transaction
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show new transaction dialog/screen
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.visibility_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Hide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₦ ${_balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildBalanceActionButton(
                  icon: Icons.add_rounded,
                  label: 'Add Money',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceActionButton(
                  icon: Icons.arrow_forward_rounded,
                  label: 'Send Money',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceActionButton(
                  icon: Icons.history_rounded,
                  label: 'History',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickActionItem(
                icon: Icons.swap_horiz_rounded,
                label: 'Convert',
                color: AppColors.primary,
                onTap: () {},
              ),
              _buildQuickActionItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Withdraw',
                color: Colors.blue.shade500,
                onTap: () {},
              ),
              _buildQuickActionItem(
                icon: Icons.phone_android_rounded,
                label: 'Airtime',
                color: Colors.green.shade500,
                onTap: () {},
              ),
              _buildQuickActionItem(
                icon: Icons.wifi_rounded,
                label: 'Data',
                color: Colors.purple.shade500,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all transactions
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_recentTransactions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentTransactions.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(color: Colors.grey.shade200, height: 1),
              itemBuilder: (context, index) {
                final transaction = _recentTransactions[index];
                return _buildTransactionItem(transaction);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isReceived = transaction.type == TransactionType.received;
    final statusColor =
        transaction.status == TransactionStatus.completed
            ? Colors.green.shade500
            : Colors.orange.shade500;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isReceived ? Colors.green.shade100 : Colors.red.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isReceived
              ? Icons.arrow_downward_rounded
              : Icons.arrow_upward_rounded,
          color: isReceived ? Colors.green.shade700 : Colors.red.shade700,
          size: 20,
        ),
      ),
      title: Text(
        transaction.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        _formatDate(transaction.date),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${isReceived ? '+' : '-'} ₦${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isReceived ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              transaction.status.name.capitalize(),
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to transaction details
      },
    );
  }

  Widget _buildPromotions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Special Offers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildPromotionCard(
                title: 'Refer & Earn',
                description: 'Get ₦500 for each friend you refer',
                color: Colors.purple.shade500,
                icon: Icons.people_rounded,
              ),
              _buildPromotionCard(
                title: 'Weekend Bonus',
                description: '10% extra on weekend conversions',
                color: Colors.blue.shade500,
                icon: Icons.calendar_today_rounded,
              ),
              _buildPromotionCard(
                title: 'First Time Bonus',
                description: 'Get ₦1000 on your first conversion',
                color: Colors.green.shade500,
                icon: Icons.card_giftcard_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCard({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Models
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

// Extensions
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
