import 'dart:async';
import 'dart:io';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  String LikkURL;

  WebPage(this.LikkURL);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  GlobalKey<FormState> myFormKey = new GlobalKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  int _value = 2;
  int _progress = 0;
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    GF().loading();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    //  print("${widget.booking_id}///${widget.amount}///${widget.InvoiceURL}");
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // here the desired height
        child: new AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios)),
          ),
          flexibleSpace: Container(
            color: AppColors.blueW2Color,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 40,
                  ),
                  new Text(
                    "appTitle".tr(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          WebView(
            // key: _key,
            initialUrl: '${widget.LikkURL}',
            javascriptMode: JavascriptMode.unrestricted,

            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              setState(() {
                _progress = progress;
              });
              print("Payment is loading (progress : $progress%)");
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
                GF().dismissLoading();
              });
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
          ),
          // isLoading
          //     ?
          // Center(
          //   child: Text(
          //     "Payment is loading (progress : $_progress%)",
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold, fontSize: 18),
          //   ),
          // )
          //     : Stack()
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
