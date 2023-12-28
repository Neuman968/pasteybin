import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/widgets/current_bin_list.dart';
import 'package:ui/widgets/new_bin_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: NewBinButton(),
          ),
        ],
      ),
    );
  }
}
