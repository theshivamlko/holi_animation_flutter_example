import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
            /// **WebView Layer**
            _controller != null
                ? WebViewWidget(
                    controller: _controller!,
                  )
                : Container(
              color: Colors.red,
            ),

            /// **Flutter Widgets Over WebView**
           /* Positioned(
              top: 50,
              left: 20,
              child: ElevatedButton(
                onPressed: () => sendMessageToWebView("Hello from Flutter!"),
                child: Text("Send to WebView"),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
