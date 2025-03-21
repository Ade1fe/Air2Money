
import 'package:flutter/material.dart';
import 'package:air2money/widgets/app_scaffold.dart';
import '../../consants/image_constants.dart' show ImageConstants;
import '../../models/transaction.dart'
    show Transaction, TransactionStatus, TransactionType;
import '../../theme/theme.dart';
import '../../widgets/balance_card.dart' show BalanceCard;
import '../../widgets/promotions.dart' show Promotions;
import '../../widgets/quick_actions.dart' show QuickActions;
import '../../widgets/recent_transactions.dart' show RecentTransactions;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
      appBar: _buildAppBar(),
      padding: EdgeInsets.zero,
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
            padding: const EdgeInsets.all(16),
            children: [
              // Balance Card
              BalanceCard(balance: _balance),

              // Quick Actions
              const QuickActions(),

              // Recent Transactions
              RecentTransactions(transactions: _recentTransactions),

              // Promotions
              const Promotions(),

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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset(ImageConstants.logo, fit: BoxFit.contain),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Air2Money',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Convert Airtel to Cash Instantly',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_rounded),
          onPressed: () {},
        ),
        IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }
}
