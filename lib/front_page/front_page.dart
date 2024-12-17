import 'package:flutter/material.dart';
import 'package:website/front_page/product_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:website/front_page/front_buttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'label': 'Allar vörur', 'categoryId': '0'},
      {'label': 'Konur', 'categoryId': '1'},
      {'label': 'Karlar', 'categoryId': '2'},
      {'label': 'Börn', 'categoryId': '3'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text(
              'Fatavörubúð',
              style: GoogleFonts.besley(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
            body: Column(
              children: [
                Center(
            child:
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CategoryButton(
                        label: category['label'],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Clothes(
                            initialCategory: category['categoryId'],
                              ),
                          ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
                ),
                ),
        ],
      ),
    );
  }
}
