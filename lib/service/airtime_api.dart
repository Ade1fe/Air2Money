import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Airtime API client for Flutter
/// Works with the Node.js mock API running on localhost:4000
/// For Android emulator use 10.0.2.2 instead of localhost. http://10.0.2.2:4000
/// For real device, replace with your PC's IP address (e.g., http://192.168.1.20:4000)

class AirtimeApi {
  // static const String baseUrl = "http://10.0.2.2:4000";
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:4000';

  /// Get available providers
  static Future<List<dynamic>> getProviders() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/providers"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['providers'] ?? [];
      } else {
        throw Exception("Failed to load providers: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  /// Get balance by userId
  static Future<double> getBalance(String userId) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/balance?userId=$userId"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['balanceNGN'] as num).toDouble();
      } else {
        throw Exception("Failed to get balance: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  /// Sell airtime
  static Future<Map<String, dynamic>> sellAirtime({
    required String userId,
    required String network,
    required String phone,
    required double amount,
    String? pin,
  }) async {
    try {
      final body = {
        "userId": userId,
        "network": network,
        "phone": phone,
        "amount": amount,
        if (pin != null) "pin": pin,
      };

      final res = await http.post(
        Uri.parse("$baseUrl/sell"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        final errorBody = jsonDecode(res.body);
        throw Exception(errorBody['error'] ?? "Failed to sell airtime");
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Network error: $e");
    }
  }

  /// Get a transaction by id
  static Future<Map<String, dynamic>> getTransaction(String id) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/transactions/$id"));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("Transaction not found");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  /// Get all transactions for a user
  static Future<List<Map<String, dynamic>>> getTransactions(
    String userId,
  ) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/transactions?userId=$userId"),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data['transactions'] ?? []);
      } else {
        throw Exception("Failed to load transactions: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  /// Convert API transaction to Transaction model
  static Map<String, dynamic> parseTransactionResponse(
    Map<String, dynamic> apiTransaction,
  ) {
    return {
      'id': apiTransaction['id'] ?? '',
      'type':
          apiTransaction['type'] ??
          'received', // 'received' for airtime conversion
      'amount':
          (apiTransaction['cashAmount'] ?? apiTransaction['amount'] ?? 0)
              .toDouble(),
      'date':
          apiTransaction['createdAt'] != null
              ? DateTime.parse(apiTransaction['createdAt'])
              : DateTime.now(),
      'name':
          apiTransaction['network'] != null
              ? 'Airtime Conversion (${apiTransaction['network']})'
              : 'Unknown',
      'status': apiTransaction['status'] ?? 'pending',
      'network': apiTransaction['network'],
      'phone': apiTransaction['phone'],
      'airtimeAmount': apiTransaction['amount'],
    };
  }
}
