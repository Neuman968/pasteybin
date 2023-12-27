import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_card.dart';

class MainScreen extends StatelessWidget {

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BinListWidget();
  }
}


class BinListWidget extends StatefulWidget {
  @override
  _BinListWidgetState createState() => _BinListWidgetState();
}

class _BinListWidgetState extends State<BinListWidget> {
  late List<Bin> bins = [];

  @override
  void initState() {
    super.initState();
    fetchBins();
  }

  Future<void> fetchBins() async {
    final response = await http.get(Uri.parse('http://localhost:8080/bin'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonBins = json.decode(response.body);
      setState(() {
        bins = jsonBins.map((jsonBin) => Bin.fromJson(jsonBin)).toList();
      });
    } else {
      throw Exception('Failed to load bins');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bins'),
      ),
      body: bins.isNotEmpty
          ? ListView.builder(
              itemCount: bins.length,
              itemBuilder: (context, index) {
                final bin = bins[index];
                return BinCard(bin: bin);
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
