import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import '../models/date_time_helper.dart';
import '../productview/all_product_details/all_product_details.dart';

class AdData {
  final String imageUrl;
  final String adname;
  final int price;
  final String userAddress;
  final Timestamp timestamp;
  final String category;
  final String docId;
  final String adId;
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
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  String searchQuery = '';

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  Stream<List<QuerySnapshot>> fetchAdsDataStream() {
    List<String> categories = [
      'Books', 'Device', 'ElectronicAndAppliences', 'Fashion', 'Furniture',
      'Pets', 'Property', 'Service', 'SpareParts', 'Sports and GYM', 'Vacancies', 'Vehicle'
    ];

    List<Stream<QuerySnapshot>> streams = categories.map((category) {
      return FirebaseFirestore.instance
          .collection('category')
          .doc(category)
          .collection('ads')
          .snapshots();
    }).toList();

    return CombineLatestStream.list(streams);
  }

  List<AdData> filterAds(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      List<String> images = data['images'] != null ? List.from(data['images']) : [];
      String imageUrl = images.isNotEmpty ? images[0] : '';
      String title = data['ad_name'] ?? '';
      dynamic priceValue = data['price'];
      int price = priceValue is int ? priceValue : int.tryParse(priceValue.toString()) ?? 0;
      String userAddress = data['userAddress'] ?? '';
      Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
      String category = document.reference.parent.parent?.id ?? ''; // Get the category
      String docId = document.id; // Get the document ID
      String adId = document.id; // Get the ad ID

      return AdData(
        imageUrl: imageUrl,
        adname: title,
        price: price,
        userAddress: userAddress,
        timestamp: timestamp,
        category: category,
        docId: docId,
        adId: adId,
        isFavorite: false,
      );
    }).toList();
  }

  List<AdData> searchAds(List<AdData> ads, String query) {
    if (query.isEmpty) {
      return [];
    }

    return ads.where((ad) {
      final adNameLower = ad.adname.toLowerCase();
      final searchLower = query.toLowerCase();
      return adNameLower.contains(searchLower);
    }).toList();
  }

  void toggleFavorite(AdData ad) {
    // Handle favorite toggle functionality here
  }

  Future<bool> isFavorite(AdData ad) async {
    // Check if the ad is favorite
    return ad.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      onChanged: updateSearchQuery,
                      decoration: const InputDecoration(
                        hintText: 'Search For Mobile, cars, sports....',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              searchQuery.isEmpty
                  ? const Center(child: Text('Enter a search term to begin'))
                  : Expanded(
                      child: StreamBuilder<List<QuerySnapshot>>(
                        stream: fetchAdsDataStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No data available'));
                          } else {
                            List<AdData> adsData = [];
                            for (var querySnapshot in snapshot.data!) {
                              adsData.addAll(filterAds(querySnapshot));
                            }
      
                            adsData = searchAds(adsData, searchQuery);
      
                            if (adsData.isEmpty) {
                              return const Center(child: Text('No data available'));
                            }
      
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 0.7
                                ),
                                itemCount: adsData.length,
                                itemBuilder: (context, index) {
                                  AdData adData = adsData[index];
                                  return KeyedSubtree(
                                    key: ValueKey(adData.adId),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AllProductDetailsScreen(
                                              category: adData.category,
                                              adId: adData.adId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0xFFEBEEF7),
                                          width: 1.0,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(255, 176, 176, 176),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius:const  BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                                                    child: Image.network(
                                                      adData.imageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: GestureDetector(
                                                    onTap: () => toggleFavorite(adData),
                                                    child: FutureBuilder<bool>(
                                                      future: isFavorite(adData),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Icon(
                                                            Icons.favorite,
                                                            color: snapshot.data! ? Colors.red : Colors.grey,
                                                            size: 24,
                                                          );
                                                        } else if (snapshot.hasError) {
                                                          return const Text('Error checking favorite');
                                                        }
                                                        return const CircularProgressIndicator();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'RS ${adData.price.toString()}',
                                                  style: GoogleFonts.nunito(textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Text(
                                              adData.adname,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.nunito(textStyle:  const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),)
                                            ),
                                          ),
                                          const Divider( height: 2,
                                          color:Color(0xFFEBEEF7) ,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            // crossAxisAlignment: CrossAxisAlignment.,
                                            children: [
                                              const Icon(Icons.location_on, color: Color(0xFF767E94), size: 14),
                                              Expanded(
                                                child: Text(
                                                  adData.userAddress.length > 8
                                                      ? '${adData.userAddress.substring(0, 8)}..'
                                                      : adData.userAddress,
                                                  style:const  TextStyle(
                                                    color: Color(0xFF767E94),
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                DateTimeHelper.formatTimestamp(adData.timestamp),
                                                style:const  TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF767E94),
                                                ),
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
