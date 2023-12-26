import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinSelection extends StatefulWidget {
  const BinSelection({super.key, required this.binId});

  final String binId;

  @override
  _BinSelectionState createState() => _BinSelectionState();
}

class _BinSelectionState extends State<BinSelection> {

  late WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:8080/bin/${widget.binId}/ws'));
  String message = 'No data received';

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
            Text('Message from WebSocket:'),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      setState(() {
        message = data;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}



// import 'package:flutter/material.dart';
// import 'package:ui/widgets/content_text_field.dart';

// class BinScreen extends StatelessWidget {
//   const BinScreen({super.key, required this.binId});

//   final String binId;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Select a note')),
//       body: GridView(
//         padding: const EdgeInsets.all(24),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 3 / 2,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20,
//         ),
//         children: [
//           const ContentTextField(),
//           // Scrollabl
//           ListView.builder(
//               itemCount: 2,
//               itemBuilder: (context, idx) {
//                 return Card(
//                   child: Text('Title $idx'),
//                 );
//                 //
//                 // return const Text('Item idx', style: TextStyle(color: Colors.white),);
//               })
//           // ElevatedButton(onPressed: () {}, child: const ContentTextField())
//         ],
//       ),
//     );
//   }
// }
