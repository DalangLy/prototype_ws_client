import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class PrinterTestPage extends StatefulWidget {
  final IOWebSocketChannel channel;
  const PrinterTestPage({Key? key, required this.channel,}) : super(key: key);

  @override
  State<PrinterTestPage> createState() => _PrinterTestPageState();
}

class _PrinterTestPageState extends State<PrinterTestPage> {

  @override
  initState(){
    super.initState();

    widget.channel.stream.listen(
      (message) {
        //channel.sink.add('received!');
        //channel.sink.close(status.goingAway);
        print(message);
      },
      onError: (e){
        print('Erorr');
      },
      onDone: (){
        print('On Done');
      },
      cancelOnError: true,
    ).onDone(() {
        print('on Done two');
      }
    );
  }

  @override
  dispose(){
    _disconnectWebSocket();
    super.dispose();
  }

  void _disconnectWebSocket(){
    //widget.channel.sink.close(status.goingAway);
    widget.channel.sink.close();
  }


  final GlobalKey<FormState> _messageFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Printer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: _messageFormKey,
                    child: SizedBox(
                      height: 100,
                      child: TextFormField(
                        minLines: 3,
                        maxLines: 5,  // allow user to enter 5 line in textfield
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Message'),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.transparent,),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 58,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){

                            },
                            child: const Text('Send to everyone'),
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.transparent,),
                      Expanded(
                        child: SizedBox(
                          height: 58,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){

                            },
                            child: const Text('Send to server'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.channel.sink.add(json.encode({
                        'code': 'SendToServer',
                        'data': 'Hello Server! it me',
                      }));
                    },
                    child: const Text('Test'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
