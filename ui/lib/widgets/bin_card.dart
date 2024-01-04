import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/model/bin.dart';

class BinCard extends StatelessWidget {
  const BinCard({required this.bin, required this.onTap});

  final Bin bin;

  final Function(Bin) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () { onTap(bin); },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: ListTile(
          title: Text(bin.title),
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
