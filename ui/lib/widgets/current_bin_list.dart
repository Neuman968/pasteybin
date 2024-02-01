import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/main.dart';
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_card.dart';

class CurrentBinList extends StatefulWidget {
  const CurrentBinList({super.key, required this.onBinSelect});

  final Function(Bin) onBinSelect;

  @override
  _CurrentBinListState createState() => _CurrentBinListState();
}

class _CurrentBinListState extends State<CurrentBinList> {
  List<Bin>? bins;

  @override
  void initState() {
    super.initState();
    _fetchBins();
  }

  @override
  Widget build(BuildContext context) {
    if (bins == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return bins!.isNotEmpty
        ? ListView.builder(
            itemCount: bins!.length,
            itemBuilder: (context, index) {
              final bin = bins![index];
              return BinCard(
                bin: bin,
                onTap: widget.onBinSelect,
              );
            },
          )
        : Center(
            child: Text(
              'Add a Bin to get started!',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
          );
  }

  Future<void> _fetchBins() async {
    final host = await API_HOST;
    final response = await http.get(Uri.parse('$HTTP_PROTOCOL://$host/bin'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonBins = json.decode(response.body);
      setState(() {
        bins = jsonBins.map((jsonBin) => Bin.fromJson(jsonBin)).toList();
      });
    } else {
      throw Exception('Failed to load bins');
    }
  }
}
