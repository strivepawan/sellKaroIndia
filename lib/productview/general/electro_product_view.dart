import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/ad_price_location.dart';
import '../../models/bottom_neogaciate.dart';

class ElectroPrdouctView extends StatelessWidget {
  final String adId;
  final String catDocid;

  const ElectroPrdouctView({super.key, required this.adId, required this.catDocid});

  @override
  Widget build(BuildContext context) {
    final currentImageIndex = ValueNotifier<int>(1);
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAdDetails(adId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(catDocid),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(catDocid),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(catDocid),
            ),
            body: const Center(
              child: Text('No data found.'),
            ),
          );
        } else {
          Map<String, dynamic> adData = snapshot.data!;
          List<String> imageUrls = List<String>.from(adData['images']);

          return Scaffold(
            appBar: AppBar(
              title: Text(catDocid),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 AdDetails(
                    adData: adData,
                    imageUrls: imageUrls,
                    currentImageIndex: currentImageIndex,
                    catDocid: catDocid,
                    adId: adId,
                  ),
                  AdDescription(adData: adData),
                  const SizedBox(height: 16,)
                ],
              ),
            ),
            bottomNavigationBar: NegotiateWithSellerWidget(catDocid: catDocid, adId: adId),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchAdDetails(String adId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(catDocid)
          .collection('ads')
          .doc(adId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Ad not found');
      }
    } catch (error) {
      print('Error fetching ad details: $error');
      rethrow;
    }
  }

}
