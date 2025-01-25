import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoostedAds extends StatefulWidget {
  final String userId;

  const BoostedAds({super.key, required this.userId});

  @override
  State<BoostedAds> createState() => _BoostedAdsState();
}

class _BoostedAdsState extends State<BoostedAds> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch boosted ads from Firestore
  Future<List<Map<String, dynamic>>> _getBoostedAds() async {
    QuerySnapshot snapshot = await _firestore
        .collection('ads') // Replace with your collection name
        .where('boostedAds', arrayContains: {'uid': widget.userId})
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Function to calculate remaining time for a boost
  String _getRemainingTime(String boostEndTime) {
    try {
      final endTime = DateTime.parse(boostEndTime); // Parse string to DateTime
      final now = DateTime.now();
      final difference = endTime.difference(now);

      if (difference.isNegative) {
        return "Boost expired";
      } else {
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        return "$hours hrs $minutes mins remaining";
      }
    } catch (e) {
      return "Invalid time";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getBoostedAds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No boosted ads found.'),
              );
            }

            return ListView(
              children: snapshot.data!.map((doc) {
                final boostEndTime = doc['boostEndTime'] as String;
                final remainingTime = _getRemainingTime(boostEndTime);

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doc['imageUrl'] ?? ''),
                    ),
                    title: Text(doc['productName'] ?? 'No Title'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc['description'] ?? 'No Description'),
                        const SizedBox(height: 4),
                        Text(
                          remainingTime,
                          style: TextStyle(
                            color: remainingTime == "Boost expired"
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
