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

  Future<List<Map<String, dynamic>>> _getBoostedAds() async {
    try {
      print("Fetching boosted ads for userId: ${widget.userId}");

      // Fetch the user document
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(widget.userId)
          .get();

      if (!userDoc.exists) {
        print("No user found with userId: ${widget.userId}");
        return [];
      }

      // Extract the boostedAds field
      List<dynamic>? boostedAds = userDoc.get('boostedAds') as List<dynamic>?;

      if (boostedAds == null || boostedAds.isEmpty) {
        print("No boosted ads found for userId: ${widget.userId}");
        return [];
      }

      // Convert List<dynamic> to List<Map<String, dynamic>>
      return boostedAds.cast<Map<String, dynamic>>();
    } catch (e) {
      print("Error fetching boosted ads: $e");
      return [];
    }
  }

  String _getRemainingTime(String? boostEndTime) {
    if (boostEndTime == null || boostEndTime.isEmpty) {
      return "Invalid time";
    }
    try {
      final endTime = DateTime.parse(boostEndTime);
      final now = DateTime.now();
      final difference = endTime.difference(now);

      if (difference.isNegative) {
        return "Boost expired";
      } else {
        final months = difference.inDays ~/ 30;
        final days = difference.inDays % 30;
        final hours = difference.inHours % 24;
        final minutes = difference.inMinutes % 60;

        final monthsStr = months > 0 ? "$months months " : "";
        final daysStr = days > 0 ? "$days days " : "";
        final hoursStr = hours > 0 ? "$hours hrs " : "";
        final minutesStr = "$minutes mins";

        return "$monthsStr$daysStr$hoursStr$minutesStr remaining";
      }
    } catch (e) {
      print("Error parsing boostEndTime: $e");
      return "Invalid time";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Boosted Ads"),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getBoostedAds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No boosted ads found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data![index];
                    final boostEndTime = doc['boostEndTime'] as String?;
                    final remainingTime = _getRemainingTime(boostEndTime);

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: doc['imageUrl'] != null && doc['imageUrl'].isNotEmpty
                              ? NetworkImage(doc['imageUrl'])
                              : null,
                          child: doc['imageUrl'] == null || doc['imageUrl'].isEmpty
                              ? const Icon(Icons.image_not_supported, color: Colors.grey)
                              : null,
                        ),
                        title: Text(
                          doc['productName'] ?? 'No Title',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['description'] ?? 'No Description',
                              style: const TextStyle(color: Colors.black54),
                            ),
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
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

}
