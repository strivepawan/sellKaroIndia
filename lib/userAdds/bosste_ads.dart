

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoostedAds extends StatefulWidget {
  final String userId;

  const BoostedAds({super.key, required this.userId});

  @override
  State<BoostedAds> createState() => _BoostedAdsState();
}

class _BoostedAdsState extends State<BoostedAds> {
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // Function to handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment success: ${response.paymentId}");
    // You can add logic here to handle the success response, e.g., update Firestore
  }

  // Function to handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment error: ${response.code} - ${response.message}");
    // You can add logic here to handle the error response
  }

  // Function to handle external wallet selection
  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External wallet: ${response.walletName}");
    // You can add logic here to handle the external wallet selection
  }

  // Function to initiate the Razorpay payment process
  void _initiatePayment() {
    var options = {
      'key': 'rzp_test_GcZZFDPP0jHtC4',
      'amount': 500, // Amount in paise (e.g., 500 paise = 5 INR)
      'name': 'Pawan Kumar',
      'description': 'Fine T-Shirt',
      'prefill': {
        'contact': '7764993094',
        'email': 'test@gmail.com',
      }
    };
    razorpay.open(options);
  }

  // Function to fetch boosted ads from Firestore
  Future<List<DocumentSnapshot>> _getBoostedAds() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('your_collection')
        .where('userId', isEqualTo: widget.userId)
        .where('isBoosted', isEqualTo: true)
        .get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Payment Button
        SizedBox(
          width: 200, // Constrain width
          child: OutlinedButton(
            onPressed: _initiatePayment,
            child: const Text("Pay 5 Rs"),
          ),
        ),
        // FutureBuilder to fetch and display boosted ads
        FutureBuilder<List<DocumentSnapshot>>(
          future: _getBoostedAds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No boosted ads found.'),
              );
            }

            // Wrapping ListView with a SizedBox to constrain its height
            return SizedBox(
              height: 400, // Adjust this height based on your UI
              child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.map((doc) {
                  return ListTile(
                    title: Text(doc['title'] ?? ''),
                    subtitle: Text(doc['description'] ?? ''),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
