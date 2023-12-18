import 'package:flutter/material.dart';
import 'package:ui/widgets/content_text_field.dart';

class BinScreen extends StatelessWidget {
  const BinScreen({super.key, required this.binId});

  final String binId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a note')),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          const ContentTextField(),
          // Scrollabl
          ListView.builder(
              itemCount: 2,
              itemBuilder: (context, idx) {
                return Card(
                  child: Text('Title $idx'),
                );
                //
                // return const Text('Item idx', style: TextStyle(color: Colors.white),);
              })
          // ElevatedButton(onPressed: () {}, child: const ContentTextField())
        ],
      ),
    );
  }
}
