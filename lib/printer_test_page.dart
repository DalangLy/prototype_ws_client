import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype_ws_client/models/print_template_model.dart';
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
        setState((){
          _status += message+'\n';
        });
      },
      onError: (e){
        print('Erorr');
      },
      onDone: (){
        print('On Done');
      },
      cancelOnError: true,
    ).onDone(() {
        //on server shutdown
        Navigator.of(context).pop();
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
  final GlobalKey<FormState> _printerNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _jsonFormKey = GlobalKey<FormState>();
  String _message = '';
  String _printerName = '';
  String _status = '';
  String _jsonString = 'hello';

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
                          alignLabelWithHint: true,
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please input some message';
                          }
                          return null;
                        },
                        onSaved: (value){
                          if(value == null) return;
                          _message = value;
                        },
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
                              final FormState? form = _messageFormKey.currentState;
                              if(form == null) return;
                              if(!form.validate()) return;

                              form.save();

                              widget.channel.sink.add(json.encode({
                                'requestType': 'SendToServer',
                                'message': _message,
                              }));

                            },
                            child: const Text('Send to server'),
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
                              final FormState? form = _messageFormKey.currentState;
                              if(form == null) return;
                              if(!form.validate()) return;

                              form.save();

                              widget.channel.sink.add(json.encode({
                                'requestType': 'SendToEveryone',
                                'message': _message,
                              }));
                            },
                            child: const Text('Send to everyone'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_status),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.transparent,),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: _printerNameFormKey,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Printer Name'),
                            ),
                            initialValue: 'Microsoft Print to PDF',
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please input printer name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value == null) return;
                              _printerName = value;
                            },
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.transparent,),
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: (){

                            widget.channel.sink.add(json.encode({
                              'requestType': 'RequestPrintersList'
                            }));

                          },
                          child: const Text('Request Printer Name'),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.transparent,),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: _jsonFormKey,
                          child: SizedBox(
                            child: TextFormField(
                              minLines: 3,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Json String'),
                                alignLabelWithHint: true,
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please input some message';
                                }
                                return null;
                              },
                              initialValue: _jsonString,
                              onSaved: (value){
                                if(value == null) return;
                                _jsonString = value;
                              },
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.transparent,),
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: (){

                            final FormState? form = _jsonFormKey.currentState;
                            if(form == null) return;

                            form.reset();

                          },
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.transparent,),
                  SizedBox(
                    height: 58,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: (){
                                final FormState? form = _printerNameFormKey.currentState;
                                if(form == null) return;
                                if(!form.validate()) return;

                                form.save();


                                final FormState? form1 = _jsonFormKey.currentState;
                                if(form1 == null) return;
                                if(!form1.validate()) return;
                                form1.save();


                                //PrintTemplateModel jj = PrintTemplateModel.fromJson('{ "requestType": "print", "printMeta": { "printerName": "Microsoft Print to PDF", "printMethod": "printAndCut", "printTemplate": { "printTemplateLayout": { "rows": [ { "row": { "rowBorderTop": 2, "rowBorderRight": 2, "rowBorderBottom": 2, "rowBorderLeft": 2, "rowBackground": "red", "columns": [ { "column": { "content": "Row 1 Col 1", "rowSpan": 2 } }, { "column": { "content": "Row 1 Col 2", "columnWidth": 200, "columnBorderTop": 2, "columnBorderRight": 2, "columnBorderBottom": 2, "columnBorderLeft": 2 } } ] } }, { "row": { "columns": [ { "column": { "content": "Row 2 Col 2" } } ] } } ] } } } }');
                                //String jsonString = '{ "requestType": "print", "printMeta": { "printerName": "Microsoft Print to PDF", "printMethod": "printAndCut", "printTemplateLayout": { "paddingTop": 10 } } }';
                                widget.channel.sink.add(_jsonString);
                              },
                              child: const Text('Print'),
                            ),
                          ),
                          const VerticalDivider(color: Colors.transparent,),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: (){
                                final FormState? form = _printerNameFormKey.currentState;
                                if(form == null) return;
                                if(!form.validate()) return;

                                form.save();

                                // widget.channel.sink.add(json.encode({
                                //   'code': 'Print',
                                //   'data': json.encode({
                                //     'printerName': _printerName,
                                //     'printMethod': 'CutOnly',
                                //     'Base64Image': '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',
                                //   }),
                                // }));
                              },
                              child: const Text('Cut'),
                            ),
                          ),
                          const VerticalDivider(color: Colors.transparent,),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: (){
                                final FormState? form = _printerNameFormKey.currentState;
                                if(form == null) return;
                                if(!form.validate()) return;

                                form.save();

                                // widget.channel.sink.add(json.encode({
                                //   'code': 'Print',
                                //   'data': json.encode({
                                //     'printerName': _printerName,
                                //     'printMethod': 'OpenCashDrawer',
                                //     'Base64Image': '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',
                                //   }),
                                // }));
                              },
                              child: const Text('Kick Cash Drawer'),
                            ),
                          ),
                          const VerticalDivider(color: Colors.transparent,),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: (){
                                final FormState? form = _printerNameFormKey.currentState;
                                if(form == null) return;
                                if(!form.validate()) return;

                                form.save();

                                // widget.channel.sink.add(json.encode({
                                //   'code': 'Print',
                                //   'data': json.encode({
                                //     'printerName': _printerName,
                                //     'printMethod': 'PrintAndKickCashDrawer',
                                //     'Base64Image': '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',
                                //   }),
                                // }));
                              },
                              child: const Text('Print and Kick Cash Drawer'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
