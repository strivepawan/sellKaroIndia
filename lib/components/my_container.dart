import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final String imageUrl;
  final String address;
  final String amount;
  final String location;
  final String postDate;
  final Function()? onTap;

 const MyContainer({
    required this.imageUrl,
    required this.address,
    required this.amount,
    required this.location,
    required this.postDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
           const  SizedBox(height: 10),
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  amount,
                  style:const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ]
              ),
                // Spacer(),
                Row(
                  children: [
                    Text(
                      location,
                      style:const  TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                 
                // VerticalDivider(
                //   color: Colors.grey,
                //   thickness: 1,
                //   width: 10,
                // ),
                const Spacer(),
                Text(
                  postDate,
                  style:const  TextStyle(
                    color: Colors.grey,
                  ),
                ),
                 ],
                ),
          ],
        ),
      ),
    );
  }
}
