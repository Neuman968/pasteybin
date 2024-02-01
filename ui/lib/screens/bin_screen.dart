import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ui/main.dart';
import 'package:ui/model/bin.dart';
import 'package:ui/widgets/bin_drawer.dart';
import 'package:ui/widgets/content_text_field.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class BinScreen extends StatefulWidget {
  const BinScreen({super.key, required this.binId});

  final String binId;

  @override
  _BinScreenState createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen> {
  Bin? _bin;

  late WebSocketChannel _channel;

  String _message = 'No data received';

  final TextEditingController _controller = TextEditingController(text: '');

  final TextEditingController _titleController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    _getBin().then((updatedBin) {
      setState(() {
        _bin = updatedBin;
        _titleController.text = updatedBin.title;
      });
    });

    _getWebSocketChannel().then((wschannel) {
      setState(() {
        _channel = wschannel;
      });

      wschannel.stream.listen((data) {
        setState(() {
          _message = data;
          TextSelection previousSelection = _controller.selection;
          _controller.text = data;
          _controller.selection = previousSelection;
        });
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const BinDrawer(),
      appBar: AppBar(
        title: const Text('Edit Bin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: _bin != null
                  ? Focus(
                      onFocusChange: (focused) {
                        if (!focused) {
                          _updateBinTitle();
                        }
                      },
                      child: ContentTextField(
                          maxLines: 1,
                          onChanged: (changedTitle) {},
                          controller: _titleController,
                          content: _bin!.title),
                    )
                  : const CircularProgressIndicator(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ContentTextField(
                  content: _message,
                  onChanged: _updateContent,
                  controller: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateContent(String updatedContent) {
    _channel.sink.add(updatedContent);
  }

  Future<WebSocketChannel> _getWebSocketChannel() async {
    final host = await API_HOST;
    return WebSocketChannel.connect(
        Uri.parse('$WS_PROTOCOL://$host/bin/${widget.binId}/ws'));
  }

  Future<Bin> _getBin() async {
    final host = await API_HOST;
    final response =
        await http.get(Uri.parse('$HTTP_PROTOCOL://$host/bin/${widget.binId}'));
    if (response.statusCode == 200) {
      return Bin.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load bin');
  }

  Future<void> _updateBinTitle() async {
    final host = await API_HOST;
    final response = await http.put(
      Uri.parse('$HTTP_PROTOCOL://$host/bin/${widget.binId}/title'),
      body: _titleController.text,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update bin title');
    }
  }
}
