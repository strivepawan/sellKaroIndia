import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/ad_price_location.dart';
import '../../models/bottom_neogaciate.dart';

class PropertyDetailsView extends StatelessWidget {
  final String adId;
  final String catDocid;

  const PropertyDetailsView({super.key, required this.adId, required this.catDocid});

  @override
  Widget build(BuildContext context) {
    final currentImageIndex = ValueNotifier<int>(1);
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAdDetails(adId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(catDocid)),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(title: Text(catDocid),backgroundColor: Colors.white,),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          Map<String, dynamic> adData = snapshot.data!;
          List<String> imageUrls = List<String>.from(adData['images']);
          return Scaffold(
            appBar: AppBar(title: Text(catDocid)),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    const SizedBox(height: 12),
                    _buildAdditionalDetails(adData),
                    const Divider(thickness: 1.0),
                    AdDescription(adData: adData),
                    const SizedBox(height: 16,)
                  ],
                ),
              ),
            ),
            bottomNavigationBar: NegotiateWithSellerWidget(catDocid: catDocid, adId: adId),
          );
        }
      },
    );
  }

  Widget _buildAdditionalDetails(Map<String, dynamic> adData) {
    List<Widget> detailRows = [];

    void addDetailRow(String label1, String? value1, String label2, String? value2) {
      if ((value1 != null && value1.isNotEmpty) || (value2 != null && value2.isNotEmpty)) {
        detailRows.add(
          _buildDetailRow(
            label1, value1 ?? '',
            label2, value2 ?? ''
          )
        );
      }
    }

    addDetailRow('TYPE:', adData['type'], 'BEDROOMS:', adData['bedrooms']?.toString());
    addDetailRow('BATHROOMS:', adData['bathrooms']?.toString(), 'FURNISHING:', adData['furnishing']);
    addDetailRow('LISTED BY:', adData['listed_by'], 'S-B AREA (FT²):', adData['super_builtup_area']?.toString());
    addDetailRow('CARPET AREA (FT²):', adData['carpet_area']?.toString(), 'BACHELORS ALLOWED:', adData['bachelors_allowed'] != null ? (adData['bachelors_allowed'] ? 'Yes' : 'No') : null);
    addDetailRow('CAR PARKING:', adData['car_parking']?.toString(), 'FACING:', adData['facing']);
    addDetailRow('PROJECT NAME:', adData['project_name'], 'CONTACT:', adData['contact']);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1FFF7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: detailRows,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label1, String value1, String label2, String value2) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1FFF7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // First Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    value1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Second Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    value2,
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
      ),
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
        int views = data['views'] ?? 0;
        data['views'] = views;
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
