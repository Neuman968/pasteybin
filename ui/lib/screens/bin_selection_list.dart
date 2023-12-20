import 'package:flutter/material.dart';
import 'package:ui/model/bin.dart';

class BinSelectionList extends StatelessWidget {
  const BinSelectionList({super.key, required this.bins});

  final List<Bin> bins;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFfce2e1), Colors.white]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListView.builder(itemCount: bins.length, itemBuilder: (ctx, idx) {
                return Card(
                  child: Column(children: [
                    Text(bins[idx].id),
                    // const SizedBox(width: 16),
                    Row(children: [
                      const Text('HEllo!'),
                    ],),

                  ]),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
