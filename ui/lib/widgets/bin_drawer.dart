import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/model/bin.dart';
import 'package:ui/screens/main_screen.dart';
import 'package:ui/widgets/bin_card.dart';

class BinDrawer extends StatelessWidget {
  const BinDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: CurrentBinList(
              onBinSelect: (bin) {
                Navigator.pop(context);
                GoRouter.of(context).go('/bin/${bin.id}');
                GoRouter.of(context).push('/bin/${bin.id}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
