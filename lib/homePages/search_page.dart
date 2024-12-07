import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../models/date_time_helper.dart';
import '../productview/all_product_details/all_product_details.dart';

class AdData {
  final String imageUrl, adname, userAddress, category, docId, adId;
  final int price;
  final Timestamp timestamp;
  final bool isFavorite;

  AdData({
    required this.imageUrl,
    required this.adname,
    required this.price,
    required this.userAddress,
    required this.timestamp,
    required this.category,
    required this.docId,
    required this.adId,
    required this.isFavorite,
  });
}

class SearchItem extends StatefulWidget {
  const SearchItem({super.key});

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  String searchQuery = '';

  void updateSearchQuery(String query) {
    setState(() => searchQuery = query);
  }

  Stream<List<QuerySnapshot>> fetchAdsDataStream() {
    List<String> categories = [
      'Books',
      'Device',
      'ElectronicAndAppliences',
      'Fashion',
      'Furniture',
      'Pets',
      'Property',
      'Service',
      'SpareParts',
      'Sports and GYM',
      'Vacancies',
      'Vehicle'
    ];

    return CombineLatestStream.list(categories.map((category) {
      return FirebaseFirestore.instance
          .collection('category')
          .doc(category)
          .collection('ads')
          .snapshots();
    }).toList());
  }

  List<AdData> filterAds(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      final data = document.data() as Map<String, dynamic>;
      final images = List.from(data['images'] ?? []);
      return AdData(
        imageUrl: images.isNotEmpty ? images[0] : '',
        adname: data['ad_name'] ?? '',
        price: int.tryParse(data['price'].toString()) ?? 0,
        userAddress: data['userAddress'] ?? '',
        timestamp: data['timestamp'] ?? Timestamp.now(),
        category: document.reference.parent.parent?.id ?? '',
        docId: document.id,
        adId: document.id,
        isFavorite: false,
      );
    }).toList();
  }

  List<AdData> searchAds(List<AdData> ads) {
    return searchQuery.isEmpty
        ? []
        : ads
            .where((ad) =>
                ad.adname.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
  }

  void toggleFavorite(AdData ad) {
    // Handle favorite toggle
  }

  Future<bool> isFavorite(AdData ad) async {
    return ad.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Search Items',
              style: GoogleFonts.poppins(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  autofocus: true,
                  onChanged: updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search for Mobile, Cars, Sports...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: searchQuery.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_outlined,
                            size: 70,
                          ),
                          Center(
                              child: Text('Enter a search term to begin',
                                  style: TextStyle(
                                      fontSize: 22.5,
                                      fontWeight: FontWeight.w800))),
                        ],
                      )
                    : StreamBuilder<List<QuerySnapshot>>(
                        stream: fetchAdsDataStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available'));
                          } else {
                            var adsData =
                                snapshot.data!.expand(filterAds).toList();
                            adsData = searchAds(adsData);

                            if (adsData.isEmpty) {
                              return Center(child: Text('No data available'));
                            }

                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 12.0,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: adsData.length,
                                itemBuilder: (context, index) {
                                  final ad = adsData[index];
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AllProductDetailsScreen(
                                            category: ad.category,
                                            adId: ad.adId,
                                          ),
                                        )),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFFE1E8F0),
                                            width: 1.0),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0xFFE0E0E0),
                                              blurRadius: 8,
                                              offset: Offset(0, 4))
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16),
                                                          topRight:
                                                              Radius.circular(
                                                                  16)),
                                                  child: Image.network(
                                                      ad.imageUrl,
                                                      fit: BoxFit.cover,
                                                      height: 180,
                                                      width: double.infinity),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        toggleFavorite(ad),
                                                    child: FutureBuilder<bool>(
                                                      future: isFavorite(ad),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Icon(
                                                            Icons.favorite,
                                                            color: snapshot
                                                                    .data!
                                                                ? Colors.red
                                                                : Colors.grey,
                                                            size: 28,
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return const Icon(
                                                              Icons.error,
                                                              size: 28,
                                                              color:
                                                                  Colors.red);
                                                        }
                                                        return const CircularProgressIndicator();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text('₹${ad.price}',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(ad.adname,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16)),
                                          ),
                                          const Divider(
                                              height: 2,
                                              color: Color(0xFFE1E8F0)),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  color: Color(0xFF767E94),
                                                  size: 16),
                                              Expanded(
                                                  child: Text(ad.userAddress,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF767E94),
                                                          fontSize: 14))),
                                              Text(
                                                  DateTimeHelper
                                                      .formatTimestamp(
                                                          ad.timestamp),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Color(0xFF767E94))),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
