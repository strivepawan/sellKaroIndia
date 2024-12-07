// PriceFormatter class definition
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PriceFormatter {
  static String formatPrice(num price) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }
}

// AdData class definition
class AdData {
  final String id;
  final String imageUrl;
  final String adname;
  final int price;
  final String userAddress;
  final Timestamp timestamp;

  AdData({
    required this.id,
    required this.imageUrl,
    required this.adname,
    required this.price,
    required this.userAddress,
    required this.timestamp,
  });

  String get formattedPrice => PriceFormatter.formatPrice(price);
}