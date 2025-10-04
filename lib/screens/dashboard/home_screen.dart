import 'package:air2money/service/airtime_api.dart';
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

  double _balance = 0.0;
  bool _isLoadingBalance = true;
  bool _isLoadingTransactions = true;
  List<Transaction> _recentTransactions = [];

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
    _loadBalance();
    _loadTransactions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadBalance() async {
    setState(() => _isLoadingBalance = true);
    try {
      final balance = await AirtimeApi.getBalance("user_1");
      if (mounted) {
        setState(() {
          _balance = balance;
          _isLoadingBalance = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _balance = 0.0;
          _isLoadingBalance = false;
        });
        _showErrorSnackBar("Failed to load balance: ${e.toString()}");
      }
    }
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoadingTransactions = true);
    try {
      final apiTransactions = await AirtimeApi.getTransactions("user_1");

      if (mounted) {
        final transactions =
            apiTransactions.map((apiTx) {
              final parsed = AirtimeApi.parseTransactionResponse(apiTx);

              return Transaction(
                id: parsed['id'],
                type:
                    parsed['type'] == 'received'
                        ? TransactionType.received
                        : TransactionType.sent,
                amount: parsed['amount'],
                date: parsed['date'],
                name: parsed['name'],
                status:
                    parsed['status'] == 'completed'
                        ? TransactionStatus.completed
                        : TransactionStatus.pending,
              );
            }).toList();

        // Sort by date (most recent first)
        transactions.sort((a, b) => b.date.compareTo(a.date));

        setState(() {
          _recentTransactions = transactions.take(5).toList();
          _isLoadingTransactions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recentTransactions = [];
          _isLoadingTransactions = false;
        });
        _showErrorSnackBar("Failed to load transactions: ${e.toString()}");
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([_loadBalance(), _loadTransactions()]);
    // Add delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: _buildAppBar(),
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshData,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Balance Card with API data
              _isLoadingBalance
                  ? _buildLoadingBalanceCard()
                  : BalanceCard(balance: _balance),

              // Quick Actions
              const QuickActions(),

              // Recent Transactions
              _isLoadingTransactions
                  ? _buildLoadingTransactionsCard()
                  : RecentTransactions(transactions: _recentTransactions),

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
          // Navigate to sell airtime screen
          // context.push('/sell-airtime');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingBalanceCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      height: 200,
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            SizedBox(height: 12),
            Text(
              'Loading balance...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingTransactionsCard() {
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
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 12),
                Text(
                  'Loading transactions...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
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
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset(ImageConstants.logo, fit: BoxFit.contain),
          ),
          const SizedBox(width: 10),
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
                  'Convert Airtime to Cash Instantly',
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
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _refreshData,
        ),
        IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }
}
