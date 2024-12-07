import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/ad_price_location.dart';
import '../../models/bottom_neogaciate.dart';

class ElectronicProductView extends StatelessWidget {
  final String adId;
  final String catDocid;

  const ElectronicProductView(
      {super.key, required this.adId, required this.catDocid});

  @override
  Widget build(BuildContext context) {
    final currentImageIndex = ValueNotifier<int>(0);

    return FutureBuilder<Map<String, dynamic>>(
      future: fetchAdDetails(adId),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            catDocid,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _buildBody(snapshot, currentImageIndex),
        ),
        bottomNavigationBar: snapshot.hasData
            ? NegotiateWithSellerWidget(catDocid: catDocid, adId: adId)
            : null,
      ),
    );
  }

  Widget _buildBody(AsyncSnapshot<Map<String, dynamic>> snapshot,
      ValueNotifier<int> currentImageIndex) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 40, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(
        child: Text(
          'Ad not found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    final adData = snapshot.data!;
    final imageUrls = List<String>.from(adData['images'] ?? []);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Slider
          if (imageUrls.isNotEmpty)
            Column(
              children: [
                CarouselSlider.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 250,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      currentImageIndex.value = index;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<int>(
                  valueListenable: currentImageIndex,
                  builder: (context, index, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls
                        .asMap()
                        .map((i, url) => MapEntry(
                              i,
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color:
                                      i == index ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ))
                        .values
                        .toList(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Ad Details
          AdDetails(
            adData: adData,
            imageUrls: imageUrls,
            currentImageIndex: currentImageIndex,
            catDocid: catDocid,
            adId: adId,
          ),
          const SizedBox(height: 12),
          // Additional Details
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildDetailsContainer(adData),
          ),
          const SizedBox(height: 8),
          // Description
          AdDescription(adData: adData),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailsContainer(Map<String, dynamic> adData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(color: Colors.grey),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDetailColumn('Brand', adData['brand'] ?? 'No brand'),
            _buildDetailColumn('Model', adData['model'] ?? 'No model'),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> fetchAdDetails(String adId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(catDocid)
          .collection('ads')
          .doc(adId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        data['views'] = data['views'] ?? 0;
        return data;
      }
      throw Exception('Ad not found');
    } catch (error) {
      print('Error fetching ad details: $error');
      rethrow;
    }
  }
}
