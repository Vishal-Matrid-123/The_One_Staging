import 'dart:async';
import 'dart:io' show Platform;

import 'package:auto_size_text/auto_size_text.dart';
// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
// import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
// import 'package:untitled2/AppPages/ShippingxxxScreen/BillingxxScreen/BillingScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/PojoClass/NetworkModelClass/CartModelClass/CartModel.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
// import 'package:untitled2/utils/ApiCalls/CategoryModel.dart';
import 'package:untitled2/utils/HeartIcon.dart';

import '../LoginScreen/LoginScreen.dart';
import '../ShippingxxxScreen/BillingxxScreen/BillingScreen.dart';
import 'CartItems.dart';

class CartScreen2 extends StatefulWidget {
  final bool isOtherScren;
  final String otherScreenName;

  @override
  _CartScreen2State createState() => _CartScreen2State();

  const CartScreen2(
      {Key? key, required this.isOtherScren, required this.otherScreenName})
      : super(key: key);
}

class _CartScreen2State extends State<CartScreen2>
    with AutomaticKeepAliveClientMixin, InputValidationMixin {
  bool isCartAvail = true;
  var gUId;
  var customerId = "";
  var guestCustomerID = "";
  var quantity;
  bool visibility = false;
  bool indVisibility = true;
  var subTotal = '';
  var shipping = '';
  var taxPrice = '';
  var totalAmount = '';
  var discountPrice = '';
  String discountCoupon = '';
  String giftCoupon = '';
  bool showDiscount = false;
  bool showLoading = false, applyCouponCode = true, removeCouponCode = false;
  bool applyGiftCard = true, removeGiftCard = false;

  bool connectionStatus = true;
  List<CartItems> cartItems = [];
  bool loadCartFirst = true;
  TextEditingController discountController = TextEditingController();
  TextEditingController giftCardController = TextEditingController();

  final doubleRegex = RegExp(r'^\[A-Z+\0-9+\a-z+\A-Z]$', multiLine: true);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<FormState> discountKey = GlobalKey<FormState>();
  final GlobalKey<FormState> giftCouponKey = GlobalKey<FormState>();
  NewApisProvider _provider = NewApisProvider();

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<NewApisProvider>(context, listen: false);
    getCustomerIdxx();
    // ApiCalls.readCounter(customerGuid: gUId)
    //     .then((value) => context.read<cartCounter>().changeCounter(value));

    getCustomerId().then((value) => setState(() => customerId = value));
    setState(() {
      guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID') ?? "";

      if (loadCartFirst == false) {
        setState(() {
          loadCartFirst = true;
        });
      } else {
        showAndUpdateUi();
        setState(() => loadCartFirst = false);
      }
    });

    visibility = false;
    indVisibility = true;
    if (discountController.text.toString == '') {
      setState(() {
        removeCouponCode = false;
      });
    } else {
      setState(() => removeCouponCode = true);
    }
  }

  Future<void> showAndUpdateUi() async {
    await _provider.showCart().whenComplete(() {
      cartItems = _provider.cartModel.listCart.items;
      setState(() {
        isCartAvail = false;
        // CartModel model = _provider.cartModel;

        visibility = true;
        indVisibility = false;
        subTotal = _provider.cartModel.orderTotalsModel.subTotal;
        shipping = _provider.cartModel.orderTotalsModel.shipping;
        taxPrice = _provider.cartModel.orderTotalsModel.tax;
        totalAmount = _provider.cartModel.orderTotalsModel.orderTotal;
        discountPrice = _provider.cartModel.orderTotalsModel.subTotalDiscount;
        quantity = cartItems.length;
        if (_provider
            .cartModel.listCart.discountBox.appliedDiscountsWithCodes.isEmpty) {
          discountCoupon = '';
        } else {
          discountCoupon = _provider.cartModel.listCart.discountBox
                  .appliedDiscountsWithCodes[0]['CouponCode'] ??
              '';
          discountController.text = discountCoupon;
        }

        if (_provider.cartModel.orderTotalsModel.giftCards.isNotEmpty) {
          giftCoupon = _provider.cartModel.orderTotalsModel.giftCards[0]
                  ['CouponCode'] ??
              '';
          giftCardController.text = giftCoupon;
          if (giftCardController.text.trim() == null) {
            removeGiftCard = false;
          } else {
            removeGiftCard = true;
          }
        } else {
          giftCoupon = '';
          removeGiftCard = false;
        }

        setState(() {
          _refreshController.refreshCompleted();
        });
        if (discountPrice == '') {
          setState(() {
            discountPrice = 'No Discount Available';
            showDiscount = false;
            removeCouponCode = false;
          });
        } else {
          setState(() {
            showDiscount = true;
            removeCouponCode = true;
          });
        }

        /* if no shipping on the product but have discount and total amount both*/
      });
    });
    ApiCalls.readCounter(context: context);
    _sendAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: widget.isOtherScren == true ? setBackIcon() : null,
        backgroundColor: ConstantsVar.appColor,
        toolbarHeight: 18.w,
        centerTitle: true,
        title: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => MyHomePage(
                          pageIndex: 0,
                        )),
              );
            },
            child: Image.asset('MyAssets/logo.png', width: 15.w, height: 15.w)),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Consumer<NewApisProvider>(
          builder: (_, value, c) => value.loading == true
              ? const Center(
                  child: SpinKitRipple(
                    color: ConstantsVar.appColor,
                    size: 40,
                  ),
                )
              : value.isCartScreenError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          AutoSizeText(
                            kerrorString,
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
                            ], fontSize: 18, fontWeight: FontWeight.bold),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              CustomProgressDialog _progressDialog =
                                  CustomProgressDialog(
                                context,
                                loadingWidget: const SpinKitRipple(
                                  color: ConstantsVar.appColor,
                                  size: 40,
                                ),
                                dismissable: true,
                              );
                              _progressDialog.show();
                              await showAndUpdateUi();
                              _progressDialog.dismiss();
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : cartItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: AutoSizeText(
                              'No Item(s) in cart.\n\n\nAn empty home is an empty heart, fill your heart with LOVE from THE One.\nHome is where the Heart is....  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: .8,
                                  height: 2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.dp),
                            ),
                          ),
                        )
                      : c!,
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: showAndUpdateUi,
            header: const WaterDropHeader(),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: AutoSizeText(
                      'My Cart'.toUpperCase(),
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
                const SizedBox(
                  height: 4,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AutoSizeText(
                          'price details'.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AutoSizeText(
                              'Sub-Total:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            AutoSizeText(
                              subTotal,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AutoSizeText(
                              'Shipping:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            AutoSizeText(
                              shipping ?? 'No Shipping Available for now ',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Visibility(
                          visible: showDiscount,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AutoSizeText(
                                'Discount:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              AutoSizeText(
                                discountPrice??'No Discount Applied',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AutoSizeText(
                              'Tax 5%:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                            AutoSizeText(
                              taxPrice ?? 'No info available',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        'Total Amount ',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        totalAmount,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    thickness: 2,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItem(
                        itemID: cartItems[index].itemId,
                        quantity: cartItems[index].quantity,
                        title: cartItems[index].productName,
                        sku: cartItems[index].sku,
                        price: cartItems[index].unitPrice,
                        imageUrl: cartItems[index].picture.imageUrl,
                        updateUi: () {
                          showAndUpdateUi();
                          _refreshController.requestRefresh();
                        },
                        reload: () {
                          showAndUpdateUi();
                          _refreshController.requestRefresh();
                        },
                        id: guestCustomerID,
                        productId: cartItems[index].productId.toString(),
                        quantity2: cartItems[index].quantity,
                        unitPrice: cartItems[index].unitPrice,
                      );
                    }),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    thickness: 2,
                  ),
                ),

                /******* Discount layout started **********/
                Container(
                    margin: const EdgeInsets.all(12.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: AutoSizeText(
                            'Discount Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 5.4.w),
                          ),
                        ),

                        /******* Apply coupon Code design *************/
                        Visibility(
                          visible: applyCouponCode,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 67.w,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(6)),
                                child: TextFormField(
                                  autofocus: false,
                                  controller: discountController,
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        if (discountController.text.trim() !=
                                                '' &&
                                            discountController.text
                                                    .toString()
                                                    .trim()
                                                    .length >=
                                                4) {
                                          ApiCalls.removeCoupon(
                                            baseUrl: await ApiCalls
                                                .getSelectedStore(),
                                            storeId: await secureStorage.read(
                                                    key: kselectedStoreIdKey) ??
                                                '1',
                                            coupon: discountCoupon,
                                            refresh: _refreshController,
                                          ).then((value) =>
                                              value.toString().contains('true')
                                                  ? setState(() {
                                                      discountController.text =
                                                          '';
                                                    })
                                                  : null);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'No Discount Coupon Applied');
                                        }
                                      },
                                      child: const Icon(HeartIcon.cross),
                                    ),
                                    focusedBorder: InputBorder.none,
                                    // enabledBorder:
                                    //     OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             color: Colors
                                    //                 .black)),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    contentPadding: const EdgeInsets.all(12.0),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.black,
                                width: 25.w,
                                height: 51,
                                child: Center(
                                  child: LoadingButton(
                                    loadingWidget: const SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    width: 25.w,
                                    height: 50,
                                    onPressed: () async {
                                      if (discountController.text
                                              .toString()
                                              .trim()
                                              .isEmpty ||
                                          discountController.text
                                                  .toString()
                                                  .trim()
                                                  .length <=
                                              4) {
                                        Fluttertoast.showToast(
                                            msg: 'Enter valid coupon code');
                                      } else {
                                        await ApiCalls.applyCoupon(
                                                baseUrl: await ApiCalls
                                                    .getSelectedStore(),
                                                storeId: await secureStorage.read(
                                                        key:
                                                            kselectedStoreIdKey) ??
                                                    '1',
                                                coupon: discountController.text
                                                    .toString(),
                                                refresh: _refreshController)
                                            .then((value) {
                                          setState(() {
                                            if (value == 'true') {
                                              removeCouponCode = true;
                                            } else {
                                              discountController.text = '';
                                            }
                                          });
                                        });
                                      }
                                    },
                                    color: Colors.black,
                                    defaultWidget: Center(
                                      child: AutoSizeText(
                                        'Apply Coupon',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 4.w, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /****************Gift cards design ************/
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: AutoSizeText(
                              'Gift Cards',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 5.4.w),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: applyGiftCard,
                          child: SizedBox(
                            width: 100.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 67.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: TextFormField(
                                      autofocus: false,
                                      controller: giftCardController,
                                      decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              if (giftCardController.text
                                                          .trim() !=
                                                      '' &&
                                                  giftCardController.text
                                                          .trim()
                                                          .length >=
                                                      4) {
                                                _provider
                                                    .removeGiftCard(
                                                        giftcardcouponcode:
                                                            giftCardController
                                                                .text
                                                                .trim())
                                                    .whenComplete(() {
                                                  setState(() {
                                                    giftCardController.text =
                                                        '';
                                                  });
                                                  _refreshController
                                                      .requestRefresh();
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'No Gift Coupon Applied');
                                              }
                                            },
                                            child: const Icon(HeartIcon.cross),
                                          ),
                                          focusedBorder: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(12.0))),
                                ),
                                Container(
                                  width: 25.w,
                                  height: 51,
                                  color: Colors.black,
                                  child: LoadingButton(
                                    width: 25.w,
                                    height: 50,
                                    loadingWidget: const SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    color: Colors.black,
                                    onPressed: () async {
                                      if (giftCardController.text
                                              .toString()
                                              .length <=
                                          4) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Enter valid gift card number');
                                      } else {
                                        CustomProgressDialog _dialog =
                                            CustomProgressDialog(context,
                                                loadingWidget:
                                                    const SpinKitRipple(
                                                  color: ConstantsVar.appColor,
                                                  size: 40,
                                                ),
                                                dismissable: true);
                                        _dialog.show();
                                        await _provider.applyGiftCard(
                                            giftcardcouponcode:
                                                giftCardController.text
                                                    .toString());
                                        _dialog.dismiss();
                                        _refreshController.requestLoading();
                                      }
                                    },
                                    defaultWidget: AutoSizeText(
                                      'Add Gift Card',
                                      style: TextStyle(
                                          fontSize: 4.w, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    thickness: 2,
                  ),
                ),
                SizedBox(
                  height: 5.w,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: bottomButtons(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    //   if (cartItems.isNotEmpty) {
    //     return SafeArea(
    //       top: true,
    //       bottom: true,
    //       maintainBottomViewPadding: true,
    //       child: Scaffold(
    //         resizeToAvoidBottomInset: true,
    //         appBar: AppBar(
    //           leading: widget.isOtherScren == true ? setBackIcon() : null,
    //           backgroundColor: ConstantsVar.appColor,
    //           toolbarHeight: 18.w,
    //           centerTitle: true,
    //           title: InkWell(
    //               onTap: () {
    //                 Navigator.pushReplacement(
    //                   context,
    //                   CupertinoPageRoute(
    //                       builder: (context) => MyHomePage(
    //                             pageIndex: 0,
    //                           )),
    //                 );
    //               },
    //               child: Image.asset('MyAssets/logo.png',
    //                   width: 15.w, height: 15.w)),
    //         ),
    //         body: Visibility(
    //           visible: visibility,
    //           child: SmartRefresher(
    //             controller: _refreshController,
    //             enablePullDown: true,
    //             enablePullUp: false,
    //             onRefresh: showAndUpdateUi,
    //             header: const WaterDropHeader(),
    //             child: Stack(
    //               children: [
    //                 ListView(
    //                   children: [
    //                     Container(
    //                       padding: const EdgeInsets.all(20.0),
    //                       width: MediaQuery.of(context).size.width,
    //                       child: Center(
    //                         child: AutoSizeText(
    //                           'My Cart'.toUpperCase(),
    //                           style: TextStyle(shadows: <Shadow>[
    //                             Shadow(
    //                               offset: const Offset(1.0, 1.2),
    //                               blurRadius: 3.0,
    //                               color: Colors.grey.shade300,
    //                             ),
    //                             Shadow(
    //                               offset: const Offset(1.0, 1.2),
    //                               blurRadius: 8.0,
    //                               color: Colors.grey.shade300,
    //                             ),
    //                           ], fontSize: 5.w, fontWeight: FontWeight.bold),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 4,
    //                     ),
    //                     Container(
    //                       padding: const EdgeInsets.all(8.0),
    //                       width: double.infinity,
    //                       decoration: const BoxDecoration(
    //                         color: Color(0xFFEEEEEE),
    //                       ),
    //                       child: Column(
    //                         mainAxisSize: MainAxisSize.max,
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: AutoSizeText(
    //                               'price details'.toUpperCase(),
    //                               style: const TextStyle(
    //                                 fontFamily: 'Poppins',
    //                                 fontSize: 18,
    //                                 color: Colors.grey,
    //                               ),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: Row(
    //                               mainAxisSize: MainAxisSize.max,
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 const AutoSizeText(
    //                                   'Sub-Total:',
    //                                   style: TextStyle(
    //                                     fontFamily: 'Poppins',
    //                                     fontSize: 15,
    //                                   ),
    //                                 ),
    //                                 AutoSizeText(
    //                                   subTotal,
    //                                   style: const TextStyle(
    //                                       fontFamily: 'Poppins',
    //                                       fontSize: 15,
    //                                       fontWeight: FontWeight.bold),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: Row(
    //                               mainAxisSize: MainAxisSize.max,
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 const AutoSizeText(
    //                                   'Shipping:',
    //                                   style: TextStyle(
    //                                     fontFamily: 'Poppins',
    //                                     fontSize: 15,
    //                                   ),
    //                                 ),
    //                                 AutoSizeText(
    //                                   shipping ??
    //                                       'No Shipping Available for now ',
    //                                   style: const TextStyle(
    //                                       fontFamily: 'Poppins',
    //                                       fontSize: 15,
    //                                       color: Colors.green,
    //                                       fontWeight: FontWeight.bold),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: Visibility(
    //                               visible: showDiscount,
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   const AutoSizeText(
    //                                     'Discount:',
    //                                     style: TextStyle(
    //                                       fontFamily: 'Poppins',
    //                                       fontSize: 14,
    //                                     ),
    //                                   ),
    //                                   AutoSizeText(
    //                                     discountPrice,
    //                                     style: const TextStyle(
    //                                         fontFamily: 'Poppins',
    //                                         fontSize: 15,
    //                                         fontWeight: FontWeight.bold),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(
    //                                 left: 4.0, right: 4.0),
    //                             child: Row(
    //                               // mainAxisSize: MainAxisSize.max,
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 const AutoSizeText(
    //                                   'Tax 5%:',
    //                                   style: TextStyle(
    //                                     fontFamily: 'Poppins',
    //                                     fontSize: 14,
    //                                   ),
    //                                 ),
    //                                 AutoSizeText(
    //                                   taxPrice ?? '',
    //                                   style: const TextStyle(
    //                                       fontFamily: 'Poppins',
    //                                       fontSize: 15,
    //                                       fontWeight: FontWeight.bold),
    //                                 )
    //                               ],
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width,
    //                       child: const Divider(
    //                         thickness: 2,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
    //                       child: Row(
    //                         mainAxisSize: MainAxisSize.max,
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           const AutoSizeText(
    //                             'Total Amount ',
    //                             style: TextStyle(
    //                                 fontFamily: 'Poppins',
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.bold),
    //                           ),
    //                           AutoSizeText(
    //                             totalAmount,
    //                             style: const TextStyle(
    //                                 fontFamily: 'Poppins',
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.bold),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width,
    //                       child: const Divider(
    //                         thickness: 2,
    //                       ),
    //                     ),
    //                     ListView.builder(
    //                         shrinkWrap: true,
    //                         physics: const NeverScrollableScrollPhysics(),
    //                         padding: const EdgeInsets.all(8.0),
    //                         itemCount: cartItems.length,
    //                         itemBuilder: (context, index) {
    //                           return CartItem(
    //                             itemID: cartItems[index].itemId,
    //                             quantity: cartItems[index].quantity,
    //                             title: cartItems[index].productName,
    //                             sku: cartItems[index].sku,
    //                             price: cartItems[index].subTotal,
    //                             imageUrl: cartItems[index].picture.imageUrl,
    //                             updateUi: () {
    //                               showAndUpdateUi();
    //                               _refreshController.requestRefresh();
    //                             },
    //                             reload: () {
    //                               showAndUpdateUi();
    //                               _refreshController.requestRefresh();
    //                             },
    //                             id: guestCustomerID,
    //                             productId: cartItems[index].productId,
    //                             quantity2: cartItems[index].quantity,
    //                             unitPrice: cartItems[index].unitPrice,
    //                           );
    //                         }),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width,
    //                       child: const Divider(
    //                         thickness: 2,
    //                       ),
    //                     ),
    //
    //                     /******* Discount layout started **********/
    //                     Container(
    //                         margin: const EdgeInsets.all(12.0),
    //                         width: MediaQuery.of(context).size.width,
    //                         child: Column(
    //                           children: <Widget>[
    //                             SizedBox(
    //                               width: MediaQuery.of(context).size.width,
    //                               child: AutoSizeText(
    //                                 'Discount Code',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.black,
    //                                     fontSize: 5.4.w),
    //                               ),
    //                             ),
    //
    //                             /******* Apply coupon Code design *************/
    //                             Visibility(
    //                               visible: applyCouponCode,
    //                               child: Row(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: <Widget>[
    //                                   Container(
    //                                     width: 67.w,
    //                                     decoration: BoxDecoration(
    //                                         border:
    //                                             Border.all(color: Colors.black),
    //                                         borderRadius:
    //                                             BorderRadius.circular(6)),
    //                                     child: TextFormField(
    //                                       autofocus: false,
    //                                       controller: discountController,
    //                                       decoration: InputDecoration(
    //                                         suffixIcon: InkWell(
    //                                           onTap: () {
    //                                             if (discountController.text
    //                                                         .trim() !=
    //                                                     '' &&
    //                                                 discountController.text
    //                                                         .toString()
    //                                                         .trim()
    //                                                         .length >=
    //                                                     4) {
    //                                               ApiCalls.removeCoupon(
    //                                                       context,
    //                                                       ConstantsVar
    //                                                           .apiTokken!,
    //                                                       guestCustomerID,
    //                                                       discountCoupon,
    //                                                       _refreshController)
    //                                                   .then((value) => value
    //                                                           .toString()
    //                                                           .contains('true')
    //                                                       ? setState(() {
    //                                                           discountController
    //                                                               .text = '';
    //                                                         })
    //                                                       : null);
    //                                             } else {
    //                                               Fluttertoast.showToast(
    //                                                   msg:
    //                                                       'No Discount Coupon Applied');
    //                                             }
    //                                           },
    //                                           child:
    //                                               const Icon(HeartIcon.cross),
    //                                         ),
    //                                         focusedBorder: InputBorder.none,
    //                                         // enabledBorder:
    //                                         //     OutlineInputBorder(
    //                                         //         borderSide: BorderSide(
    //                                         //             color: Colors
    //                                         //                 .black)),
    //                                         border: const OutlineInputBorder(
    //                                             borderSide: BorderSide(
    //                                                 color: Colors.black)),
    //                                         contentPadding:
    //                                             const EdgeInsets.all(12.0),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Container(
    //                                     color: Colors.black,
    //                                     width: 25.w,
    //                                     height: 51,
    //                                     child: Center(
    //                                       child: LoadingButton(
    //                                         loadingWidget: const SpinKitCircle(
    //                                           color: Colors.white,
    //                                           size: 30,
    //                                         ),
    //                                         width: 25.w,
    //                                         height: 50,
    //                                         onPressed: () async {
    //                                           if (discountController.text
    //                                                   .toString()
    //                                                   .trim()
    //                                                   .isEmpty ||
    //                                               discountController.text
    //                                                       .toString()
    //                                                       .trim()
    //                                                       .length <=
    //                                                   4) {
    //                                             Fluttertoast.showToast(
    //                                                 msg:
    //                                                     'Enter valid coupon code');
    //                                           } else {
    //                                             await ApiCalls.applyCoupon(
    //                                                     ConstantsVar.apiTokken
    //                                                         .toString(),
    //                                                     ConstantsVar.customerID,
    //                                                     discountController.text
    //                                                         .toString(),
    //                                                     _refreshController)
    //                                                 .then((value) {
    //                                               setState(() {
    //                                                 if (value == 'true') {
    //                                                   removeCouponCode = true;
    //                                                 } else {
    //                                                   discountController.text =
    //                                                       '';
    //                                                 }
    //                                               });
    //                                             });
    //                                           }
    //                                         },
    //                                         color: Colors.black,
    //                                         defaultWidget: Center(
    //                                           child: AutoSizeText(
    //                                             'Apply Coupon',
    //                                             overflow: TextOverflow.ellipsis,
    //                                             maxLines: 1,
    //                                             style: TextStyle(
    //                                                 fontSize: 4.w,
    //                                                 color: Colors.white),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //
    //                             /****************Gift cards design ************/
    //                             Padding(
    //                               padding:
    //                                   const EdgeInsets.symmetric(vertical: 8.0),
    //                               child: SizedBox(
    //                                 width: MediaQuery.of(context).size.width,
    //                                 child: AutoSizeText(
    //                                   'Gift Cards',
    //                                   style: TextStyle(
    //                                       fontWeight: FontWeight.bold,
    //                                       color: Colors.black,
    //                                       fontSize: 5.4.w),
    //                                 ),
    //                               ),
    //                             ),
    //                             Visibility(
    //                               visible: applyGiftCard,
    //                               child: SizedBox(
    //                                 width: 100.w,
    //                                 child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     Container(
    //                                       width: 67.w,
    //                                       decoration: BoxDecoration(
    //                                           border: Border.all(
    //                                               color: Colors.black),
    //                                           borderRadius:
    //                                               BorderRadius.circular(6)),
    //                                       // height: 5.h,
    //                                       child: TextFormField(
    //                                           autofocus: false,
    //                                           controller: giftCardController,
    //                                           decoration: InputDecoration(
    //                                               suffixIcon: InkWell(
    //                                                 onTap: () {
    //                                                   if (giftCardController
    //                                                               .text
    //                                                               .trim() !=
    //                                                           '' &&
    //                                                       giftCardController
    //                                                               .text
    //                                                               .trim()
    //                                                               .length >=
    //                                                           4) {
    //                                                     ApiCalls.removeGiftCoupon(
    //                                                             ConstantsVar
    //                                                                 .apiTokken!,
    //                                                             guestCustomerID,
    //                                                             giftCardController
    //                                                                 .text
    //                                                                 .trim(),
    //                                                             _refreshController)
    //                                                         .then((value) =>
    //                                                             setState(() =>
    //                                                                 giftCardController
    //                                                                         .text =
    //                                                                     ''));
    //                                                   } else {
    //                                                     Fluttertoast.showToast(
    //                                                         msg:
    //                                                             'No Gift Coupon Applied');
    //                                                   }
    //                                                 },
    //                                                 child: const Icon(
    //                                                     HeartIcon.cross),
    //                                               ),
    //                                               focusedBorder:
    //                                                   InputBorder.none,
    //                                               contentPadding:
    //                                                   const EdgeInsets.all(
    //                                                       12.0))),
    //                                     ),
    //                                     Container(
    //                                       width: 25.w,
    //                                       height: 51,
    //                                       color: Colors.black,
    //                                       child: LoadingButton(
    //                                         width: 25.w,
    //                                         height: 50,
    //                                         loadingWidget: const SpinKitCircle(
    //                                           color: Colors.white,
    //                                           size: 30,
    //                                         ),
    //                                         color: Colors.black,
    //                                         onPressed: () async {
    //                                           if (giftCardController.text
    //                                                   .toString()
    //                                                   .length <=
    //                                               4) {
    //                                             Fluttertoast.showToast(
    //                                                 msg:
    //                                                     'Enter valid gift card number');
    //                                           } else {
    //                                             await ApiCalls.applyGiftCard(
    //                                                     ConstantsVar.apiTokken
    //                                                         .toString(),
    //                                                     ConstantsVar.customerID,
    //                                                     giftCardController.text
    //                                                         .toString())
    //                                                 .then((value) {
    //                                               if (value == 'false') {
    //                                                 setState(() {
    //                                                   giftCardController
    //                                                       .clear();
    //                                                 });
    //                                               } else {}
    //                                             });
    //                                           }
    //                                         },
    //                                         defaultWidget: AutoSizeText(
    //                                           'Add Gift Card',
    //                                           style: TextStyle(
    //                                               fontSize: 4.w,
    //                                               color: Colors.white),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         )),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width,
    //                       child: const Divider(
    //                         thickness: 2,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 5.w,
    //                     ),
    //                     Align(
    //                       alignment: Alignment.bottomCenter,
    //                       child: bottomButtons(context),
    //                     ),
    //                   ],
    //                 ),
    //                 Visibility(
    //                   visible: showLoading,
    //                   child: Positioned.fill(
    //                     child: Align(
    //                         alignment: Alignment.centerRight,
    //                         child: showloader()),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   } else if (isCartAvail == true) {
    //     return Scaffold(
    //       appBar: AppBar(
    //         centerTitle: true,
    //         backgroundColor: ConstantsVar.appColor,
    //         toolbarHeight: 18.w,
    //         title: Image.asset(
    //           'MyAssets/logo.png',
    //           width: 15.w,
    //           height: 15.w,
    //         ),
    //       ),
    //       body: Center(
    //         child: SpinKitRipple(
    //           color: Colors.primaries.first.shade900,
    //           size: 90,
    //         ),
    //       ),
    //     );
    //   } else if (cartItems.isEmpty) {
    //     return SafeArea(
    //       top: true,
    //       child: Scaffold(
    //         appBar: AppBar(
    //           backgroundColor: ConstantsVar.appColor,
    //           toolbarHeight: 18.w,
    //           centerTitle: true,
    //           title: InkWell(
    //             onTap: () {
    //               Navigator.pushAndRemoveUntil(
    //                   context,
    //                   CupertinoPageRoute(
    //                       builder: (context) => MyHomePage(
    //                             pageIndex: 0,
    //                           )),
    //                   (route) => false);
    //             },
    //             child: Image.asset(
    //               'MyAssets/logo.png',
    //               width: 15.w,
    //               height: 15.w,
    //             ),
    //           ),
    //         ),
    //         body: Center(
    //           child: Padding(
    //             padding: const EdgeInsets.all(3.0),
    //             child: AutoSizeText(
    //               'No Item(s) in cart.\n\n\nAn empty home is an empty heart, fill your heart with LOVE from THE One.\nHome is where the Heart is....  ',
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                   letterSpacing: .8,
    //                   height: 2,
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 17.dp),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   } else {
    //     return Scaffold(body: Container());
    //   }
    // }
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    customerId = ConstantsVar.prefs.getString('userId') ?? "";

    return customerId;
  }

  Widget bottomButtons(BuildContext context) {
    return InkWell(
      onTap: () async {
        guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID') ?? "";
        customerId = ConstantsVar.prefs.getString('userId') ?? "";
        if (guestCustomerID != '$customerId') {
          // setState((){
          //   cartItems.clear();
          //   visibility = false;
          //   indVisibility = true;
          // });
          var result = await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => LoginScreen(
                screenKey: widget.isOtherScren == true
                    ? widget.otherScreenName
                    : 'Cart Screen',
              ),
            ),
          );
          if (result == true) {
            setState(() {
              guestCustomerID =
                  ConstantsVar.prefs.getString('guestCustomerID') ?? "";
              _refreshController.requestRefresh();
              // showAndUpdateUi();
            });
          }
          // } else {

          // }
        } else {
          await ApiCalls.checkCart(context: context).then(
            (value) async {
              log(value);
              if (value.contains(kerrorString)) {
                //   await FacebookAppEvents().logInitiatedCheckout(
                //       totalPrice: 0,
                //       currency: CurrencyCode.AED.name,
                //       numItems: quantity);
                //   await Provider.of<FirebaseAnalytics>(context, listen: false)
                //       .logBeginCheckout(
                //         currency: 'AED',
                //         value: double.parse(
                //             totalAmount.replaceAll('AED', '').replaceAll(',', '')),
                //       )
                //       .whenComplete(() async =>
                //       await Navigator.push(context,
                //               CupertinoPageRoute(builder: (context) {
                //             return BillingDetails();
                //           })));
              }       else {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return BillingDetails();
                    },
                  ),
                );
              }
            },
          );
        }
      },
      child: Container(
        height: 11.w,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: ConstantsVar.appColor),
        child: Center(
          child: AutoSizeText(
            'checkout'.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future getCustomerIdxx() async {
    customerId = ConstantsVar.customerID;
    gUId = ConstantsVar.prefs.getString('guestGUID');
  }

  Future refresh() async {
    _refreshController.refreshCompleted();
  }

  Widget setBackIcon() {
    if (Platform.isAndroid) {
      return InkWell(
          onTap: () {
            if (widget.otherScreenName.contains('Cart Screen2')) {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyHomePage(pageIndex: 4),
                  ),
                  (route) => false);
            } else {
              Navigator.pop(context, true);
            }
          },
          child: const Icon(Icons.arrow_back));
      // Android-specific code
    } else {
      return InkWell(
        onTap: () {
          if (widget.otherScreenName.contains('Cart Screen2')) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyHomePage(pageIndex: 4),
                ),
                (route) => false);
          } else {
            Navigator.pop(context, true);
          }
        },
        child: const Icon(Icons.arrow_back),
      ); // iOS-specific code
    }
  }

  double returnValue() {
    try {
      return double.parse(totalAmount.replaceAll(RegExp(r'[^0-9]'), ''));
    } on Exception {
      return 0.0;
    }
  }

  void _sendAnalytics() async {
    log(returnValue().toString());

    _provider.getCurrency();
    cartItems.isEmpty
        ? null
        : FirebaseEvents.initialize(context: context).sendViewCartData(
            currency: _provider.currency,
            value: returnValue(),
            items: List.generate(
              cartItems.length,
              (index) => AnalyticsEventItem(
                itemName: cartItems[index].productName,
                itemId: cartItems[index].productId.toString(),
                price: double.parse(cartItems[index]
                    .unitPrice
                    .replaceAll(RegExp(r'[^0-9]'), '')),
              ),
            ),
          );
    FirebaseEvents.initialize(context: context)
        .sendScreenViewData(screenName: "Cart Screen");
    FacebookEvents().sendSearchData(keyword: "Cart Screen");
  }
}
