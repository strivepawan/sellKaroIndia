// lib/models/ad_data.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AdData {
  final String imageUrl;
  final String adname;
  final int price;
  final String userAddress;
  final Timestamp timestamp;
  final String category;
  final String docId;
  final String adId;
  bool isFavorite;

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
