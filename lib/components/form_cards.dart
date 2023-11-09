import 'package:flutter/material.dart';

class FormCards extends StatelessWidget {
  final IconData formIcon;
  final String formCardName;
  final String cardUrl;


  const FormCards({
    required this.formIcon,
    required this.formCardName,
    required this.cardUrl,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color _contentColor = Colors.white;
    return Padding(
      padding: const EdgeInsets.all(8.5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.black87,
        shadowColor: Colors.grey,
        elevation: 8.0,
        child: InkWell(
          child: Container(
            width: 150,
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  formIcon,
                  color: _contentColor,
                  size: 75,
                ),
                Text(
                  '$formCardName',
                  style: TextStyle(
                      fontSize: 15,
                      color: _contentColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(cardUrl, );
          },
        ),
      ),
    );
  }
}
