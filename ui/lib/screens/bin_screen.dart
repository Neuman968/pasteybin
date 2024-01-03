import 'package:flutter/material.dart';
import 'package:ui/main.dart';
import 'package:ui/widgets/bin_drawer.dart';
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
      drawer: const BinDrawer(),
      appBar: AppBar(
        title: Text('Bin ${widget.binId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ContentTextField(
                  content: message,
                  onChanged: updateContent,
                  controller: controller,
                ),
              ),
            ),
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

    _getWebSocketChannel().then((wschannel) {
      
      setState(() {
        channel = wschannel;
      });

      wschannel.stream.listen((data) {
        setState(() {
          message = data;
          controller.text = data;
        });
      });
    });
  }

  Future<WebSocketChannel> _getWebSocketChannel() async {
    final host = await API_HOST;
    return WebSocketChannel.connect(
        Uri.parse('$WS_PROTOCOL://$host/bin/${widget.binId}/ws'));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
