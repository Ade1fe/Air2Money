import 'package:air2money/service/airtime_api.dart';
import 'package:air2money/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedNetwork;
  bool _isLoading = false;
  bool _isLoadingBalance = false;
  double _balance = 0.0;
  String? _transactionId;

  final List<Map<String, dynamic>> _networks = [
    {
      'id': 'mtn',
      'name': 'MTN',
      'icon': '📱',
      'color': Color(0xFFFFCC00),
      'rate': 0.85,
    },
    {
      'id': 'glo',
      'name': 'Glo',
      'icon': '🌐',
      'color': Color(0xFF00A650),
      'rate': 0.82,
    },
    {
      'id': 'airtel',
      'name': 'Airtel',
      'icon': '📡',
      'color': Color(0xFFED1C24),
      'rate': 0.85,
    },
    {
      'id': '9mobile',
      'name': '9mobile',
      'icon': '📞',
      'color': Color(0xFF00923F),
      'rate': 0.80,
    },
  ];

  final String _userId = "user_1"; // later from storage

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    setState(() => _isLoadingBalance = true);
    try {
      final bal = await AirtimeApi.getBalance(_userId);
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
      }
    }
  }

  Future<void> _buyAirtime() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedNetwork == null) {
      _showError("Please select a network");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // FIXED: Now using buyAirtime() instead of sellAirtime()
      // This will deduct the amount from the user's balance
      final res = await AirtimeApi.buyAirtime(
        userId: _userId,
        network: _selectedNetwork!.toLowerCase(),
        phone: _phoneController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("🎉 Success!"),
            content: Text(
              "Your airtime purchase was successful!\n\nTransaction ID: $_transactionId",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Clear form after successful purchase
                  _phoneController.clear();
                  _amountController.clear();
                  setState(() {
                    _selectedNetwork = null;
                    _transactionId = null;
                  });
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("❌ Error"),
            content: Text(message, style: GoogleFonts.poppins(fontSize: 14)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close"),
              ),
            ],
          ),
    );
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
        title: Text(
          "Buy Airtime",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loadBalance,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Wallet Balance",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  _isLoadingBalance
                      ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        "₦${_balance.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Network",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children:
                        _networks.map((network) {
                          final bool isSelected =
                              _selectedNetwork == network['id'];
                          return ChoiceChip(
                            label: Text(
                              "${network['icon']} ${network['name']}",
                              style: GoogleFonts.poppins(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _selectedNetwork = network['id']);
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: network['color'],
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _phoneController,
                    label: "Phone Number",
                    hint: "08039998877",
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "Enter phone number";
                      if (val.length < 10) return "Invalid phone number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _amountController,
                    label: "Amount (₦)",
                    hint: "500",
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Enter amount";
                      final numValue = double.tryParse(val);
                      if (numValue == null || numValue <= 0) {
                        return "Enter a valid amount";
                      }
                      // Check if user has sufficient balance
                      if (numValue > _balance) {
                        return "Insufficient balance";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _buyAirtime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                "Buy Airtime",
                                style: GoogleFonts.poppins(
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
          ],
        ),
      ),
    );
  }
}
