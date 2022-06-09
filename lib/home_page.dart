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

  final port = 1100;
  late Stream<NetworkAddress> stream;
  final List<NetworkAddress> ff = [];

  @override
  initState(){
    super.initState();

    _scanNetwork();

  }

  @override
  void didChangeDependencies() {
    // Provider.of<>(context)
    super.didChangeDependencies();

    print('did change dependency');
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('hello owrld');
  }


  void _scanNetwork(){
    ff.clear();
    try{
      stream = NetworkAnalyzer.discover2(
        '192.168.0', port,
      );

      int found = 0;
      stream.listen((NetworkAddress addr) {
        if (addr.exists) {
          found++;
          ff.add(addr);
          if(ff.isNotEmpty){
            _selectedNetworkAddress = ff[0];
          }
          setState(() {});
          print('Found device: ${addr.ip}:$port');
        }
      },onError: (ex){
        print('on error');
      },
        onDone: (){
          print('On Done');
        },
        cancelOnError: false,
      ).onDone(() => print('Finish. Found $found device(s)'));
    }catch(e){
      print('Error Dalang');
    }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Servers List', style: Theme.of(context).textTheme.headline6,),
                      IconButton(onPressed: (){
                        _scanNetwork();
                      }, icon: const Icon(Icons.refresh)),
                    ],
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: ff.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            selectedColor: Colors.white,
                            selectedTileColor: Colors.blue,
                            selected: index == _selectIndex,
                            leading: const SizedBox(
                              height: double.infinity,
                              child: Icon(Icons.print),
                            ),
                            title: const Text('Printing Service'),
                            subtitle: Text(ff[index].ip),
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
                  ),
                  const Divider(color: Colors.transparent,),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: (){
                        if(ff.isEmpty) return;
                        final FormState? form = _clientNameFormKey.currentState;
                        if(form == null) return;
                        if(!form.validate()) return;

                        form.save();

                        print(_selectedNetworkAddress.ip);

                        WebSocket.connect('ws://${_selectedNetworkAddress.ip}:$port?name=${_removeEmptySpace()}').then((ws) {
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
                            print('On Error 1 $ex');

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
        return AlertDialog(
          title: const Text('Failed'),
          content: const SizedBox(
            height: 60,
            width: 200,
            child: Center(
              child: Icon(Icons.cancel, color: Colors.red, size: 60,),
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
