
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/ad_price_location.dart';
import '../../models/bottom_neogaciate.dart';

class VichledetailsView extends StatelessWidget {
  final String adId;
  final String catDocid;

  const VichledetailsView({super.key, required this.adId, required this.catDocid});

  @override
  Widget build(BuildContext context) {
    final currentImageIndex = ValueNotifier<int>(1);
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAdDetails(adId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(catDocid),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Show an error message if fetching data fails
          return Scaffold(
            appBar: AppBar(
              title: Text(catDocid),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Display ad details once data is fetched successfully
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
                  const SizedBox(height: 12,),
                   Container(
  decoration: BoxDecoration(
    color: const Color(0xFFF1FFF7),
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: Column(
      crossAxisAlignment:CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fuel Type'),
                  Text(
                    adData['fuel_type']?? 'N/A',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kilometer'),
                  Text(
                    adData['kilometers_driven']?? 'N/A',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Type'),
                  Text(
                    adData['transmission_type']?? 'N/A',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Owner Type'),
                  Text(
                    adData['number_of_owners']!+" nd"??'N/A',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Brand'),
                  Text(
                    adData['brand'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Model'),
                  Text(
                    adData['model']?? 'N/A',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),

                  const SizedBox(height: 8,),
                 
                 AdDescription(adData: adData),
                 const SizedBox(height: 16,),
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
        int views = data['views'] ?? 0; // Fetch the views count from Firestore
        data['views'] = views; // Add the views count to the data map
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
