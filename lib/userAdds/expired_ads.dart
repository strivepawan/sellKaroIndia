import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpiredAds extends StatelessWidget {
  final String userId;

  ExpiredAds({required this.userId});

  Future<List<DocumentSnapshot>> _getExpiredAds() async {
    // Your logic to fetch expired ads from Firestore
    // Replace 'your_collection' with the actual collection name
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('your_collection')
        .where('userId', isEqualTo: userId)
        .where('isExpired', isEqualTo: true)
        .get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _getExpiredAds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No expired ads found.');
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.map((doc) {
            return ListTile(
              title: Text(doc['title'] ?? ''),
              subtitle: Text(doc['description'] ?? ''),
            );
          }).toList(),
        );
      },
    );
  }
}
