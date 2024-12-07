import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/location_service.dart'; // Adjust the import according to your project structure

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String currentCity = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchCity();
  }

  Future<void> _fetchCity() async {
    final city = await LocationService.getCurrentCity();
    setState(() {
      currentCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, color: Colors.green, size: 20),
        const SizedBox(width: 4),
        Expanded(
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                hintText: currentCity,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            suggestionsCallback: (pattern) async {
              // Replace this with the actual location suggestions fetching logic
              return ['Chandigarh', 'Mohali', 'Ambala', 'Panchkula', 'Zirakpur']
                  .where((location) => location.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                currentCity = suggestion;
              });
            },
          ),
        ),
      ],
    );
  }
}
