import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetInput extends StatelessWidget {
  const SetInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1, // Aspect ratio for each item
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(61, 61, 61, 1),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Set ${index + 1}",
                    style: const TextStyle(
                      color: Color.fromRGBO(250, 250, 236, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "> W E I G H T <",
                        fillColor: Color.fromRGBO(129, 129, 129, 1),
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "> R E P S <",
                        fillColor: Color.fromRGBO(129, 129, 129, 1),
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
