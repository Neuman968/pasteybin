import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui/model/bin.dart';

class BinCard extends StatelessWidget {
  final Bin bin;

  BinCard({required this.bin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).go('/bin/${bin.id}');
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: ListTile(
          title: Text('Bin ${bin.id}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Last Updated: ${_formatTimestamp(bin.lastUpdatedTime)}'),
              Text('Created: ${_formatTimestamp(bin.createdTime)}'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp != null) {
      // Convert the string timestamp to DateTime
      final dateTime = DateTime.parse(timestamp);

      // Use the intl package to format the timestamp
      return DateFormat.yMd().add_jm().format(dateTime.toLocal());
    } else {
      return 'N/A';
    }
  }
}
