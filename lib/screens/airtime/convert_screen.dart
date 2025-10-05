import 'package:air2money/service/airtime_api.dart';
import 'package:air2money/theme/theme.dart';
import 'package:air2money/widgets/balance_card.dart';
import 'package:air2money/widgets/custom_textfield.dart';
import 'package:air2money/widgets/network_selector.dart';
import 'package:air2money/widgets/info_card.dart';
import 'package:air2money/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Assuming you have an ErrorCard widget somewhere,
// adding a placeholder to make the provided code run.
class ErrorCard extends StatelessWidget {
  final String message;
  const ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 8),
          Flexible(
            child: Text(message, style: TextStyle(color: Colors.red[700])),
          ),
        ],
      ),
    );
  }
}

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({super.key});

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();

  String? _selectedNetwork;
  String? _transactionId;
  double _balance = 0.0;
  bool _isLoading = false;
  bool _isLoadingBalance = true;
  String? _errorMessage;
  double? _estimatedCash;

  final List<Map<String, dynamic>> _networks = [
    {
      'id': 'mtn',
      'name': 'MTN',
      'icon': '📱',
      'color': const Color(0xFFFFCC00),
      'rate': 0.85,
    },
    {
      'id': 'glo',
      'name': 'Glo',
      'icon': '🌐',
      'color': const Color(0xFF00A650),
      'rate': 0.82,
    },
    {
      'id': 'airtel',
      'name': 'Airtel',
      'icon': '📡',
      'color': const Color(0xFFED1C24),
      'rate': 0.85,
    },
    {
      'id': '9mobile',
      'name': '9mobile',
      'icon': '📞',
      'color': const Color(0xFF00923F),
      'rate': 0.80,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _amountController.addListener(_calculateEstimatedCash);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    _amountController.removeListener(_calculateEstimatedCash);
    super.dispose();
  }

  void _calculateEstimatedCash() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && _selectedNetwork != null) {
      final network = _networks.firstWhere(
        (n) => n['id'] == _selectedNetwork,
        orElse: () => _networks.first,
      );
      final rate = network['rate'] as double;
      setState(() => _estimatedCash = amount * rate);
    } else {
      setState(() => _estimatedCash = null);
    }
  }

  Future<void> _loadBalance() async {
    setState(() => _isLoadingBalance = true);
    try {
      // NOTE: AirtimeApi.getBalance is a mock/placeholder function
      final bal = await AirtimeApi.getBalance("user_1");
      if (mounted) {
        setState(() {
          _balance = bal;
          _isLoadingBalance = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _balance = 0.0;
          _isLoadingBalance = false;
        });
        // We can choose not to show an error for initial balance loading if it's expected
        // _showError("Failed to load balance: ${e.toString()}");
      }
    }
  }

  Future<void> _sellAirtime() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedNetwork == null) {
      _showError("Please select a network");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // NOTE: AirtimeApi.sellAirtime is a mock/placeholder function
      final res = await AirtimeApi.sellAirtime(
        userId: "user_1",
        network: _selectedNetwork!,
        phone: _phoneController.text,
        amount: double.parse(_amountController.text),
        pin: _pinController.text.isEmpty ? null : _pinController.text,
      );

      if (mounted) {
        setState(() {
          _transactionId = res['transaction']['id'];
          _isLoading = false;
        });
        _loadBalance();
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError("Transaction failed: ${e.toString()}");
      }
    }
  }

  Future<void> _checkTransactionStatus() async {
    if (_transactionId == null) {
      _showError("No transaction to check");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // NOTE: AirtimeApi.getTransaction is a mock/placeholder function
      final tx = await AirtimeApi.getTransaction(_transactionId!);
      if (mounted) {
        setState(() => _isLoading = false);
        _showTransactionStatus(tx['transaction']);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError("Failed to check transaction: ${e.toString()}");
      }
    }
  }

  void _showError(String message) {
    setState(() => _errorMessage = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // airtime_demo_screen.dart: around line 220
  void _showSuccessDialog() {
    final amount = double.parse(_amountController.text);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // CORRECTED ROW HERE: Wrapped Text in Expanded
            title: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                // FIX: Use Expanded to make the text fit the remaining space
                Expanded(
                  child: Text(
                    "Transaction Submitted!",
                    overflow:
                        TextOverflow
                            .ellipsis, // Optional: ensure no overflow if space is extremely tight
                  ),
                ),
              ],
            ),
            // ... (rest of the dialog content remains the same)
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your airtime sale request has been submitted."),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Airtime Amount: ₦${amount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "You'll receive: ₦${_estimatedCash?.toStringAsFixed(2) ?? '0.00'}",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Transaction ID: $_transactionId",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please transfer ₦${amount.toStringAsFixed(2)} airtime to the number provided.",
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
              ],
            ),
            actions: [
              // In ConvertScreen, modify the "Done" button in _showSuccessDialog()
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _clearForm();
                  // Navigate back and force refresh
                  if (context.mounted) {
                    context.pop(true); // Pass 'true' to indicate data changed
                  }
                },
                child: const Text("Done"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _checkTransactionStatus();
                },
                child: const Text("Check Status"),
              ),
            ],
          ),
    );
  }

  void _showTransactionStatus(Map<String, dynamic> transaction) {
    final status = transaction['status'] ?? 'unknown';
    final color =
        status == 'completed'
            ? Colors.green
            : status == 'pending'
            ? Colors.orange
            : Colors.red;

    String statusMessage;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        statusMessage = "Cash has been added to your balance!";
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusMessage = "Waiting for airtime transfer confirmation...";
        statusIcon = Icons.pending;
        break;
      default:
        statusMessage = "Transaction failed or cancelled";
        statusIcon = Icons.error;
    }

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Transaction Status"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: color, size: 64),
                const SizedBox(height: 16),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  "ID: ${transaction['id']}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              if (status == 'completed')
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _loadBalance();
                  },
                  child: const Text("Refresh Balance"),
                ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _clearForm() {
    _phoneController.clear();
    _amountController.clear();
    _pinController.clear();
    setState(() {
      _selectedNetwork = null;
      _errorMessage = null;
      _estimatedCash = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          "",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loadBalance,
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadBalance,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // _isLoadingBalance
            //     ? const LoadingBalanceCard(loadingText: 'Loading balance...')
            //     : BalanceCard(balance: _balance),
            BalanceCard(balance: _balance),
            const SizedBox(height: 16),
            const InfoCard(
              message:
                  "Convert your airtime to cash instantly! Your balance increases when we receive your airtime.",
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 16),
            _buildSellAirtimeForm(),
            if (_transactionId != null) ...[
              const SizedBox(height: 16),
              TransactionCard(
                transactionId: _transactionId!,
                isLoading: _isLoading,
                onCheckStatus: _checkTransactionStatus,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSellAirtimeForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Convert Airtime to Cash",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Your Network",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            NetworkSelector(
              selectedNetwork: _selectedNetwork,
              onNetworkSelected: (networkId) {
                setState(() => _selectedNetwork = networkId);
                _calculateEstimatedCash();
              },
              networks: _networks,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _phoneController,
              label: "Your Phone Number",
              hint: "08039998877",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (val == null || val.isEmpty) return "Required";
                if (val.length < 11) return "Invalid phone number";
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _amountController,
              label: "Airtime Amount to Sell (₦)",
              hint: "500",
              icon: Icons.phone_android,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return "Required";
                final amount = double.tryParse(val);
                if (amount == null || amount <= 0) return "Invalid amount";
                if (amount < 100) return "Minimum amount is ₦100";
                return null;
              },
            ),
            if (_estimatedCash != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // FIX: Wrapped in Flexible to allow text to shrink
                    Flexible(
                      child: const Text(
                        "You will receive:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Added overflow handling
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "₦${_estimatedCash!.toStringAsFixed(2)}",
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // CustomTextField(
            //   controller: _pinController,
            //   label: "Transfer PIN (Optional)",
            //   hint: "1234",
            //   icon: Icons.lock,
            //   obscureText: true,
            //   keyboardType: TextInputType.number,
            // ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              ErrorCard(message: _errorMessage!),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sellAirtime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          "Convert to Cash",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
