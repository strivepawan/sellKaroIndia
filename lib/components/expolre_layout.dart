import 'package:flutter/material.dart';

class ExploreLayout extends StatelessWidget {
  final String imageUrl;
  final String heading;
  final String price;
  final String location;
  final Function()? onTap;

  const ExploreLayout({
    Key? key,
    required this.imageUrl,
    required this.heading,
    required this.price,
    required this.location,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Row
            Row(
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  price,
                  style:const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // Heading Row
            Row(
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Price Row
            
            const SizedBox(height: 8),
            // Location Row
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
