import 'dart:async';
import 'dart:developer';
import 'dart:io' show Cookie, Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../MyOrders/MyOrders.dart';
import 'WebController.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key? key, required this.paymentUrl, required this.screenName})
      : super(key: key);
  final String paymentUrl, screenName;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final cookieManager = WebviewCookieManager();

  // final String _url = 'https://youtube.com';
  String cookieValue = '';
  final String domain = 'dev.theone.com';
  final String cookieName = '.Nop.Customer';

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount = 0;
  bool isLoading = true;
  bool _willGo = true;
  var isUserLoggedIn;
  String _userName = '', _email = '', _phoneNumber = '';

  Future<WebViewController>? _webViewControllerFuture;

  var _customerValue = '';
  late WebViewController _webController;

  void getUserLoginDetails() async {
    isUserLoggedIn = await ConstantsVar.prefs.getString('userId') ?? null;
    _phoneNumber =
        (await ConstantsVar.prefs.getString('phone') ?? '').replaceAll(' ', '');
    _email = await ConstantsVar.prefs.getString('email') ?? '';
    _userName = await ConstantsVar.prefs.getString('userName') ?? '';
    cookieValue =
        await ConstantsVar.prefs.getString('guestGUID') ?? 'No ID Pass';
    setState(() {});
    log('User Log In>>' + '$isUserLoggedIn' + ' Customer GUID>>>> $_userName');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserLoginDetails();
    _webViewControllerFuture = _controller.future;
    // _controller.
    final provider = Provider.of<NewApisProvider>(context, listen: false);
    provider.getBookingStatus() ;

    // _webViewControllerFuture.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    } else {
      // WebView.platform = WKWebVIEW;
    }
    // cookieManager.clearCookies();
    setState(() {});
  }

  void setSession(String sessionId, WebViewController webViewController) async {
    if (Platform.isIOS) {
      await webViewController
          .evaluateJavascript("document.cookie = '.Nop.Customer.$sessionId'");
    } else {
      await webViewController.evaluateJavascript(
          'document.cookie = ".Nop.Customer.$sessionId; path=/"');
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
        child: Consumer<NewApisProvider>(
          builder: (ctx, val, _) => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: new AppBar(
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              leading: NavigationControls(_controller.future, widget.screenName),
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
                              icon:
                                  const Icon(Icons.replay, color: Colors.white),
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
                              future: _controller.future,
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
                                            if (widget.screenName
                                                .toLowerCase()
                                                .contains('shipping')) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const MyOrders(
                                                            isFromWeb: true,
                                                          )),
                                                  (route) => false);
                                            } else {
                                              Navigator.pop(context);
                                            }

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
                                        initialCookies: [
                                          WebViewCookie(
                                              name: cookieName,
                                              value: cookieValue,
                                              domain: domain)
                                        ],
                                        initialUrl:
                                            Uri.encodeFull(widget.paymentUrl),
                                        // userAgent:
                                        //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0",
                                        javascriptMode:
                                            JavascriptMode.unrestricted,
                                        onWebViewCreated: (WebViewController
                                            webViewController) async {
                                          _webController = webViewController;

                                          _controller
                                              .complete(webViewController);
                                        },
                                        onProgress: (int progress) {
                                          setState(() {
                                            isLoading = true;
                                            progressCount = progress;
                                          });
                                          if (progress == 100) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                        javascriptChannels: <JavascriptChannel>{
                                          _toasterJavascriptChannel(context),
                                        },
                                        navigationDelegate:
                                            (NavigationRequest request) async {
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

                                          if (request.url.contains(
                                              'GetProductModelById')) {
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
                                          if (request.url
                                              .toLowerCase()
                                              .contains("\.com\/login")) {
                                            // print();
                                            String url = await controller!
                                                    .currentUrl() ??
                                                '';
                                            await Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(
                                                  screenKey: 'Topic Screen ',
                                                ),
                                              ),
                                            ).then((value) => value == true
                                                ? setState(() {
                                                    controller.reload();
                                                    getUserLoginDetails();
                                                    isLoading = false;
                                                  })
                                                : null);
                                            return NavigationDecision.prevent;
                                          }
                                          if (request.url
                                              .toLowerCase()
                                              .contains("\.com\/register")) {
                                            Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    const RegstrationPage(),
                                              ),
                                            ).then((value) => setState(() {
                                                  controller!.reload();

                                                  isLoading = false;
                                                }));
                                            return NavigationDecision.prevent;
                                          }

                                          print(
                                              'allowing navigation to $request');
                                          return NavigationDecision.navigate;
                                        },
                                        onPageStarted: (String url) async {
                                          setState(() {
                                            _willGo = false;
                                            isLoading = true;
                                          });

                                          print('Page started loading: $url');
                                        },
                                        onPageFinished: (String url) async {
                                          print('Page finished loading: $url');
                                          // cookieManager.clearCookies();
                                          // await cookieManager.setCookies([
                                          //   Cookie(cookieName, cookieValue)
                                          //     ..domain = domain
                                          //     ..expires = DateTime.now()
                                          //         .add(Duration(days: 365))
                                          //     ..httpOnly = true
                                          // ]);
                                          setState(() {
                                            context.loaderOverlay.hide();
                                            _willGo = true;
                                            isLoading = false;
                                            _controller.future
                                                .then((value) async {
                                              String urlPart =
                                                  await value.currentUrl() ??
                                                      '';

                                              String javaScriptString1 =
                                                  '''\$('.express.app .popup').attr('style', 'z-index: 99999;position: absolute;opacity: 0.8;display:block;color: black;background: black;padding: 17%;font-weight: 700;color: white;height:-webkit-fill-available;float: left;left:0;right:0;text-align:center;');''';
                                              String javaScriptString2 =
                                                  '''\$('.popup').html('<h1><b style="color:#ffff">You already having a booking with us.</b></h1>')''';
                                              String javaScript3 =
                                                  'document.getElementById("ui-datepicker-div").style.top=\'1410px\';';
                                              String javaScript4 = '''
                                                  document.getElementById("FullName").value="$_userName"
                                                  ''';
                                              String javaScript5 =
                                                  '''document.getElementsByClassName("timebutton text-box single-line")[1].value=\'${_phoneNumber.replaceAll("", '')}\'
                                                  ''';
                                              String javaScript6 =
                                                  'document.getElementsByClassName("timebutton text-box single-line")[2].value=\"$_email\"';

                                              String javaScript7 = '''
                                                  document.getElementById("fname").value="$_userName"
                                                  ''';
                                              String javaScript8 =
                                                  'document.getElementsByClassName("add text-box single-line")[1].value=\'${_phoneNumber.replaceAll(' ', '')}\'';
                                              String javaScript9 =
                                                  'document.getElementsByClassName("add text-box single-line")[2].value=\"$_email\"';
                                              print('THE One Way>>> ' + javaScript7);
                                              print('THE One Way>>> ' + javaScript8);
                                              print('THE One Way>>> ' + javaScript9);

                                              //
                                              if (isUserLoggedIn != null &&
                                                  urlPart
                                                      .toLowerCase()
                                                      .contains(
                                                          'theoneexpress') &&
                                                  val.isBookingAvailable ==
                                                      true) {
                                                print("Javascript>>" +
                                                    javaScript4);

                                                await _webController
                                                    .runJavascript(
                                                        javaScriptString1);
                                                await _webController
                                                    .runJavascript(
                                                        javaScriptString2);
                                                value.runJavascript(
                                                    'document.getElementById("Date").readOnly=true;');

                                                await _webController
                                                    .runJavascript(javaScript5);
                                                await _webController
                                                    .runJavascript(javaScript4);
                                                await _webController
                                                    .runJavascript(javaScript6);
                                              } else if (isUserLoggedIn !=
                                                      null &&
                                                  urlPart
                                                      .toLowerCase()
                                                      .contains(
                                                          'theoneexpress') &&
                                                  val.isBookingAvailable ==
                                                      false) {
                                                value.runJavascript(
                                                    'document.getElementsByClassName("popup")[0].remove();');
                                                value.runJavascript(
                                                    'document.getElementById("Date").readOnly=true;');
                                                
                                                value
                                                    .runJavascript(javaScript4);
                                                value
                                                    .runJavascript(javaScript5);
                                                value
                                                    .runJavascript(javaScript6);
                                              } else if (isUserLoggedIn !=
                                                      null &&
                                                  urlPart
                                                      .toLowerCase()
                                                      .contains('theoneway')) {
                                                value.runJavascript(
                                                    'document.getElementsByClassName("popup")[0].remove();');
                                              
                                                value
                                                    .runJavascript(javaScript7);
                                                value
                                                    .runJavascript(javaScript8);
                                                value
                                                    .runJavascript(javaScript9);
                                                // value
                                                //     .evaluateJavascript(javaScript5);
                                                // value
                                                //     .evaluateJavascript(javaScript6);
                                              }
                                            });
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
                                snapshot.connectionState ==
                                    ConnectionState.done;
                            final WebViewController? controller = snapshot.data;

                            return WillPopScope(
                              onWillPop: !webViewReady
                                  ? null
                                  : () async {
                                      if (await controller!.canGoBack()) {
                                        controller.goBack();
                                        return false;
                                      } else {
                                        if (widget.screenName
                                            .toLowerCase()
                                            .contains('shipping')) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const MyOrders(
                                                        isFromWeb: true,
                                                      )),
                                              (route) => false);
                                        } else {
                                          Navigator.pop(context);
                                        }

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
                                        initialCookies: [
                                          WebViewCookie(
                                              name: cookieName,
                                              value: cookieValue,
                                              domain: domain)
                                        ],
                                        initialUrl:
                                            Uri.encodeFull(widget.paymentUrl),
                                        // userAgent:
                                        //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0",
                                        javascriptMode:
                                            JavascriptMode.unrestricted,
                                        onWebViewCreated: (WebViewController
                                            webViewController) async {
                                          _webController = webViewController;

                                          _webController.loadUrl(
                                              widget.paymentUrl,
                                              headers: {
                                                'Cookie':
                                                    '.Nop.Customer=$_customerValue'
                                              });

                                          await cookieManager.setCookies([
                                            Cookie(cookieName, cookieValue)
                                              ..domain = domain
                                              ..expires = DateTime.now()
                                                  .add(Duration(days: 365))
                                              ..httpOnly = false,
                                            Cookie('.Nop.Authentication',
                                                'CfDJ8Nb9OIENgiZJj0IssP6Z09JNlHypwKEbfg_z4xuok8Wi9C2pZbknMlp3Ig_5M-yZYmoq2Uv-f3qUbi0k_Jli0RyCyrwygQ1yk8r3oKyQ8wruvo4yg84UkJkSOVuFgWweKx0xukYZ-UORP1smXRUl7jOS14p1aMgXMr7G_0i_4mCKXoK-6w7QiFwMQ6CAfgkeGH4ApnAlpRuo3UsrSKm5fWwLVNdUqB-YIepG6ezmB8kjUXwHY60KKtSIIVkGDJEFpYxiqID1E-rzCOza-gaUQyiM98bygIUxPb66jjzXUPZ0PYn30dgMU-9NyEk0VUXrjCdGuxE9KkIMEK1rHAIQQz029BJJ0lbUYqqn18l8kyca5UczBKMhe_koHbexnpG3EbkPHT3oKFTl1Dk-feoCDcyhruncnZ5InhKYFApJhdDDtmvzbG5r526r3RRWUs6cGxnJV-RzqybBBkOLvOX6xSIYZ_LVWILFE0oeLuFmcLUHTBGvwUWU7J79yDNtM2mO42ipVpeDp3fYVpx8b6XwPyAam6V-imMxDJqgqkoSe0RRYJpVDGPqZF8KQ0kK1MHjzk8C8X7_qGiUJQJKjOmnuS8')
                                              ..domain = domain
                                              ..expires = DateTime.now()
                                                  .add(Duration(days: 365))
                                              ..httpOnly = false
                                          ]);
                                          _controller
                                              .complete(webViewController);
                                        },
                                        onProgress: (int progress) {
                                          setState(() {
                                            isLoading = true;
                                            progressCount = progress;
                                          });
                                          if (progress > 50) {
                                            _controller.future
                                                .then((value) async {
                                              String urlPart =
                                                  await value.currentUrl() ??
                                                      '';

                                              if (isUserLoggedIn != null &&
                                                  (urlPart
                                                          .toLowerCase()
                                                          .contains(
                                                              'theoneway') ||
                                                      urlPart
                                                          .toLowerCase()
                                                          .contains(
                                                              'theoneexpress'))) {
                                                value
                                                    .runJavascriptReturningResult(
                                                        'document.getElementsByClassName("popup")[0].style.display=\'none\';')
                                                    .then((value) => print(
                                                        value.toString()));
                                              }
                                            });
                                          }
                                          if (progress == 100) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                        javascriptChannels: <JavascriptChannel>{
                                          _toasterJavascriptChannel(context),
                                        },
                                        navigationDelegate:
                                            (NavigationRequest request) async {
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

                                          if (request.url.contains(
                                              'GetProductModelById')) {
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
                                          if (request.url
                                              .toLowerCase()
                                              .contains("\.com\/login")) {
                                            // print();
                                            String url = await controller!
                                                    .currentUrl() ??
                                                '';
                                            await Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(
                                                  screenKey: 'Topic Screen ',
                                                ),
                                              ),
                                            ).then((value) => value == true
                                                ? setState(() {
                                                    controller.reload();
                                                    getUserLoginDetails();
                                                    isLoading = false;
                                                  })
                                                : null);
                                            return NavigationDecision.prevent;
                                          }
                                          if (request.url
                                              .toLowerCase()
                                              .contains("\.com\/register")) {
                                            Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    const RegstrationPage(),
                                              ),
                                            ).then((value) => setState(() {
                                                  controller!.reload();

                                                  isLoading = false;
                                                }));
                                            return NavigationDecision.prevent;
                                          }

                                          print(
                                              'allowing navigation to $request');
                                          return NavigationDecision.navigate;
                                        },
                                        onPageStarted: (String url) async {
                                          cookieManager.clearCookies();
                                          await cookieManager.setCookies([
                                            Cookie(cookieName, cookieValue)
                                              ..domain = domain
                                              ..expires = DateTime.now()
                                                  .add(Duration(days: 365))
                                              ..httpOnly = false,
                                          ]);
                                          setState(() {
                                            _willGo = false;
                                            isLoading = true;
                                          });

                                          print('Page started loading: $url');
                                        },
                                        onPageFinished: (String url) async {
                                          print('Page finished loading: $url');
                                          // cookieManager.clearCookies();
                                          // await cookieManager.setCookies([
                                          //   Cookie(cookieName, cookieValue)
                                          //     ..domain = domain
                                          //     ..expires = DateTime.now()
                                          //         .add(Duration(days: 365))
                                          //     ..httpOnly = true
                                          // ]);
                                          setState(() {
                                            context.loaderOverlay.hide();
                                            _willGo = true;
                                            isLoading = false;
                                            _controller.future
                                                .then((value) async {
                                              String urlPart =
                                                  await value.currentUrl() ??
                                                      '';

                                              String javaScriptString1 =
                                              '''\$('.express.app .popup').attr('style', 'z-index: 99999;position: absolute;opacity: 0.8;display:block;color: black;background: black;padding: 17%;font-weight: 700;color: white;height:-webkit-fill-available;float: left;left:0;right:0;text-align:center;');''';
                                              String javaScriptString2 =
                                              '''\$('.popup').html('<h1><b style="color:#ffff">You already having a booking with us.</b></h1>')''';
                                              String javaScript3 =
                                                  'document.getElementById("ui-datepicker-div").style.top=\'1410px\';';
                                              String javaScript4 = '''
                                                  document.getElementById("FullName").value="$_userName"
                                                  ''';
                                              String javaScript5 =
                                              '''document.getElementsByClassName("timebutton text-box single-line")[1].value=\'${_phoneNumber.replaceAll("", '')}\'
                                                  ''';
                                              String javaScript6 =
                                                  'document.getElementsByClassName("timebutton text-box single-line")[2].value=\"$_email\"';

                                              String javaScript7 = '''
                                                  document.getElementById("fname").value="$_userName"
                                                  ''';
                                              String javaScript8 =
                                                  'document.getElementsByClassName("add text-box single-line")[1].value=\'${_phoneNumber.replaceAll(' ', '')}\'';
                                              String javaScript9 =
                                                  'document.getElementsByClassName("add text-box single-line")[2].value=\"$_email\"';
                                              print('THE One Way>>> ' + javaScript7);
                                              print('THE One Way>>> ' + javaScript8);
                                              print('THE One Way>>> ' + javaScript9);

                                              //
                                              if (isUserLoggedIn != null &&
                                                  urlPart
                                                      .toLowerCase()
                                                      .contains(
                                                      'theoneexpress') &&
                                                  val.isBookingAvailable ==
                                                      true) {
                                                print("Javascript>>" +
                                                    javaScript4);

                                                await _webController
                                                    .runJavascript(
                                                    javaScriptString1);
                                                await _webController
                                                    .runJavascript(
                                                    javaScriptString2);
                                                value.runJavascript(
                                                    'document.getElementById("Date").readOnly=true;');

                                                await _webController
                                                    .runJavascript(javaScript5);
                                                await _webController
                                                    .runJavascript(javaScript4);
                                                await _webController
                                                    .runJavascript(javaScript6);
                                              } else if (isUserLoggedIn !=
                                                  null &&
                                                  urlPart
                                                      .toLowerCase()
                                                      .contains(
                                                      'theoneexpress') &&
                                                  val.isBookingAvailable ==
                                                      false) {
                                                value.runJavascript(
                                                    'document.getElementsByClassName("popup")[0].remove();');
                                                value.runJavascript(
                                                    'document.getElementById("Date").readOnly=true;');
                                                value
                                                    .runJavascript(javaScript3);
                                                value
                                                    .runJavascript(javaScript4);
                                                value
                                                    .runJavascript(javaScript5);
                                                value
                                                    .runJavascript(javaScript6);
                                              } else if (isUserLoggedIn !=
                                                  null &&
                                                  urlPart
                                                      .toLowerCase()
                                                      .contains('theoneway')) {
                                                value.runJavascript(
                                                    'document.getElementsByClassName("popup")[0].remove();');

                                                value
                                                    .runJavascript(javaScript7);
                                                value
                                                    .runJavascript(javaScript8);
                                                value
                                                    .runJavascript(javaScript9);
                                                // value
                                                //     .evaluateJavascript(javaScript5);
                                                // value
                                                //     .evaluateJavascript(javaScript6);
                                              }
                                            });
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
}
