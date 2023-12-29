import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/main.dart';
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewBinButton extends StatelessWidget {
  const NewBinButton({super.key});

  Future<void> addNewBin(GoRouter router) async {
    final response = await http.post(Uri.parse('$HTTP_PROTOCOL://$API_HOST/bin'));

    if (response.statusCode == 200) {
      final dynamic jsonBin = json.decode(response.body);
      final Bin bin = Bin.fromJson(jsonBin);
      router.go('/bin/${bin.id}');
      router.push('/bin/${bin.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BinButton(text: 'New Bin', onPressed: () { addNewBin(GoRouter.of(context)); });
  }
}