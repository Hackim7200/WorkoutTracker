import 'package:flutter/material.dart';

class Risk extends StatelessWidget {
  final String risk;

  const Risk({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Color.fromRGBO(61, 61, 61, 1);
    final Color cardColor = Color.fromRGBO(245, 236, 213, 1);

    if (risk == "HIGH") {
      return Expanded(
        child: Card(
          elevation: 0.3,
          color: cardColor,
          child: ListTile(
            leading: SizedBox(
              height: 50,
              child: Image.asset("assets/images/sportsDoctor/back (4).png",
                  fit: BoxFit.contain),
            ),
            title: Text("Risk"),
            subtitle: Text("HIGH",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    } else if (risk == "MED") {
      return Expanded(
        child: Card(
            elevation: 0.3,
            color: cardColor,
            child: ListTile(
              leading: SizedBox(
                height: 50,
                child: Image.asset("assets/images/sportsDoctor/MedRisk.png",
                    fit: BoxFit.contain),
              ),
              title: Text("Risk"),
              subtitle: Text("MEDIUM",
                  style: TextStyle(
                      color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
            )),
      );
    } else {
      return Expanded(
        child: Card(
            elevation: 0.3,
            color: cardColor,
            child: ListTile(
              leading: SizedBox(
                height: 50,
                child: Image.asset("assets/images/sportsDoctor/LowRisk.png",
                    fit: BoxFit.contain),
              ),
              title: Text(
                "Risk",
              ),
              subtitle: Text(
                "LOW",
                style: TextStyle(
                    color: const Color.fromARGB(255, 3, 112, 59),
                    fontWeight: FontWeight.bold),
              ),
            )),
      );
    }
  }
}
