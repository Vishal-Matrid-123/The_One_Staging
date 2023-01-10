import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/AppPages/MyOrders/MyOrders.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture,this.screenName);

  final Future<WebViewController> _webViewControllerFuture;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        var controllerGlobal = controller;

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 32,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: !webViewReady
                      ? null
                      : () async {
                          if (await controller!.canGoBack()) {
                            controller.goBack();
                          } else {
                            if (screenName
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
                            return;
                          }
                        },
                ),
              ),
              // Container(
              //   width: 32,
              //   child: IconButton(
              //     icon: const Icon(Icons.arrow_forward),
              //     onPressed: !webViewReady
              //         ? null
              //         : () async {
              //             if (await controller!.canGoForward()) {
              //               controller.goForward();
              //             } else {
              //               Scaffold.of(context).showSnackBar(
              //                 const SnackBar(
              //                     content: Text("No forward history item")),
              //               );
              //               return;
              //             }
              //           },
              //   ),
              // ),
              // Container(
              //   width: 32,
              //   child: IconButton(
              //     icon: const Icon(Icons.replay),
              //     onPressed: !webViewReady
              //         ? null
              //         : () {
              //             controller!.reload();
              //           },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
