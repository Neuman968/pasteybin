import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_button.dart';
import 'package:ui/widgets/bin_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Future<void> addNewBin(GoRouter router) async {
    final response = await http.post(Uri.parse('http://localhost:8080/bin'));

    if (response.statusCode == 200) {
      final dynamic jsonBin = json.decode(response.body);
      final Bin bin = Bin.fromJson(jsonBin);
      router.go('/bin/${bin.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bins'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CurrentBinList(
              onBinSelect: (bin) {
                GoRouter.of(context).go('/bin/${bin.id}');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BinButton(
                text: 'New Bin',
                onPressed: () {
                  addNewBin(GoRouter.of(context));
                }),
          )
        ],
      ),
    );
  }
}

class CurrentBinList extends StatefulWidget {
  const CurrentBinList({super.key, required this.onBinSelect});

  final Function(Bin) onBinSelect;

  @override
  _CurrentBinListState createState() => _CurrentBinListState();
}

class _CurrentBinListState extends State<CurrentBinList> {
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
    return bins.isNotEmpty
        ? ListView.builder(
            itemCount: bins.length,
            itemBuilder: (context, index) {
              final bin = bins[index];
              return BinCard(
                bin: bin,
                onTap: widget.onBinSelect,
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
