import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);

  final Future<WebViewController> _webViewControllerFuture;

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
                            Navigator.pop(context);
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
