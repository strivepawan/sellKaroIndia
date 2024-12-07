import 'package:flutter/material.dart';

import 'button_special.dart';

class ProductDetails extends StatelessWidget {
  final String imageUrl;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String productName;
  final String description;
  final String price;
  final String postBy;
  final String location;
  final String Postdate;

  const ProductDetails(i, {
    required this.imageUrl,
   required this.imageUrl1,
    required this.imageUrl2,
    required this.imageUrl3,
    required this.productName,
    required this.description,
    required this.price,
    required this.postBy,
    required this.location,
    required this.Postdate, required product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          SizedBox(
            height: 270,
            child: Center(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
         const  SizedBox(height: 8),
          Row(
            
            children: [
              SizedBox(
              height: 50,
              child: Image.asset(
                imageUrl1,
                fit: BoxFit.cover,
              ),
            ),
            const  SizedBox(width: 8,),
            SizedBox(
              height: 50,
              child: Image.asset(
                imageUrl2,
                fit: BoxFit.cover,
              ),
            ),
            const  SizedBox(width: 8,),
            SizedBox(
              height: 50,
              child: Image.asset(
                imageUrl3,
                fit: BoxFit.cover,
              ),
            ),
          
            ],
          ),
        const  SizedBox(height: 8,),
          // Product Name
          Text(
            productName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),

          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price: $price',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.share),
            ],
          ),
          SizedBox(height: 16),

          // Chat Button
          ButtonSpecial(
            onTap: () {},
            text: 'Chat with Seller',
          ),
          SizedBox(height: 16),

          // Post Date and Location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                ' $postBy',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                ' $location',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                ' $Postdate',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
