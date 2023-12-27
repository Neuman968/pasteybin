import 'package:flutter/material.dart';
import 'package:ui/widgets/content_text_field.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinScreen extends StatefulWidget {
  const BinScreen({super.key, required this.binId});

  final String binId;

  @override
  _BinScreenState createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen> {
  late WebSocketChannel channel;

  String message = 'No data received';

  final TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContentTextField(content: message, onChanged: updateContent, controller: controller),
          ],
        ),
      ),
    );
  }

  void updateContent(String updatedContent) {
    channel.sink.add(updatedContent);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/bin/${widget.binId}/ws'));      
    });

    channel.stream.listen((data) {
      setState(() {
        message = data;
        controller.text = data;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
