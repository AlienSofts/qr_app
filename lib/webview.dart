import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

class GenerateWebView extends StatefulWidget {
  final String jsonData;
  GenerateWebView(this.jsonData, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new GenerateWebViewState();
  }
}

class GenerateWebViewState extends State<GenerateWebView> {
  @override
  void initState() {
    super.initState();
    print(widget.jsonData);
  }

  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: widget.jsonData);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Web View'),
      ),
      body: WebViewWidget(
          controller: WebViewController()
            ..enableZoom(false)
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
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
                      msg: "Start $url",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(widget.jsonData.toString()))),
    );
  }
}
