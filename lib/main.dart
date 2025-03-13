import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    _controller = WebViewController();
    _controller!
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => debugPrint("WebView Loaded"),
      ))
      ..addJavaScriptChannel(
        "FlutterWebViewChannel",
        onMessageReceived: (message) {
          debugPrint("Received from WebView: ${message.message}");
        },
      );
    _controller!.loadFlutterAsset('assets/index.html').whenComplete(() {
      setState(() {

      });
    },);
  }

  void sendMessageToWebView(String message) {
    _controller!.runJavaScript("receiveMessageFromFlutter('$message');");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
             _controller != null
                ? WebViewWidget(
                    controller: _controller!,
                  )
                : Container(
              color: Colors.red,
            ),

          ],
        ),
      ),
    );
  }
}
