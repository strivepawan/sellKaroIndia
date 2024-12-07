import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this import
import '../models/date_time.dart';
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

class LikeScreen extends StatelessWidget {
  Future<void> _removeFromFavorites(String adId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(adId)
          .delete();
    }
  }

  void _viewDetails(BuildContext context, AdData adData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllProductDetailsScreen(
          category: adData.category,
          adId: adData.adId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.myFavorites), // Localized title
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseAuth.instance.currentUser != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('favorites')
                .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${localizations.error}: ${snapshot.error}')); // Localized error
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(localizations.noFavorites)); // Localized no favorites
          } else {
            List<AdData> favoriteAds = snapshot.data!.docs.map((document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return AdData(
                imageUrl: data['imageUrl'],
                adname: data['adname'],
                price: data['price'],
                userAddress: data['userAddress'],
                timestamp: data['timestamp'],
                category: data['category'],
                docId: document.id,
                adId: data['adId'],
                isFavorite: true,
              );
            }).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                itemCount: favoriteAds.length,
                itemBuilder: (context, index) {
                  AdData ad = favoriteAds[index];
                  FormattedDate formattedDate = FormattedDate(timestamp: ad.timestamp);
                  String displayDate = formattedDate.getFormattedDate();
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _viewDetails(context, ad),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEEF7),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  ad.imageUrl,
                                  width: 100,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ad.adname,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    displayDate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: const Icon(
                                                CupertinoIcons.xmark,
                                                color: Colors.green,
                                              ),
                                              onPressed: () async =>
                                                  await _removeFromFavorites(ad.adId),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${localizations.rs} ${ad.price}', // Localized price prefix
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Container(
                                            height: 40,width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                const Center(child: FaIcon(Icons.crop_square_outlined,size: 32,color: Color(0xFF00BF63),)),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: Text(localizations.view, // Localized "View"
                                                    style: GoogleFonts.montserrat(
                                                      textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
