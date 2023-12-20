import 'package:flutter/material.dart';

class BinSelection extends StatelessWidget {
  const BinSelection({super.key});

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
            children: [ListView.builder(itemBuilder: (ctx, idx) {
              
            })],
          ),
        ),
      ),
    );
  }
}
