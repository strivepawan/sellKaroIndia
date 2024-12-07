
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/ad_price_location.dart';
import '../../models/bottom_neogaciate.dart';

class ServiceDetailsView extends StatelessWidget {
  final String adId;
  final String catDocid;

  const ServiceDetailsView({super.key, required this.adId, required this.catDocid});

  @override
  Widget build(BuildContext context) {
    final currentImageIndex = ValueNotifier<int>(1);
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAdDetails(adId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          return Scaffold(
            appBar: AppBar(
              title: Text(catDocid),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
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
                  AdDetails(adData: adData, imageUrls: imageUrls, currentImageIndex: currentImageIndex, catDocid: catDocid, adId: adId),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1FFF7),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Details'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Salary From'),
                              Text(
                                adData['price'].toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  AdDescription(adData: adData,),
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

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
