import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/widgets/current_bin_list.dart';
import 'package:ui/widgets/new_bin_button.dart';

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
                final route = '/bin/${bin.id}';
                GoRouter.of(context).go(route);
                GoRouter.of(context).push(route);
              },
            ),
          ),
          const NewBinButton(),
        ],
      ),
    );
  }
}
