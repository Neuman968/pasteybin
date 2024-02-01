import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/main.dart';
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewBinButton extends StatelessWidget {
  const NewBinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BinButton(
        text: 'New Bin',
        onPressed: () {
          _addNewBin(GoRouter.of(context));
        });
  }

  Future<void> _addNewBin(GoRouter router) async {
    final host = await API_HOST;
    final response = await http.post(Uri.parse('$HTTP_PROTOCOL://$host/bin'));

    if (response.statusCode == 200) {
      final dynamic jsonBin = json.decode(response.body);
      final Bin bin = Bin.fromJson(jsonBin);
      router.go('/bin/${bin.id}');
      router.push('/bin/${bin.id}');
    }
  }
}
