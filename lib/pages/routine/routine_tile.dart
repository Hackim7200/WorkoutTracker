import 'package:flutter/material.dart';

class RoutineTile extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const RoutineTile(
      {super.key,
      required this.title,
      required this.description,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);
    final Color textColor = Color.fromRGBO(61, 61, 61, 1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(image,
                    fit: BoxFit.contain),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 6, right: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
