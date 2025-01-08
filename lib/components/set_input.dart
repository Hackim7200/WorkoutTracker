import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetInput extends StatelessWidget {
  const SetInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(61, 61, 61, 1)),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text("Set 1",
                            style: TextStyle(
                                color: Color.fromRGBO(250, 250, 236, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "> W E I G H T <",
                                fillColor: Color.fromRGBO(129, 129, 129, 1),
                                filled: true),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                hintText: "> R E P S <",
                                fillColor: Color.fromRGBO(129, 129, 129, 1),
                                filled: true),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
