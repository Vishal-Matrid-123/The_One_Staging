import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:untitled2/AppPages/PaymentMethods/payment_methods.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    Key? key,
    required String baseUrl,
    required String storeId,
    required String customerId,
    required String apiToken,
    required String paymentMethod,
    required bool isRepayment,
  })  : _baseUrl = baseUrl,
        _storeId = storeId,
        _apiToken = apiToken,
        _customerId = customerId,
        _paymentMethod = paymentMethod,
        _isRepayment = isRepayment,
        super(key: key);
  final String _baseUrl, _storeId, _customerId, _apiToken, _paymentMethod;
  final bool _isRepayment;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with WidgetsBindingObserver {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount;
  bool isLoading = true;
  bool failCaseLoading = false;
  bool _willGo = true;

  var _opacity = 1.0;
  String baseUrl = "";
  late WebViewController _webController;

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
    WidgetsBinding.instance.addObserver(this);
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
                    initialUrl: widget._isRepayment == true
                        ? widget._baseUrl +
                        "CustomerId=${widget._customerId}&apiToken=${widget._apiToken}&$kStoreIdVar=${widget._storeId}"
                        : widget._baseUrl +
                        "apiToken=${widget._apiToken}&CustomerId=${widget._customerId}&PaymentMethod=${widget._paymentMethod}&$kStoreIdVar=${widget._storeId}",
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                      _webController = webViewController;
                    },
                    onProgress: (int progress) {
                      setState(() {
                        isLoading = true;
                        progressCount = progress;
                      });
                    },
                    javascriptChannels: <JavascriptChannel>{},
                    navigationDelegate: (NavigationRequest request) {
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
                      _webController.currentUrl().then((value) {
                        log('web controller current url - $value');
                        if (value!.contains(
                            "theoneqatar.com/AppCustomerSecondVer/CreateCustomerOrder?")) {
                          setState(() {
                            failCaseLoading = true;
                          });
                          getPaymentWebview().then((value) {
                            setState(() {
                              _willGo = true;
                              isLoading = false;
                              failCaseLoading = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentMethodxx(
                                      isPaymentFail: true,
                                      failWarning: value)),
                            );
                          });
                        }
                        // else if (value.contains(
                        //     "theone.com/AppCustomerSecondVer/CreateCustomerOrder?") ||
                        //     value.contains(
                        //         "theonebahrain.com/AppCustomerSecondVer/CreateCustomerOrder?") ||
                        //     value.contains(
                        //         "theonekuwait.com/AppCustomerSecondVer/CreateCustomerOrder?")) {
                        //   setState(() {
                        //     failCaseLoading = true;
                        //   });
                        //   getPaymentWebview().then((value) {
                        //     setState(() {
                        //       _willGo = true;
                        //       isLoading = false;
                        //       failCaseLoading = false;
                        //     });
                        //     Navigator.pushAndRemoveUntil(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ShippingMethod(isPaymentFail: true, failWarning: value,)),
                        //             (route) => route.isFirst);
                        //   });
                        // }
                        else {
                          setState(() {
                            _willGo = true;
                            isLoading = false;
                            failCaseLoading = false;
                          });
                        }
                      });
                    },
                    gestureNavigationEnabled: true,
                  ),
                ),
                isLoading
                    ? failCaseLoading
                    ? Container(
                  height: 100.h,
                  width: 100.w,
                  color: Colors.white,
                  child: Center(
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
                    ),
                  ),
                )
                    : Align(
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

  Future<String> getPaymentWebview() async {
    final uri = Uri.parse(widget._baseUrl +
        "apiToken=${widget._apiToken}&CustomerId=${widget._customerId}&PaymentMethod=${widget._paymentMethod}&$kStoreIdVar=${widget._storeId}");
    log("getPaymentWebview Url :- ${uri.toString()}");

    var response = await http.get(uri, headers: {
      'Cookie': '.Nop.Customer=${ConstantsVar.prefs.getString(kguidKey)}',
    });
    if (response.body.contains('status') && response.statusCode == 200) {
      if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
          kstatusFailed) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['Message'].toString(),
            toastLength: Toast.LENGTH_LONG);
        return jsonDecode(response.body)['Message'].toString();
      } else {
        return "";
      }
    } else {
      Fluttertoast.showToast(
          msg: '$kerrorString\nStatus code${response.statusCode}');
      return kerrorString;
    }
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
