// lib/models/FavoriteIcon.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sell_karo_india/bottomFile/Like_screen.dart';

class FavoriteIcon extends StatefulWidget {
  final AdData adData;

  const FavoriteIcon({Key? key, required this.adData}) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    bool favoriteStatus = await isFavoriteStatus();
    setState(() {
      isFavorite = favoriteStatus;
      isLoading = false;
    });
  }

  Future<bool> isFavoriteStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    DocumentReference favoriteDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.adData.adId);

    DocumentSnapshot doc = await favoriteDocRef.get();
    return doc.exists;
  }

  Future<void> toggleFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userFavsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.adData.adId);

      try {
        DocumentSnapshot docSnapshot = await userFavsRef.get();

        if (docSnapshot.exists) {
          await userFavsRef.delete();
        } else {
          await userFavsRef.set({
            'imageUrl': widget.adData.imageUrl,
            'adname': widget.adData.adname,
            'price': widget.adData.price,
            'userAddress': widget.adData.userAddress,
            'timestamp': widget.adData.timestamp,
            'category': widget.adData.category,
            'docId': widget.adData.docId,
            'adId': widget.adData.adId,
          });
        }

        setState(() {
          isFavorite = !isFavorite;
        });
      } catch (e) {
        print('Error toggling favorite: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return GestureDetector(
      onTap: toggleFavorite,
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_outline,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 24,
      ),
    );
  }
}
