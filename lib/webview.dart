import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GenerateWebView extends StatefulWidget {
  
  final String jsonData;
  GenerateWebView(this.jsonData, {Key? key}): super(key: key);
  @override
  State<StatefulWidget> createState() { return new GenerateWebViewState();}
}

class GenerateWebViewState extends State<GenerateWebView> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.jsonData);
    return WebView(
      initialUrl: widget.jsonData,
      onProgress: (int progress) {
          print('Loading : $progress%)');
          Fluttertoast.showToast(
          msg: 'Loading : $progress%)',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
        },
      onPageStarted: (String url) {
          Fluttertoast.showToast(
          msg: "Start Loading",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
        },
    );
  }
}
