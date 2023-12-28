import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_button.dart';
import 'package:http/http.dart' as http;
import 'package:ui/widgets/current_bin_list.dart';

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

