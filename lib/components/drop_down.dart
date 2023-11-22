import 'package:flutter/material.dart';

class TripSheetDropDown extends StatefulWidget {
  final Function(String) onFromChanged;
  final Function(String) onToChanged;

  TripSheetDropDown({required this.onFromChanged, required this.onToChanged});
  @override
  _TripSheetDropDownState createState() => _TripSheetDropDownState();
}

class _TripSheetDropDownState extends State<TripSheetDropDown> {
  String _fromValue = 'Airport';
  String _toValue = 'Airport';

  final List<String> locations = [
    "Airport",
    "Alimatha",
    "Cross Roads",
    "Club med kani",
    "Dhihgirri",
    "Dhon Velli",
    "Ellaidhoo",
    "Felidhoo",
    "Fulidhoo",
    "Gili lankanfushi",
    "Hard Rock",
    "Jumeira",
    "Kuda Hura",
    "Kurumba"
    "Kunavashi",
    "Male'",
    "O Blue",
    "Paradise"
    "Patina Maldives",
    "Ship wreck",
    "Thinadhoo",
    "Landaa Giraavaru",
    "W Maldives",
    "Vadhoo",
    "Varru",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _fromValue,
            onChanged: (String? newValue) {
              setState(() {
                _fromValue = newValue!;
              });
              widget.onFromChanged(newValue!);
            },
            items: locations.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'From',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: _toValue,
            onChanged: (String? newValue) {
              setState(() {
                _toValue = newValue!;
              });
              widget.onToChanged(newValue!);
            },
            items: locations.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'To',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
