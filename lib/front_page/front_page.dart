import 'package:flutter/material.dart';
import 'package:website/items/item_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/front_page/front_buttons.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Allar vörur', 'Konur', 'Karlar', 'Börn'];

    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Fatavörubúð',
                style: GoogleFonts.besley(
                  color: Colors.white,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Positioned(
              top: 5,
                left: 0,
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CategoryButton(
                        label: category,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Clothes()),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
