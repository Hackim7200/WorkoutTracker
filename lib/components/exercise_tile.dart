import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String title;
  final String info;
  final VoidCallback onTap;
  final String img;

  const ExerciseTile(
      {super.key,
      required this.title,
      required this.info,
      required this.onTap,
      required this.img});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldColor = Color.fromRGBO(255, 250, 236, 1);
    final Color appBarColor = Color.fromRGBO(87, 142, 126, 1);
    final Color floatingIconColor = Color.fromRGBO(87, 142, 126, 1);
    final Color textColor = Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
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
          height: 100,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(img),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(info,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
