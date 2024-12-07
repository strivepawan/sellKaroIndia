import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoostPage extends StatefulWidget {
  final String productName;
  final String ImageUrl;
  final String desc;

  const BoostPage(
      {super.key,
        required this.productName,
        required this.ImageUrl,
        required this.desc});

  @override
  State<BoostPage> createState() => _BoostPageState();
}

class _BoostPageState extends State<BoostPage> {
  Razorpay? _razorpay;
  late FlutterLocalNotificationsPlugin _localNotifications;
  int _selectedBoostDuration = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    _initializeNotifications();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _initializeNotifications() {
    _localNotifications = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    _localNotifications.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'boost_channel',
      'Boost Notifications',
      channelDescription: 'Notifications for boost actions',
      importance: Importance.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(0, title, body, notificationDetails);
  }

  Future<void> _sendPaymentDetailsToFirestore(String status, String paymentId, String endTime) async {
    try {
      await _firestore.collection('boostPayments').add({
        'productName': widget.productName,
        'imageUrl': widget.ImageUrl,
        'description': widget.desc,
        'paymentStatus': status,
        'paymentId': paymentId,
        'boostEndTime': endTime,
        'boostDuration': _selectedBoostDuration,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Payment details successfully sent to Firestore.");
    } catch (e) {
      print("Error sending payment details to Firestore: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(response.paymentId);

    DateTime endTime =
    DateTime.now().add(Duration(days: _selectedBoostDuration));
    String endTimeString = endTime.toIso8601String();

    // Save to SharedPreferences
    await _savePaymentDetails(
        "success", response.paymentId ?? "N/A", endTimeString);

    // Send to Firestore
    await _sendPaymentDetailsToFirestore(
        "success", response.paymentId ?? "N/A", endTimeString);

    _showNotification(
      "Payment Successful",
      "Your boost is active for $_selectedBoostDuration days.",
    );

    _showAlertDialog("Payment Successful", "Payment ID: ${response.paymentId}",
        Icons.check_circle, Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await _savePaymentDetails("failure", response.message ?? "Unknown error", "");

    // Send failure details to Firestore
    await _sendPaymentDetailsToFirestore(
        "failure", response.message ?? "N/A", "");

    _showAlertDialog("Payment Failed", response.message ?? "Unknown error",
        Icons.error, Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showAlertDialog(
        "External Wallet", response.walletName ?? "Unknown Wallet", Icons.wallet, Colors.blue);
  }

  void _showAlertDialog(
      String title, String message, IconData icon, Color iconColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 60),
              const SizedBox(height: 16),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }


  Future<void> _savePaymentDetails(
      String status, String details, String endTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("payment_status", status);
    await prefs.setString("payment_details", details);
    if (endTime.isNotEmpty) {
      await prefs.setString("boost_end_time", endTime);
    }
  }

  void _makePayment(int amount, int duration) {
    _selectedBoostDuration = duration;

    if (_razorpay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Payment system is initializing, please try again later.")),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_lcOG1WeAjEGmJO',
      'amount': amount * 100, // Amount in paise
      'name': 'Boost Payment',
      'description': 'Boost Level $amount',
      'prefill': {'contact': '1234567890', 'email': 'example@domain.com'},
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            )),
        title: const Text(
          "Boost Your Product",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductCard(),
              const SizedBox(height: 20),
              _buildBoostOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.ImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Product description: ",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        TextSpan(
                          text: widget.desc,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoostOptions() {
    return Expanded(
      child: ListView(
        children: [
          _buildBoostCard(10, "Basic Boost", Colors.blue, "Boost for 1 day.", 1),
          _buildBoostCard(20, "Pro Boost", Colors.green, "Boost for 7 days.", 7),
          _buildBoostCard(
              30, "Premium Boost", Colors.red, "Boost for 15 days.", 15),
          _buildBoostCard(
              40, "Ultimate Boost", Colors.purple, "Boost for 30 days.", 30),
        ],
      ),
    );
  }

  Widget _buildBoostCard(
      int amount, String title, Color color, String description, int duration) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.flash_on, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _makePayment(amount, duration),
          child: Text(
            "Rs. $amount",
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
