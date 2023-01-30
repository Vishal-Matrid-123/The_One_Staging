import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as b;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/AddToCartResponse/AddToCartResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/new_product_list_response/new_product_list_response.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';

import 'ProductListWidget/ProductListWid.dart';

class ProductList extends StatefulWidget {
  const ProductList(
      {Key? key, required String categoryId, required String title})
      : _categoryId = categoryId,
        _title = title,
        super(key: key);
  final String _categoryId;
  final String _title;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;

  int pageIndex = 0;
  var color;
  NewApisProvider _provider = NewApisProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = Provider.of<NewApisProvider>(context, listen: false);
    getId().whenComplete(
      () async => _provider
          .getProductList(
              catId: widget._categoryId, pageIndex: pageIndex, isLoading: false)
          .then((value) async {
        _provider.getCurrency();
        // await FirebaseAnalytics.instance.logEvent(
        //     name: 'screen_view_',
        //     parameters: {'screen_name': 'Product List  Screen'});
        // await FacebookAppEvents()
        //     .logViewContent(

        //       currency: CurrencyCode.AED.name,
        //     )
        //     .whenComplete(() => log('Content Viewed on Product List Page'));
      }).whenComplete(
        () async {
          /*Firebase Event*/
          _sendAnalytics(
            products: _provider.productList,
          );

          /*Facebook Events*/
          final _fbEvent = FacebookEvents();
          _fbEvent
              .sendScreenViewData(
                type: 'Product List Screen',
                id: widget._categoryId.toString(),
              )
              .whenComplete(
                () => log(
                  "Event complete",
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: InkWell(
                    // splashColor: Colors.amber,
                    radius: 48,
                    child: Consumer<CartCounter>(
                      builder: (context, value, child) {
                        return b.Badge(
                          badgeColor: Colors.white,
                          padding: const EdgeInsets.all(5),
                          shape: b.BadgeShape.circle,
                          position: b.BadgePosition.topEnd(),
                          badgeContent:
                              AutoSizeText(value.badgeNumber.toString()),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const CartScreen2(
                          otherScreenName: 'Product List',
                          isOtherScren: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              toolbarHeight: 18.w,
              backgroundColor: ConstantsVar.appColor,
              centerTitle: true,
              // leading: Icon(Icons.arrow_back_ios),
              title: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MyHomePage(
                              pageIndex: 0,
                            )),
                    (route) => false),
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Consumer<NewApisProvider>(
              builder: (_, value, c) => value.loading == true
                  ? const Center(
                      child: SpinKitRipple(
                        color: ConstantsVar.appColor,
                        size: 40,
                      ),
                    )
                  : value.isProductListScreenError
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
                                  CustomProgressDialog _dialog =
                                      CustomProgressDialog(
                                    context,
                                    dismissable: false,
                                    loadingWidget: const SpinKitRipple(
                                      color: ConstantsVar.appColor,
                                      size: 50,
                                    ),
                                  );
                                  // _dialog.setLoadingWidget();
                                  _dialog.show();
                                  await _provider.getProductList(
                                    catId: widget._categoryId,
                                    pageIndex: pageIndex,
                                    isLoading: false,
                                  );
                                  _dialog.dismiss();
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : ProdListWidget(
                          products: value.productList,
                          title: widget._title.toString().toUpperCase(),
                          // result: result,
                          pageIndex: pageIndex,
                          id: widget._categoryId,
                          productCount: value.productCount,
                        ),
            )));
  }

  void _sendAnalytics({required List<ProductListResponse> products}) async {
    FirebaseEvents.initialize(
      context: context,
    ).sendViewItemsListData(
      items: List.generate(
        products.length,
        (index) => AnalyticsEventItem(
            itemId: products[index].id.toString(),
            itemName: products[index].name,
            price: products[index].priceValue,
            quantity: 1),
      ),
      itemListName: widget._title,
      itemListId: widget._categoryId,
    );
  }

  Future<void> getId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }
}

class AddCartBtn extends StatefulWidget {
  AddCartBtn(
      {Key? key,
      required this.productId,
      required this.text,
      required this.productName,
      // required this.productImage,
      required this.isTrue,
      required this.guestCustomerId,
      required this.checkIcon,
      required this.color,
      required this.isProductAttributeAvail,
      required this.isGiftCard,
      required this.recipEmail,
      required this.attributeId,
      required this.message,
      required this.name,
      required this.email,
      required this.recipName,
      required this.productPrice,
      required String storeId,
      required this.categoryId
        , required this.minQuantity
      // required this.productName,
      })
      : super(key: key);
  final String productId;
  final String minQuantity;
  // final String productName;
  final String guestCustomerId;
  final double productPrice;
  Icon checkIcon;
  String text;
  Color color;
  String attributeId, name, recipName, email, recipEmail, message, productName;

  // double width;
  bool isTrue;

  bool isProductAttributeAvail;
  bool isGiftCard;

  // final fontSize;
  String categoryId;

  @override
  _AddCartBtnState createState() => _AddCartBtnState();
}

class _AddCartBtnState extends State<AddCartBtn> {
  late AddToCartButtonStateId stateId;

  // var checkedIcon;
  //This is for Cart Badge
  var warning;
 String bogoCatId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stateId = AddToCartButtonStateId.idle;
    final provider = Provider.of<NewApisProvider>(context,listen:false);
    provider.setBogoCategoryValue();
    setState(() {
      bogoCatId = provider.bogoValue;
    });
    getGuid();
  }

  final cartCounte = CartCounter();

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Container(
      color: widget.color,
      child: AddToCartButton(
        backgroundColor: widget.color,
        stateId: stateId,
        trolley: widget.isTrue == true
            ? Icon(
                Icons.shopping_cart,
                size: 18,
                color: widget.color,
              )
            : Container(color: Colors.black),
        text: AutoSizeText(
          widget.text,
          style: TextStyle(
            fontSize: 4.w,
          ),
        ),
        check: widget.checkIcon,
        onPressed: (id) => checkStateId(stateId, currentFocus),
      ),
    );
  }

  void checkStateId(




      AddToCartButtonStateId id, FocusScopeNode currentFocus) async {
    log('Parent CategoryId>>>>>>'+widget.categoryId+ '>>>>>>'+bogoCatId);
    // FirebaseAnalytics analytics =
    //     Provider.of<FirebaseAnalytics>(context, listen: false);
    // await analytics.logAddToCart(
    //   items: [
    //     AnalyticsEventItem(
    //       itemName: widget.productName,
    //       itemId: widget.productId.toString(),
    //       price: widget.productPrice,
    //       quantity: 1,
    //       currency: 'AED',
    //     )
    //   ],
    //   currency: 'AED',
    //   value: widget.productPrice,
    // );
    // // bool giftCardAvail = false;
    // FacebookAppEvents().logAddToCart(
    //   content: {
    //     'fb_content_id': widget.productId,
    //     'fb_content_type': 'product',
    //     'fb_currency': 'AED',
    //   },
    //   type: 'Add to cart',
    //   price: widget.productPrice,
    //   id: widget.productId.toString(),
    //   currency: 'AED',
    // ).then((value) => print('log event'));
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (id == AddToCartButtonStateId.idle) {
      //handle logic when pressed on idle state button.
      if (widget.guestCustomerId != null || widget.guestCustomerId != '') {
        if (widget.isGiftCard == true &&
            widget.recipEmail.trim().isEmpty &&
            widget.recipName.trim().isEmpty &&
            widget.name.trim().isEmpty &&
            widget.email.trim().isEmpty) {
          Fluttertoast.showToast(
              msg:
                  'Please Provide following Fields:\nRecipient\'s Name,\nRecipient\'s Email,\nSender Name,\nSender Email.');
        } else if (widget.isGiftCard == true &&
            widget.recipName.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please Provide Recipient\'s Name.');
          // setState(()=>giftCardAvail =)
        } else if (widget.isGiftCard == true &&
            widget.recipEmail.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please Provide Recipient\'s Email.');
        }
        // if (widget.recipEmail.trim().length == 0) {}
        else if (widget.isGiftCard == true && widget.name.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please Provide Sender Name.');
        } else if (widget.isGiftCard == true && widget.email.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please Provide Sender Email.');
        } else if (widget.isGiftCard == true &&
            widget.recipEmail.trim().isNotEmpty &&
            widget.recipName.trim().isNotEmpty &&
            widget.name.trim().isNotEmpty &&
            widget.email.trim().isNotEmpty) {
          setState(
            () {
              stateId = AddToCartButtonStateId.loading;
              AddToCartResponse result;
              Future.delayed(Duration(seconds: 0)).then(
                (value) async => ApiCalls.addToCart(
                  context: context,
                  baseUrl: await ApiCalls.getSelectedStore(),
                  storeId:
                      await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
                  productId: widget.productId,
                  message: widget.message,
                  email: widget.email,
                  recipEmail: widget.recipEmail,
                  recipName: widget.recipName,
                  name: widget.name,
                  attributeId: widget.attributeId, quantity: widget.minQuantity,
                ).then(
                  (response) async {
                    AnalyticsEventItem item = AnalyticsEventItem(
                        itemName: widget.productName,
                        currency: 'AED',
                        quantity: int.parse(widget.minQuantity),
                        itemId: widget.productId.toString());

                    // final
                    final _provider =
                        Provider.of<NewApisProvider>(context, listen: false);
                    _provider.getCurrency();
                    log(_provider.currency);
                    FirebaseEvents.initialize(context: context)
                        .sendAddToCart(
                          currency: _provider.currency,
                          itemName: widget.productName,
                          itemId: widget.productId,
                          price: widget.productPrice,
                        )
                        .whenComplete(
                          () => log("Firebase add to cart event complete"),
                        );
                    FacebookEvents()
                        .sendAddToCartEvent(
                          productId: widget.productId,
                          type: "Add to cart event",
                          currency: _provider.currency,
                          price: widget.productPrice,
                        )
                        .whenComplete(
                          () => log("Facebook event complete"),
                        );
                    setState(
                      () {
                        stateId = AddToCartButtonStateId.done;
                        Future.delayed(
                          Duration(seconds: 1),
                          () {
                            setState(
                              () {
                                stateId = AddToCartButtonStateId.idle;
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        } else {
          setState(
            () {
              stateId = AddToCartButtonStateId.loading;
              AddToCartResponse result;
              Future.delayed(const Duration(seconds: 0)).then(
                (value) async => ApiCalls.addToCart(
                  context: context,
                  baseUrl: await ApiCalls.getSelectedStore(),
                  storeId:
                      await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
                  productId: widget.productId,
                  message: widget.message,
                  email: widget.email,
                  recipEmail: widget.recipEmail,
                  recipName: widget.recipName,
                  name: widget.name,
                  attributeId: widget.attributeId,
                  quantity: widget.minQuantity
                ).then(
                  (response) async {
                    final _provider =
                        Provider.of<NewApisProvider>(context, listen: false);
                    _provider.getCurrency();
                    log(_provider.currency);
                    FirebaseEvents.initialize(context: context)
                        .sendAddToCart(
                          currency: _provider.currency,
                          itemName: widget.productName,
                          itemId: widget.productId,
                          price: widget.productPrice,
                        )
                        .whenComplete(
                          () => log("Firebase add to cart event complete"),
                        );
                    FacebookEvents()
                        .sendAddToCartEvent(
                          productId: widget.productId,
                          type: "Add to cart event",
                          currency: _provider.currency,
                          price: widget.productPrice,
                        )
                        .whenComplete(
                          () => log("Facebook event complete"),
                        );
                    setState(
                      () {
                        stateId = AddToCartButtonStateId.done;
                        Future.delayed(
                          Duration(seconds: 1),
                          () {
                            setState(
                              () {
                                stateId = AddToCartButtonStateId.idle;
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      } else {}
    } else if (id == AddToCartButtonStateId.done) {
      //handle logic when pressed on done state button.
      setState(() {
        stateId = AddToCartButtonStateId.idle;
      });
    }
  }

  void getGuid() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }
}
