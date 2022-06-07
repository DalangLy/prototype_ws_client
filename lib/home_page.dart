import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:prototype_ws_client/printer_test_page.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<FormState> _clientNameFormKey = GlobalKey<FormState>();

  final port = 8000;
  late final Stream<NetworkAddress> stream = NetworkAnalyzer.discover2(
    '192.168.0', port,
  );

  final List<NetworkAddress> ff = [];

  @override
  initState(){
    super.initState();


    int found = 0;
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        found++;
        ff.add(addr);
        setState(() {});
        print('Found device: ${addr.ip}:$port');
      }
    }).onDone(() => print('Finish. Found $found device(s)'));
  }

  int _selectIndex = 0;
  late NetworkAddress _selectedNetworkAddress = ff[_selectIndex];

  String _clientName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: _clientNameFormKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Name'),
                      ),
                      initialValue: 'ClientName1',
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please Input Name';
                        }
                        return null;
                      },
                      onSaved: (value){
                        if(value == null) return;
                        _clientName = value;
                      },
                    ),
                  ),
                  const Divider(color: Colors.transparent,),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: ff.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          selectedColor: Colors.white,
                          selectedTileColor: Colors.blue,
                          selected: index == _selectIndex,
                          title: Text(ff[index].ip),
                          onTap: (){
                            setState((){
                              _selectIndex = index;
                              _selectedNetworkAddress = ff[index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(color: Colors.transparent,),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: (){
                        final FormState? _form = _clientNameFormKey.currentState;
                        if(_form == null) return;
                        if(!_form.validate()) return;

                        _form.save();

                        WebSocket.connect('ws://${_selectedNetworkAddress.ip}:8000?name=${_removeEmptySpace()}').then((ws) {
                            print('Connect Success');
                            var channel = IOWebSocketChannel(ws);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrinterTestPage(channel: channel,),));

                          // channel.stream.listen(
                          //   (message) {
                          //     //channel.sink.add('received!');
                          //     //channel.sink.close(status.goingAway);
                          //   },
                          //   onError: (e){
                          //     print('Erorr');
                          //   },
                          //   onDone: (){
                          //     print('On Done');
                          //   },
                          //   cancelOnError: true,
                          // ).onDone(() {
                          //     print('on Done two');
                          //   }
                          // );


                          },
                          onError: (ex){
                            print('On Error');
                            _showFailedDialog();
                          },
                        );
                      },
                      child: const Text('Connect'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _removeEmptySpace(){
    return _clientName.replaceAll(RegExp(r"\s+\b|\b\s"), "");
  }

  Future<void> _showFailedDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Failed'),
          content: SizedBox(
            height: 60,
            width: 200,
            child: Center(
              child: Icon(Icons.cancel, color: Colors.red, size: 60,),
            ),
          ),
        );
      },
    );
  }
}
