import 'package:intl/intl.dart';

class PriceFormatter {
  static String formatPrice(String value) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(int.tryParse(value.replaceAll(',', '')) ?? 0);
  }
}
