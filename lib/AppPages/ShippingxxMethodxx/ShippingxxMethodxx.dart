import 'dart:developer';
import 'dart:io' show Platform;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../utils/ApiCalls/ApiCalls.dart';

class ShippingMethod extends StatefulWidget {
  const ShippingMethod({
    Key? key,
  }) : super(key: key);

  @override
  _ShippingMethodState createState() => _ShippingMethodState();
}

class _ShippingMethodState extends State<ShippingMethod> {
  bool isSelected = false;
  var selectedVal = '';

  var _apiProvider = NewApisProvider();

  @override
  void initState() {
    super.initState();
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getShippingMethods();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: Adaptive.w(18),
            centerTitle: true,
            leading: InkWell(
              onTap: () => Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ShippingAddress(),
                ),
              ),
              child: Platform.isAndroid
                  ? const Icon(Icons.arrow_back)
                  : const Icon(Icons.arrow_back_ios),
            ),
            title: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyHomePage(
                            pageIndex: 0,
                          )),
                  (route) => false,
                );
              },
              radius: 60.0,
              child: Image.asset(
                'MyAssets/logo.png',
                width: Adaptive.w(15),
                height: Adaptive.w(15),
              ),
            )),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.white60,
                        child: Center(
                          child: AutoSizeText(
                            'Select Shipping Method'.toUpperCase(),
                            style: TextStyle(shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(1.0, 1.2),
                                blurRadius: 3.0,
                                color: Colors.grey.shade300,
                              ),
                              Shadow(
                                offset: const Offset(1.0, 1.2),
                                blurRadius: 8.0,
                                color: Colors.grey.shade300,
                              ),
                            ], fontSize: 5.w, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Consumer<NewApisProvider>(
                    builder: (_, value, child) => value.loading == true
                        ? const Center(
                            child: SpinKitRipple(
                              size: 40,
                              color: ConstantsVar.appColor,
                            ),
                          )
                        : value.isShippingDetailsScreenError == false
                            ? ListView.builder(
                                padding: const EdgeInsets.all(10),
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: value.shippingMethod.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: CheckboxListTile(
                                      activeColor: ConstantsVar.appColor,
                                      value: isSelected,
                                      onChanged: (bool? _value) {
                                        setState(
                                          () {
                                            if (isSelected) {
                                              selectedVal = '';
                                              isSelected = _value!;
                                              log(selectedVal);

                                              log("$isSelected");
                                            } else {
                                              isSelected = _value!;
                                              selectedVal = value
                                                      .shippingMethod[index]
                                                      .name +
                                                  '___' +
                                                  value.shippingMethod[index]
                                                      .shippingRateComputationMethodSystemName;
                                              log('$isSelected');
                                              log(selectedVal);
                                            }
                                          },
                                        );
                                      },
                                      tileColor: Colors.white24,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Center(
                                        child: AutoSizeText(
                                          value.shippingMethod[index].name +
                                              '(' +
                                              value.shippingMethod[index].fee +
                                              ')',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 5.w),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: AutoSizeText(
                                          removeAllHtmlTags(value
                                              .shippingMethod[index]
                                              .description),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 3.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    AutoSizeText(
                                      kerrorString,
                                      style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: const Offset(1.0, 1.2),
                                              blurRadius: 3.0,
                                              color: Colors.grey.shade300,
                                            ),
                                            Shadow(
                                              offset: const Offset(1.0, 1.2),
                                              blurRadius: 8.0,
                                              color: Colors.grey.shade300,
                                            ),
                                          ],
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _apiProvider.getShippingDetails(),
                                      child: const Text("Retry"),
                                    ),
                                  ],
                                ),
                              ),
                  )
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 100.w,
                  height: 51,
                  color: ConstantsVar.appColor,
                  child: LoadingButton(
                    onPressed: () async {
                      context.loaderOverlay.show(
                          widget: const SpinKitRipple(
                        color: Colors.red,
                        size: 90,
                      ));
                      if (isSelected == false) {
                        Fluttertoast.showToast(
                            msg: 'Please select a Shipping Method first');
                        context.loaderOverlay.hide();
                      } else {
                        await ApiCalls.selectShippingMethod(
                            selectionValue: selectedVal, context: context);
                      }
                    },
                    loadingWidget: const SpinKitCircle(
                      color: Colors.white,
                      size: 20,
                    ),
                    defaultWidget: Container(
                      width: double.infinity,
                      height: 50,
                      color: ConstantsVar.appColor,
                      child: Center(
                        child: AutoSizeText(
                          'Confirm'.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
