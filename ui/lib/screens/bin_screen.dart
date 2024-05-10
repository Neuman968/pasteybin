import 'dart:async';
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

  // Timer function for sending data to the server.
  late Timer _timer;

  // The Websocket message.
  var _message = '';

  /// true if data has been recieved from the web socket. Prevents data from being overwritten when initialized.
  var _dataRecieved = false;

  /// Controller for the content of the bin
  final TextEditingController _contentController =
      TextEditingController(text: '');

  /// Controller for the title of the bin
  final TextEditingController _titleController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    /// Initialize timer with function to update bin content if bin was initialized and if the content has changed.
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_dataRecieved && _message != _contentController.text) {
        _channel.sink.add(_contentController.text);
      }
    });

    /// Retrieves the bin title.
    _getBin().then((updatedBin) {
      setState(() {
        _bin = updatedBin;
        _titleController.text = updatedBin.title;
      });
    });

    /// Initialize websocket channel.
    _getWebSocketChannel().then((wschannel) {
      setState(() {
        _channel = wschannel;
      });

      /// Listen to websocket events.
      wschannel.stream.listen((data) {
        setState(() {
          _message = data;
          TextSelection previousSelection = _contentController.selection;
          _contentController.text = data;
          _contentController.selection = previousSelection;
        });
        _dataRecieved = true;
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _timer.cancel();
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
                  content: !_dataRecieved ? 'No Message Recieved' : _message,
                  onChanged: (val) {},
                  controller: _contentController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the Websocket Channel.
  Future<WebSocketChannel> _getWebSocketChannel() async {
    final host = await API_HOST;
    return WebSocketChannel.connect(
        Uri.parse('$WS_PROTOCOL://$host/bin/${widget.binId}/ws'));
  }

  /// Retrieves the current bin from the server.
  Future<Bin> _getBin() async {
    final host = await API_HOST;
    final response =
        await http.get(Uri.parse('$HTTP_PROTOCOL://$host/bin/${widget.binId}'));
    if (response.statusCode == 200) {
      return Bin.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load bin');
  }

  /// Updates the title of the bin based on the state of _titleController
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
