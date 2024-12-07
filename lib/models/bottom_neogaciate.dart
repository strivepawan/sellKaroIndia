import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../chat/chat_service.dart';
import '../chat/whatsapp_chat.dart';

class NegotiateWithSellerWidget extends StatelessWidget {
  final String catDocid;
  final String adId;

  const NegotiateWithSellerWidget({
    super.key,
    required this.catDocid,
    required this.adId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: -3,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Negotiate With Seller",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      SendMessage(catDocid: catDocid, adId: adId)
                          .sendMessage(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEEF7),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(Icons.chat_bubble_outline_outlined,
                          color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      WhatsAppService(adDocRef: adId, catDocId: catDocid,)
                          .openWhatsApp();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEEF7),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                    ),
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
