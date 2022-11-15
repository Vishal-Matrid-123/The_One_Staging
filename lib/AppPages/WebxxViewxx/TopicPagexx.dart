import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'WebController.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key? key, required this.paymentUrl}) : super(key: key);
  final String paymentUrl;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount;
  bool isLoading = true;
  bool _willGo = true;

  Future<WebViewController>? _webViewControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _webViewControllerFuture = _controller.future;
    // _controller.
    // _webViewControllerFuture.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    } else {
      // WebView.platform = WKWebVIEW;
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
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
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: new AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 18.w,
            centerTitle: true,
            leading: NavigationControls(_controller.future),
            actions: [
              FutureBuilder<WebViewController>(
                future: _webViewControllerFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<WebViewController> snapshot) {
                  final bool webViewReady =
                      snapshot.connectionState == ConnectionState.done;
                  final WebViewController? controller = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 32,
                          child: IconButton(
                            icon: const Icon(Icons.replay, color: Colors.white),
                            onPressed: !webViewReady
                                ? null
                                : () {
                                    controller!.reload();
                                  },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
            title: GestureDetector(
              onTap: () {
                context.loaderOverlay.hide();
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
          body: Platform.isIOS
              ? Container(
                  width: 100.w,
                  height: 100.h,
                  child: KeyboardActions(
                    tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
                    config: KeyboardActionsConfig(
                      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                      keyboardBarColor: Colors.grey[200],
                      nextFocus: true,
                      actions: [],
                    ),
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      child: Stack(
                        children: [
                          FutureBuilder<WebViewController>(
                            future: _webViewControllerFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<WebViewController> snapshot) {
                              final bool webViewReady =
                                  snapshot.connectionState ==
                                      ConnectionState.done;
                              final WebViewController? controller =
                                  snapshot.data;

                              return WillPopScope(
                                onWillPop: !webViewReady
                                    ? null
                                    : () async {
                                        if (await controller!.canGoBack()) {
                                          controller.goBack();
                                          return false;
                                        } else {
                                          Navigator.pop(context);
                                          // Scaffold.of(context).showSnackBar(
                                          //   const SnackBar(
                                          //       content: Text("No back history item")),
                                          // );
                                          return true;
                                        }
                                      },
                                child: Container(
                                  width: 100.w,
                                  height: 100.h,
                                  child: Scaffold(
                                    resizeToAvoidBottomInset: false,
                                    body: WebView(
                                      gestureRecognizers: Set()
                                        ..add(
                                          Factory<
                                              VerticalDragGestureRecognizer>(
                                            () =>
                                                VerticalDragGestureRecognizer(),
                                          ), // or null
                                        ),
                                      initialUrl:
                                          Uri.encodeFull(widget.paymentUrl),
                                      // userAgent:
                                      //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0",
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebViewCreated: (WebViewController
                                          webViewController) {
                                        _controller.complete(webViewController);
                                      },
                                      onProgress: (int progress) {
                                        setState(() {
                                          isLoading = true;
                                          progressCount = progress;
                                        });
                                      },
                                      javascriptChannels: <JavascriptChannel>{
                                        _toasterJavascriptChannel(context),
                                      },
                                      navigationDelegate:
                                          (NavigationRequest request) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (request.url.contains(
                                            'customercare@theone.com')) {
                                          ApiCalls.launchUrl(request.url)
                                              .then((value) => setState(() {
                                                    isLoading = false;
                                                    controller!.reload();
                                                  }));
                                          return NavigationDecision.prevent;
                                        }
                                        if (request.url.startsWith(
                                            'https://www.youtube.com/')) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          controller!.reload();

                                          print(
                                              'blocking navigation to $request}');
                                          return NavigationDecision.prevent;
                                        }

                                        if (request.url
                                            .contains('GetProductModelById')) {
                                          var url = request.url;
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                            return NewProductDetails(
                                                productId:
                                                    url.split('id=')[0],
                                                screenName: 'Topic Screen');
                                          })).then((value) => setState(() {
                                                isLoading = false;
                                                controller!.reload();
                                              }));
                                          return NavigationDecision.prevent;
                                        }

                                        if (request.url
                                            .contains('GetCategoryPage')) {
                                          Navigator.pushAndRemoveUntil(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage(
                                                            pageIndex: 1),
                                                  ),
                                                  (route) => false)
                                              .then((value) => setState(() {
                                                    controller!.reload();

                                                    isLoading = false;
                                                  }));
                                          return NavigationDecision.prevent;
                                        }

                                        if (request.url.contains(
                                            'http://theone.createsend.com/')) {
                                          setState(() {
                                            isLoading = false;
                                            controller!.reload();
                                          });
                                          return NavigationDecision.navigate;
                                        }

                                        print(
                                            'allowing navigation to $request');
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
                                          context.loaderOverlay.hide();
                                          _willGo = true;
                                          isLoading = false;
                                        });
                                      },
                                      gestureNavigationEnabled: true,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          isLoading
                              ? Visibility(
                                  visible: isLoading,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SpinKitRipple(
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
                              : Stack(),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 100.w,
                  height: 100.h,
                  child: Stack(
                    children: [
                      FutureBuilder<WebViewController>(
                        future: _webViewControllerFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<WebViewController> snapshot) {
                          final bool webViewReady =
                              snapshot.connectionState == ConnectionState.done;
                          final WebViewController? controller = snapshot.data;

                          return WillPopScope(
                            onWillPop: !webViewReady
                                ? null
                                : () async {
                                    if (await controller!.canGoBack()) {
                                      controller.goBack();
                                      return false;
                                    } else {
                                      Navigator.pop(context);
                                      // Scaffold.of(context).showSnackBar(
                                      //   const SnackBar(
                                      //       content: Text("No back history item")),
                                      // );
                                      return true;
                                    }
                                  },
                            child: Container(
                              width: 100.w,
                              height: 100.h,
                              child: Scaffold(
                                resizeToAvoidBottomInset: false,
                                body: Stack(
                                  children: [
                                    WebView(
                                      gestureRecognizers: Set()
                                        ..add(
                                          Factory<
                                              VerticalDragGestureRecognizer>(
                                            () =>
                                                VerticalDragGestureRecognizer(),
                                          ), // or null
                                        ),
                                      initialUrl:
                                          Uri.encodeFull(widget.paymentUrl),
                                      // userAgent:
                                      //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0",
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebViewCreated: (WebViewController
                                          webViewController) {
                                        _controller.complete(webViewController);
                                      },
                                      onProgress: (int progress) {
                                        setState(() {
                                          isLoading = true;
                                          progressCount = progress;
                                        });
                                      },
                                      javascriptChannels: <JavascriptChannel>{
                                        _toasterJavascriptChannel(context),
                                      },
                                      navigationDelegate:
                                          (NavigationRequest request) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (request.url.contains(
                                            'customercare@theone.com')) {
                                          ApiCalls.launchUrl(request.url)
                                              .then((value) => setState(() {
                                                    isLoading = false;
                                                    controller!.reload();
                                                  }));
                                          return NavigationDecision.prevent;
                                        }
                                        if (request.url.startsWith(
                                            'https://www.youtube.com/')) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          controller!.reload();

                                          print(
                                              'blocking navigation to $request}');
                                          return NavigationDecision.prevent;
                                        }

                                        if (request.url
                                            .contains('GetProductModelById')) {
                                          var url = request.url;
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                            return NewProductDetails(
                                                productId:
                                                    url.split('id=')[0],
                                                screenName: 'Topic Screen');
                                          })).then((value) => setState(() {
                                                isLoading = false;
                                                controller!.reload();
                                              }));
                                          return NavigationDecision.prevent;
                                        }

                                        if (request.url
                                            .contains('GetCategoryPage')) {
                                          Navigator.pushAndRemoveUntil(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage(
                                                            pageIndex: 1),
                                                  ),
                                                  (route) => false)
                                              .then((value) => setState(() {
                                                    controller!.reload();

                                                    isLoading = false;
                                                  }));
                                          return NavigationDecision.prevent;
                                        }

                                        if (request.url.contains(
                                            'http://theone.createsend.com/')) {
                                          setState(() {
                                            isLoading = false;
                                            controller!.reload();
                                          });
                                          return NavigationDecision.navigate;
                                        }

                                        print(
                                            'allowing navigation to $request');
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
                                          context.loaderOverlay.hide();
                                          _willGo = true;
                                          isLoading = false;
                                        });
                                      },
                                      gestureNavigationEnabled: true,
                                      zoomEnabled: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Visibility(
                        visible: isLoading,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SpinKitRipple(
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
          // Scaffold.of(context).showSnackBar(
          //   SnackBar(content: Text(message.message)),
          // );
        });
  }
}
