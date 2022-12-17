import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/ApiCalls/ApiCalls.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    Key? key,
    required String baseUrl,
    required String storeId,
    required String customerId,
    required String apiToken,
  })  : _baseUrl = baseUrl,
        _storeId = storeId,
        _apiToken = apiToken,
        _customerId = customerId,
        super(key: key);
  final String _baseUrl, _storeId, _customerId, _apiToken;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with WidgetsBindingObserver {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount;
  bool isLoading = true;
  bool _willGo = true;

  var _opacity = 1.0;
  String baseUrl = "";

  Future<void> secureScreen() async {
    await ApiCalls.getSelectedStore().then(
      (value) =>
          setState(() => baseUrl = value.replaceAll("/apisSecondVer", "")),
    );
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
    // await FirebaseAnalytics.instance
    //     .logScreenView(screenName: 'Payment Screen');
    // await FirebaseAnalytics.instance.logP
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance?.addObserver(this);
    secureScreen();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        setState(() {
          _opacity = 0.0;
        });
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _opacity = 1.0;
        });
        break;
      case AppLifecycleState.paused:
        setState(() {
          _opacity = 0.0;
        });
        break;
      case AppLifecycleState.detached:
        setState(() {
          _opacity = 0.0;
        });
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      disposeSecureScreen();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _willGoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => const MyOrders(
                    isFromWeb: true,
                  )),
          (route) => false);
      setState(() {
        _willGo = true;
      });
      return _willGo;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          setState(() {
            currentFocus.unfocus();
          });
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: WillPopScope(
          onWillPop: _willGo ? _willGoBack : () async => false,
          child: Scaffold(
            appBar: AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MyOrders(
                                      isFromWeb: true,
                                    )),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MyOrders(
                                      isFromWeb: true,
                                    )),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context,
                      CupertinoPageRoute(builder: (context) {
                    return MyApp();
                  }), (route) => false);
                },
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Opacity(
                  opacity: _opacity,
                  child: WebView(
                    onWebResourceError: (error) => log(error.description),
                    initialUrl: widget._baseUrl +
                        "apiToken=${widget._apiToken}&CustomerId=${widget._customerId}&PaymentMethod=Payments.CyberSource&Storeid=${widget._storeId}",
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      setState(() {
                        isLoading = true;
                        progressCount = progress;
                      });
                    },
                    javascriptChannels: <JavascriptChannel>{},
                    navigationDelegate: (NavigationRequest request) {
                      // NavigationDecision.

                      // Navigation

                      if (request.url.contains(
                          "https://secureacceptance.cybersource.com/billing")) {
                        // FacebookAppEvents().logPurchase(
                        //     amount: 0.0, currency: CurrencyCode.AED.name);
                        return NavigationDecision.navigate;
                      }
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        print('blocking navigation to $request}');
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      setState(() {
                        _willGo = false;
                        isLoading = true;
                      });

                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                      setState(() {
                        _willGo = true;
                        isLoading = false;
                      });
                    },
                    gestureNavigationEnabled: true,
                  ),
                ),
                isLoading
                    ? Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const SpinKitRipple(
                              color: Colors.red,
                              size: 90,
                            ),
                            Text('Loading Please Wait!.........' +
                                progressCount.toString() +
                                '%'),
                          ],
                        ))
                    : Stack(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          // Scaffold.of(context)(
          //   SnackBar(content: Text(message.message)),
          // );
        });
  }

  Future<void> disposeSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
