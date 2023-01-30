import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as b;
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/Categories/DiscountxxWidget.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/ContactsUS/ContactsUS.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Slider.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../../../new_apis_func/data_layer/constant_data/constant_data.dart';

class NewProductDetails extends StatefulWidget {
  const NewProductDetails(
      {Key? key, required String productId, required String screenName})
      : _productId = productId,
        super(key: key);
  final String _productId;

  @override
  _NewProductDetailsState createState() => _NewProductDetailsState();
}

class _NewProductDetailsState extends State<NewProductDetails>
    with InputValidationMixin {
  var isWishListed = false;

  var _preSelected;

  List<String> searchSuggestions = [];
  var visible;
  var indVisibility;
  var snapshot;
  var customerId;
  var guestCustomerID;
  var productID;
  var name = '';
  var description = '';
  var price = '';
  double? priceValue;
  var discountedPrice = '';
  bool isDiscountAvail = false;
  var sku;
  var stockAvailabilty = '';
  var image1;
  var image2;
  var image3;
  var id;
  String discountPercentage = '';
  List<String> imageList = [];
  List<String> largeImage = [];
  var connectionStatus;
  bool isScroll = true;
  var assemblyCharges;
  FocusNode yourfoucs = FocusNode();

  // bool showSubBtn = false;

  String subBtnName = 'Notify Me!';
  var apiToken;
  final List<GiftCardModel> _giftCardPriceList = [];
  final List<String> _selectedList = [];
  var customerGuid;
  bool isExtra = false;
  String _attributeText = '';
  bool isListIdSelected = false;

  bool isShown = false;

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();
  var _provider = NewApisProvider();
  var isVisible = false;

  Color btnColor = Colors.black;

  final _suggestController = ScrollController();
  String productAttributeName = '';

  GroupController? _groupController;

  var data = '';

  bool _isGiftCard = false, _isProductAttributeAvailable = false;

  final TextEditingController _messageController = TextEditingController();

  TextEditingController recEmailController = TextEditingController();

  final TextEditingController _yourEmailController = TextEditingController();
  final TextEditingController _yourNameController = TextEditingController();
  final TextEditingController _recNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // getInstance();
    if (mounted)
      ApiCalls.saveRecentProduct(productId: widget._productId.toString());
    setState(() {
      _groupController = GroupController(
          isMultipleSelection: true, initSelectedItem: _selectedList);
      productID = widget._productId;
      guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
      customerGuid = ConstantsVar.prefs.getString('guestGUID');
      apiToken = ConstantsVar.prefs.getString('apiTokken');
    });

    _provider = Provider.of<NewApisProvider>(context, listen: false);
    _provider
        .getProductDetail(productId: widget._productId, customerId: customerId)
        .whenComplete(() {
      if (_provider.loading == false) {
        for (int i = 0;
            i <= _provider.productResponse.pictureModels.length - 1;
            i++) {}

        discountedPrice =
            _provider.productResponse.productPrice.priceWithDiscount;
        discountedPrice != null
            ? isDiscountAvail = true
            : isDiscountAvail = false;
        id = _provider.productResponse.id;
        name = _provider.productResponse.name;
        isWishListed = _provider.productResponse.isWishlisted;
        description = _provider.productResponse.shortDescription;
        price = _provider.productResponse.productPrice.price;
        priceValue = double.parse(
            _provider.productResponse.productPrice.priceValue.toString());
        sku = _provider.productResponse.sku;
        stockAvailabilty = _provider.productResponse.stockAvailability;
        discountPercentage = _provider.productResponse.discountPercentage;
        _isGiftCard = _provider.productResponse.giftCard.isGiftCard;

        if (_provider.productResponse.productAttributes!.isNotEmpty) {
          isExtra = true;
          productAttributeName =
              _provider.productResponse.productAttributes![0].name;
          if (_provider
              .productResponse.productAttributes![0].values.isNotEmpty) {
            String _xyz = ' included \n' '[' +
                _provider.productResponse.productAttributes![0].values[0]
                    .priceAdjustment +
                ']';
            _attributeText = productAttributeName + _xyz;
            _preSelected = _provider
                .productResponse.productAttributes![0].values[0].isPreSelected;
          }

          for (int i = 0;
              i < _provider.productResponse.productAttributes![0].values.length;
              i++) {
            _giftCardPriceList.add(
              GiftCardModel(
                name: _provider
                        .productResponse.productAttributes![0].values[i].name +
                    '[${_provider.productResponse.productAttributes![0].values[i].priceAdjustment}]',
                id: _provider.productResponse.productAttributes![0].values[i].id
                    .toString(),
              ),
            );
          }

          if (_provider.productResponse.giftCard.isGiftCard == true) {}
        } else {
          assemblyCharges = '';
          _attributeText = '';
          _preSelected = false;
        }

        // Provider.of<FirebaseAnalytics>(
        //   context,
        //   listen: false,
        // ).
        // logViewItem(
        //   currency: 'AED',
        //   value: _provider.productResponse.productPrice.priceValue,
        //   items: [
        //     AnalyticsEventItem(
        //       itemId: widget._productId,
        //       itemName: _provider.productResponse.name,
        //     )
        //   ],
        // );

        _provider.getCurrency();
        log(_provider.currency);

        /*Firebase Event*/
        final _fireEvents = FirebaseEvents.initialize(context: context);
        _fireEvents
            .sendScreenViewData(screenName: "Product Details Screen")
            .whenComplete(
              () => _fireEvents.sendViewItemData(
                value: _provider.productResponse.productPrice.priceValue ?? 0.0,
                currency: _provider.currency ?? "No Info available",
                items: [
                  AnalyticsEventItem(
                    itemName:
                        _provider.productResponse.name ?? "No info available",
                    itemId: widget._productId ?? "No id available",
                  )
                ],
              ),
            )
            .whenComplete(
              () => log("Firebase Event Complete both"),
            );

        /*Facebook Events*/

        final _fbEvents = FacebookEvents();

        _fbEvents.sendScreenViewData(
          type: "Product Screen",
          id: _provider.productResponse.id.toString(),
        );

        setState(() {});
      }
    });

    setState(() {
      searchSuggestions = _provider.searchSuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: InkWell(
                  radius: 48,
                  child: Consumer<CartCounter>(
                    builder: (context, value, child) {
                      return b.Badge(
                        position: b.BadgePosition.topEnd(),
                        badgeColor: Colors.white,
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
                        isOtherScren: true,
                        otherScreenName: 'Product Screen',
                      ),
                    ),
                  ),
                ),
              )
            ],
            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            centerTitle: true,
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
          body: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.direction <= 0 && Platform.isIOS) {
                Navigator.pop(context);
              }
            },
            onTap: () {
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: ConstantsVar.appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: RawAutocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return searchSuggestions.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          debugPrint('$selection selected');
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          _searchController = textEditingController;
                          _focusNode = focusNode;
                          // FocusScopeNode currentFocus = FocusScopeNode.of(context);
                          return TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            onFieldSubmitted: (val) {
                              focusNode.unfocus();
                              if (currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (mounted) {
                                setState(() {
                                  var value = _searchController.text;
                                  Navigator.of(context)
                                      .push(
                                        CupertinoPageRoute(
                                          builder: (context) => SearchPage(
                                            isScreen: true,
                                            keyword: value,
                                            enableCategory: false,
                                            cartIconVisible: true,
                                          ),
                                        ),
                                      )
                                      .then((value) => setState(() {
                                            _searchController.text = '';
                                          }));
                                });
                              }
                            },
                            textInputAction: isVisible
                                ? TextInputAction.done
                                : TextInputAction.search,
                            // keyboardType: TextInputType.,
                            keyboardAppearance: Brightness.light,
                            // autofocus: true,
                            onChanged: (_) => setState(() {
                              btnColor = ConstantsVar.appColor;
                            }),
                            controller: _searchController,
                            style:
                                TextStyle(color: Colors.black, fontSize: 5.w),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 10),
                              hintText: 'Search here',
                              labelStyle:
                                  TextStyle(fontSize: 7.w, color: Colors.grey),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  focusNode.unfocus();

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  if (mounted) {
                                    setState(() {
                                      var value = _searchController.text;
                                      Navigator.of(context)
                                          .push(
                                            CupertinoPageRoute(
                                              builder: (context) => SearchPage(
                                                isScreen: true,
                                                keyword: value,
                                                enableCategory: false,
                                                cartIconVisible: true,
                                              ),
                                            ),
                                          )
                                          .then((value) => setState(() {
                                                _searchController.clear();
                                              }));
                                    });
                                  }
                                },
                                child: const Icon(Icons.search_sharp),
                              ),
                            ),
                            focusNode: _focusNode,
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              right: 10,
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Material(
                                child: Card(
                                  child: SizedBox(
                                    height: 178,
                                    child: Scrollbar(
                                      controller: _suggestController,
                                      thickness: 5,
                                      isAlwaysShown: true,
                                      child: ListView.builder(
                                        // padding: EdgeInsets.all(8.0),
                                        itemCount: options.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index >= options.length) {
                                            return Align(
                                              alignment: Alignment.bottomCenter,
                                              child: TextButton(
                                                child: const Text(
                                                  'Clear',
                                                  style: TextStyle(
                                                    color:
                                                        ConstantsVar.appColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _searchController.clear();
                                                },
                                              ),
                                            );
                                          }
                                          final String option =
                                              options.elementAt(index);
                                          return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            SearchPage(
                                                              keyword: option,
                                                              isScreen: true,
                                                              enableCategory:
                                                                  false,
                                                              cartIconVisible:
                                                                  true,
                                                            ))).then((value) =>
                                                    _searchController.clear());
                                              },
                                              child: SizedBox(
                                                height: 5.2.h,
                                                width: 95.w,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 100.w,
                                                      child: AutoSizeText(
                                                        '  ' + option,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          wordSpacing: 2,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 100.w,
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   // flex: 9,
                //   child:
                //   customList(
                //     context: context,
                //     name: name,
                //     price: price,
                //     descritption: description,
                //     priceValue: '$priceValue',
                //     sku: sku,
                //     stockAvaialbility: stockAvailabilty,
                //     imageList: imageList,
                //     largeImage: largeImage,
                //     assemblyCharges: assemblyCharges,
                //     initialData: initialDatas!,
                //     isDiscountAvail: isDiscountAvail,
                //     discountedPrice:
                //         discountedPrice != null ? discountedPrice : '',
                //     disPercentage: discountPercentage,
                //     showSub: showSubBtn,
                //     isSubAlready:
                //         initialDatas!.subscribedToBackInStockSubscription,
                //   ),
                // ),
                Expanded(
                  child: Consumer<NewApisProvider>(
                    builder: (_, value, c) {
                      if (value.loading == true) {
                        return const Center(
                          child: SpinKitRipple(
                            color: ConstantsVar.appColor,
                            size: 40,
                          ),
                        );
                      } else {
                        if (value.isProductDetailScreenError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 26.w,
                                  backgroundImage: const AssetImage(
                                    'MyAssets/cry_emoji.gif',
                                  ),
                                  // child: Image.asset(
                                  //   'MyAssets/cry_emoji.gif',
                                  //   fit: BoxFit.fill,
                                  //   width: 50.w,
                                  //   height: 25.h,
                                  // ),
                                ),
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
                                  onPressed: () async => await _provider
                                      .getProductDetail(
                                          productId: widget._productId,
                                          customerId: customerId)
                                      .whenComplete(() {
                                    if (_provider.loading == false) {
                                      for (int i = 0;
                                          i <=
                                              _provider.productResponse
                                                      .pictureModels.length -
                                                  1;
                                          i++) {}

                                      discountedPrice = _provider
                                          .productResponse
                                          .productPrice
                                          .priceWithDiscount;
                                      discountedPrice != null
                                          ? isDiscountAvail = true
                                          : isDiscountAvail = false;
                                      id = _provider.productResponse.id;
                                      name = _provider.productResponse.name;
                                      isWishListed = _provider
                                          .productResponse.isWishlisted;
                                      description = _provider
                                          .productResponse.shortDescription;
                                      price = _provider
                                          .productResponse.productPrice.price;
                                      priceValue = double.parse(_provider
                                          .productResponse
                                          .productPrice
                                          .priceValue
                                          .toString());
                                      sku = _provider.productResponse.sku;
                                      stockAvailabilty = _provider
                                          .productResponse.stockAvailability;
                                      discountPercentage = _provider
                                          .productResponse.discountPercentage;
                                      _isGiftCard = _provider
                                          .productResponse.giftCard.isGiftCard;

                                      if (_provider.productResponse
                                          .productAttributes!.isNotEmpty) {
                                        isExtra = true;
                                        productAttributeName = _provider
                                            .productResponse
                                            .productAttributes![0]
                                            .name;
                                        if (_provider
                                            .productResponse
                                            .productAttributes![0]
                                            .values
                                            .isNotEmpty) {
                                          String _xyz = ' included \n' '[' +
                                              _provider
                                                  .productResponse
                                                  .productAttributes![0]
                                                  .values[0]
                                                  .priceAdjustment +
                                              ']';
                                          _attributeText =
                                              productAttributeName + _xyz;
                                          _preSelected = _provider
                                              .productResponse
                                              .productAttributes![0]
                                              .values[0]
                                              .isPreSelected;
                                        }

                                        for (int i = 0;
                                            i <
                                                _provider
                                                    .productResponse
                                                    .productAttributes![0]
                                                    .values
                                                    .length;
                                            i++) {
                                          _giftCardPriceList.add(
                                            GiftCardModel(
                                              name: _provider
                                                      .productResponse
                                                      .productAttributes![0]
                                                      .values[i]
                                                      .name +
                                                  '[${_provider.productResponse.productAttributes![0].values[i].priceAdjustment}]',
                                              id: _provider
                                                  .productResponse
                                                  .productAttributes![0]
                                                  .values[i]
                                                  .id
                                                  .toString(),
                                            ),
                                          );
                                        }

                                        if (_provider.productResponse.giftCard
                                                .isGiftCard ==
                                            true) {
                                          // setState(() {
                                          //   isExtra = true;
                                          //   productAttributeName =
                                          //       initialData.productAttributes![0].name.toString();
                                          // });
                                        }
                                      } else {
                                        assemblyCharges = '';
                                        _attributeText = '';
                                        _preSelected = false;
                                      }

                                      // Provider.of<FirebaseAnalytics>(
                                      //   context,
                                      //   listen: false,
                                      // ).logViewItem(
                                      //   currency: 'AED',
                                      //   value: _provider.productResponse
                                      //       .productPrice.priceValue,
                                      //   items: [
                                      //     AnalyticsEventItem(
                                      //       itemId: widget._productId,
                                      //       itemName:
                                      //           _provider.productResponse.name,
                                      //     )
                                      //   ],
                                      // );
                                      setState(() {});
                                    }
                                  }),
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            height: 100.h,
                            width: 100.w,
                            child: ListView(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SliderClass(
                                    overview:
                                        value.productResponse.fullDescription,
                                    productUrl:
                                        value.productResponse.productUrl,
                                    apiToken: apiToken,
                                    customerId: guestCustomerID,
                                    isWishlisted: isWishListed,
                                    productName: value.productResponse.name,
                                    largeImage: largeImage,
                                    images: value.productResponse.pictureModels,
                                    setState: () {},
                                    context: context,
                                    productId: widget._productId.toString(),
                                    discountPercentage: value
                                        .productResponse.discountPercentage,
                                    senderEmail: _yourEmailController.text,
                                    receiverEmail: recEmailController.text,
                                    recevierName: _recNameController.text,
                                    senderName: _yourNameController.text,
                                    message: _messageController.text,
                                    isGiftCard: _isGiftCard,
                                    attributeId: data,
                                    productPrice: value.productResponse
                                        .productPrice.priceValue,
                                    categoryId:
                                        value.productResponse.parentCategoryId,
                                    minQuantity: value
                                        .productResponse.minimumQuantity
                                        .toString(),
                                  ),
                                ),
                                FittedBox(
                                  child: Container(
                                    height: 30.h,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    width: MediaQuery.of(context).size.width,
                                    color: const Color.fromARGB(
                                        255, 234, 235, 235),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText(
                                          value.productResponse.name,
                                          maxLines: 1,
                                          style: TextStyle(
                                            wordSpacing: .5,
                                            letterSpacing: .4,
                                            fontSize: 6.7.w,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              value.productResponse
                                                  .shortDescription,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 5.w,
                                                color: Colors.grey.shade700,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(
                                              width: 100.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AutoSizeText(
                                                    'SKU: ' +
                                                        value.productResponse
                                                            .sku,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 5.w,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Visibility(
                                                    visible: isExtra,
                                                    child: _preSelected == false
                                                        ? InkWell(
                                                            onTap: () async {
                                                              showModalBottomSheet<
                                                                  dynamic>(
                                                                // context and builder are
                                                                // required properties in this widget
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  // we set up a container inside which
                                                                  // we create center column and display text
                                                                  return SizedBox(
                                                                    width:
                                                                        100.w,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.65,

                                                                    // height: 60.h,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 6.0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            productAttributeName,
                                                                            maxLines:
                                                                                1,
                                                                            maxFontSize:
                                                                                18,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Scrollbar(
                                                                            isAlwaysShown:
                                                                                true,
                                                                            child:
                                                                                ListView(
                                                                              children: [
                                                                                SimpleGroupedCheckbox<String>(
                                                                                  isLeading: true,
                                                                                  itemsTitle: _giftCardPriceList.map((e) => e.name).toList(),
                                                                                  controller: _groupController!,
                                                                                  values: _giftCardPriceList.map((e) => e.id).toList(),
                                                                                  onItemSelected: (val) {
                                                                                    _selectedList.clear();
                                                                                    _selectedList.addAll(val);
                                                                                    data = '';
                                                                                    data = _groupController!.selectedItem.join(",");

                                                                                    setState(() {});
                                                                                  },
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          if (mounted) {
                                                                                            Future.delayed(Duration.zero).then((value) => setState(() {
                                                                                                  _groupController!.deselectAll();
                                                                                                  data = '';
                                                                                                  _selectedList.clear();
                                                                                                }));
                                                                                          }
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                                                                          width: 30.w,
                                                                                          height: 35,
                                                                                          child: const Center(child: Text('Cancel')),
                                                                                        ),
                                                                                        // color: Colors.transparent,
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                                                                          width: 30.w,
                                                                                          height: 35,
                                                                                          child: const Center(child: Text('Apply')),
                                                                                        ),
                                                                                        // color: Colors.transparent,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 4.6.h,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      4.0,
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                    productAttributeName,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: ConstantsVar
                                                                      .appColor,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Visibility(
                                                            visible:
                                                                _attributeText ==
                                                                        ''
                                                                    ? false
                                                                    : true,
                                                            child: Container(
                                                              height: 4.6.h,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 2,
                                                                  horizontal: 2,
                                                                ),
                                                                child:
                                                                    AutoSizeText(
                                                                  _attributeText,
                                                                  wrapWords:
                                                                      true,
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 2,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: ConstantsVar
                                                                      .appColor,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 100.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'Availability: ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 5.w,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: value
                                                                .productResponse
                                                                .stockAvailability,
                                                            style: TextStyle(
                                                                fontSize: 5.w,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: value
                                                        .productResponse
                                                        .displayBackInStockSubscription,
                                                    child: InkWell(
                                                      focusColor:
                                                          ConstantsVar.appColor,
                                                      radius: 48,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      splashColor:
                                                          ConstantsVar.appColor,
                                                      onTap: () {
                                                        ApiCalls.subscribeProdcut(
                                                                productId: widget
                                                                    ._productId
                                                                    .toString(),
                                                                customerId:
                                                                    guestCustomerID,
                                                                apiToken:
                                                                    apiToken)
                                                            .then((value) =>
                                                                setState(() {
                                                                  subBtnName =
                                                                      value;
                                                                }));
                                                      },
                                                      child: Ink(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Card(
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    8),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(value
                                                                          .productResponse
                                                                          .subscribedToBackInStockSubscription ==
                                                                      false
                                                                  ? subBtnName
                                                                  : subBtnName),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: assemblyCharges == null
                                                  ? false
                                                  : true,
                                              child: AutoSizeText(
                                                assemblyCharges ?? '',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 5.w,
                                                  color: Colors.grey.shade700,
                                                  letterSpacing: 1,
                                                  wordSpacing: 2,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0),
                                                child: discountWidget(
                                                    actualPrice: value
                                                        .productResponse
                                                        .productPrice
                                                        .price,
                                                    fontSize: 3.6.w,
                                                    width: 50.w,
                                                    isSpace: !isDiscountAvail),
                                              ),
                                              SizedBox(
                                                width: 100.w,
                                                child: AutoSizeText(
                                                  value
                                                          .productResponse
                                                          .productPrice
                                                          .priceWithDiscount ??
                                                      value.productResponse
                                                          .productPrice.price,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 7.w,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey.shade700,
                                                    letterSpacing: 1,
                                                    wordSpacing: 2,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _isGiftCard,
                                  child: addVerticalSpace(15),
                                ),
                                Visibility(
                                  visible: _isGiftCard,
                                  child: SizedBox(
                                    width: 100.w,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3,
                                            ),
                                            child: TextFormField(
                                              validator: (email) {
                                                return null;

                                                // if (isEmailValid(email!))
                                                //   return null;
                                                // else
                                                //   return 'Enter a valid email address';
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: _recNameController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const OutlineInputBorder(),

                                                labelStyle: TextStyle(
                                                  fontSize: 3.5.w,
                                                ),
                                                // color:
                                                // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
                                                labelText: 'RECIPIENT\'S NAME:',
                                                border:
                                                    const OutlineInputBorder(),
                                                counterText: '',
                                              ),
                                            ),
                                          ),
                                          addVerticalSpace(14),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            child: TextFormField(
                                              validator: (email) {
                                                return null;

                                                // if (isEmailValid(email!))
                                                //   return null;
                                                // else
                                                //   return 'Enter a valid email address';
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: recEmailController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const OutlineInputBorder(),

                                                labelStyle: TextStyle(
                                                  fontSize: 3.5.w,
                                                ),
                                                // color:
                                                // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
                                                labelText:
                                                    'RECIPIENT\'S EMAIL:',
                                                border:
                                                    const OutlineInputBorder(),
                                                counterText: '',
                                              ),
                                            ),
                                          ),
                                          addVerticalSpace(14),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            child: TextFormField(
                                              validator: (email) {
                                                return null;

                                                // if (isEmailValid(email!))
                                                //   return null;
                                                // else
                                                //   return 'Enter a valid email address';
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: _yourNameController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const OutlineInputBorder(),

                                                labelStyle: TextStyle(
                                                  fontSize: 3.5.w,
                                                ),
                                                // color:
                                                // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
                                                labelText: 'YOUR NAME:',
                                                border:
                                                    const OutlineInputBorder(),
                                                counterText: '',
                                              ),
                                            ),
                                          ),
                                          addVerticalSpace(14),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            child: TextFormField(
                                              validator: (email) {
                                                return null;

                                                // if (isEmailValid(email!))
                                                //   return null;
                                                // else
                                                //   return 'Enter a valid email address';
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: _yourEmailController,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const OutlineInputBorder(),

                                                labelStyle: TextStyle(
                                                  fontSize: 3.5.w,
                                                ),
                                                // color:
                                                // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
                                                labelText: 'YOUR EMAIL:',
                                                border:
                                                    const OutlineInputBorder(),
                                                counterText: '',
                                              ),
                                            ),
                                          ),
                                          addVerticalSpace(14),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            child: TextFormField(
                                                validator: (val) {
                                                  return null;

                                                  // if (isAddress(val!.trim()))
                                                  //   return null;
                                                  // else
                                                  //   return 'Enter your address';
                                                },
                                                textInputAction:
                                                    TextInputAction.newline,
                                                maxLines: 3,
                                                // autovalidateMode: AutovalidateMode.onUserInteraction,
                                                controller: _messageController,
                                                cursorColor: Colors.black,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                decoration: InputDecoration(
                                                    counterText: '',
                                                    labelStyle: TextStyle(
                                                        fontSize: 5.w,
                                                        color: Colors.grey),
                                                    labelText: 'Message',
                                                    border:
                                                        const OutlineInputBorder())),
                                          ),
                                          addVerticalSpace(14),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const Divider(
                                    thickness: 2,
                                  ),
                                ),
                                ExpandablePanel(
                                  header: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: AutoSizeText(
                                      'OVERVIEW',
                                      style: TextStyle(
                                        fontSize: 4.w,
                                      ),
                                    ),
                                  ),
                                  collapsed: const Text(
                                    '',
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: HtmlWidget(
                                        value.productResponse.fullDescription,
                                        onTapUrl: (url) async {
                                          if (url.contains(
                                              'terms-and-conditions-for-on-line-accessory-styling-service')) {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => TopicPage(
                                                    screenName: ConstantsVar
                                                            .prefs
                                                            .getString(
                                                                'guestGUID') ??
                                                        '',
                                                    paymentUrl:
                                                        'https://www.theone.com/terms-and-conditions-for-online-accessory-styling-service-app'),
                                              ),
                                            );
                                          } else if (url.contains(
                                              'terms-and-conditions-for-online-furniture-styling-service-by-the-one-total-home-experience-llc')) {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => TopicPage(
                                                  paymentUrl:
                                                      'https://www.theone.com/terms-and-conditions-for-online-furniture-styling-service-by-the-one-total-home-experience-llc-app',
                                                  screenName: ConstantsVar.prefs
                                                          .getString(
                                                              'guestGUID') ??
                                                      '',
                                                ),
                                              ),
                                            );
                                          } else {
                                            ApiCalls.launchUrl(url);
                                          }
                                          return true;
                                        },
                                        // textStyle: GoogleFonts.architectsDaughter(),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ContactUS(
                                          id: sku,
                                          name: name,
                                          desc: description,
                                          boolValue: true,
                                        ),
                                      )),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border.symmetric(
                                            horizontal: BorderSide(
                                                width: 1,
                                                color: Colors.black))),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 13.0),
                                      child: Text('CONTACT US'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  child: AddCartBtn(
                                    productId: id.toString(),
                                    isTrue: false,
                                    guestCustomerId: guestCustomerID,
                                    checkIcon: stockAvailabilty
                                            .toString()
                                            .contains('Out of stock')
                                        ? const Icon(HeartIcon.cross)
                                        : const Icon(Icons.check),
                                    text: stockAvailabilty
                                            .toString()
                                            .contains('Out of stock')
                                        ? 'out of stock'.toUpperCase()
                                        : 'add to cart'.toUpperCase(),
                                    color: stockAvailabilty
                                            .toString()
                                            .contains('Out of stock')
                                        ? Colors.grey.shade700
                                        : ConstantsVar.appColor,
                                    isGiftCard: _isGiftCard,
                                    isProductAttributeAvail:
                                        _isProductAttributeAvailable,
                                    recipEmail: recEmailController.text,
                                    name: _yourNameController.text,
                                    message: _messageController.text,
                                    attributeId: data,
                                    recipName: _recNameController.text,
                                    email: _yourEmailController.text,
                                    productName: value.productResponse.name,
                                    minQuantity: value
                                        .productResponse.minimumQuantity
                                        .toString(),
                                    productPrice: value.productResponse
                                        .productPrice.priceValue,
                                    storeId: '',
                                    categoryId:
                                        value.productResponse.parentCategoryId,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  ScreenshotController screenshotController = ScreenshotController();

  // Widget customList({
  //   required BuildContext context,
  //   required String name,
  //   required bool isDiscountAvail,
  //   required String discountedPrice,
  //   required String descritption,
  //   required String sku,
  //   required String stockAvaialbility,
  //   required String price,
  //   required String priceValue,
  //   required List<String> imageList,
  //   required List<String> largeImage,
  //   required String assemblyCharges,
  //   required dynamic initialData,
  //   required String disPercentage,
  //   required bool showSub,
  //   required bool isSubAlready,
  // }) {
  //   return ListView(
  //     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(6.0),
  //         child: Container(
  //             child: SliderClass(
  //           myKey: screenshotController,
  //           overview: initialDatas!.fullDescription,
  //           productUrl: initialDatas!.productUrl,
  //           apiToken: apiToken,
  //           customerId: guestCustomerID,
  //           isWishlisted: isWishListed,
  //           productName: initialDatas!.name,
  //           largeImage: largeImage,
  //           images: imageList,
  //           setState: () {},
  //           context: context,
  //           productId: widget._productId.toString(),
  //           discountPercentage: initialDatas!.discountPercentage,
  //           senderEmail: _yourEmailController.text,
  //           receiverEmail: recEmailController.text,
  //           recevierName: _recNameController.text,
  //           senderName: _yourNameController.text,
  //           message: _messageController.text,
  //           isGiftCard: _isGiftCard,
  //           attributeId: data,
  //           productPrice: initialDatas!.productPrice.priceValue,
  //         )),
  //       ),
  //       Container(
  //         height: 30.h,
  //         width: MediaQuery.of(context).size.width,
  //         color: const Color.fromARGB(255, 234, 235, 235),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.max,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               AutoSizeText(
  //                 name,
  //                 maxLines: 1,
  //                 style: TextStyle(
  //                   wordSpacing: .5,
  //                   letterSpacing: .4,
  //                   fontSize: 6.7.w,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 textAlign: TextAlign.start,
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   AutoSizeText(
  //                     descritption,
  //                     maxLines: 1,
  //                     style: TextStyle(
  //                       fontSize: 5.w,
  //                       color: Colors.grey.shade700,
  //                     ),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                   SizedBox(
  //                     width: 100.w,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         AutoSizeText(
  //                           'SKU: $sku',
  //                           maxLines: 1,
  //                           style: TextStyle(
  //                             fontSize: 5.w,
  //                             color: Colors.grey.shade700,
  //                           ),
  //                           textAlign: TextAlign.start,
  //                         ),
  //                         Visibility(
  //                           visible: isExtra,
  //                           child: _preSelected == false
  //                               ? InkWell(
  //                                   onTap: () async {
  //                                     showModalBottomSheet<dynamic>(
  //                                       // context and builder are
  //                                       // required properties in this widget
  //                                       context: context,
  //                                       isScrollControlled: true,
  //                                       builder: (BuildContext context) {
  //                                         // we set up a container inside which
  //                                         // we create center column and display text
  //                                         return SizedBox(
  //                                           width: 100.w,
  //                                           height: MediaQuery.of(context)
  //                                                   .size
  //                                                   .height *
  //                                               0.65,
  //
  //                                           // height: 60.h,
  //                                           child: Column(
  //                                             mainAxisSize: MainAxisSize.min,
  //                                             children: [
  //                                               Padding(
  //                                                 padding: const EdgeInsets
  //                                                     .symmetric(vertical: 6.0),
  //                                                 child: AutoSizeText(
  //                                                   productAttributeName,
  //                                                   maxLines: 1,
  //                                                   maxFontSize: 18,
  //                                                   style: const TextStyle(
  //                                                     fontSize: 18,
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               Expanded(
  //                                                 flex: 1,
  //                                                 child: Scrollbar(
  //                                                   isAlwaysShown: true,
  //                                                   child: ListView(
  //                                                     children: [
  //                                                       SimpleGroupedCheckbox<
  //                                                           String>(
  //                                                         isLeading: true,
  //                                                         itemsTitle:
  //                                                             _giftCardPriceList
  //                                                                 .map((e) =>
  //                                                                     e.name)
  //                                                                 .toList(),
  //                                                         controller:
  //                                                             _groupController!,
  //                                                         values:
  //                                                             _giftCardPriceList
  //                                                                 .map((e) =>
  //                                                                     e.id)
  //                                                                 .toList(),
  //                                                         onItemSelected:
  //                                                             (val) {
  //                                                           _selectedList
  //                                                               .clear();
  //                                                           _selectedList
  //                                                               .addAll(val);
  //                                                           data = '';
  //                                                           data =
  //                                                               _groupController!
  //                                                                   .selectedItem
  //                                                                   .join(",");
  //
  //                                                           setState(() {});
  //                                                         },
  //                                                       ),
  //                                                       Padding(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                     .symmetric(
  //                                                                 vertical:
  //                                                                     8.0),
  //                                                         child: Row(
  //                                                           mainAxisSize:
  //                                                               MainAxisSize
  //                                                                   .max,
  //                                                           mainAxisAlignment:
  //                                                               MainAxisAlignment
  //                                                                   .spaceEvenly,
  //                                                           children: [
  //                                                             InkWell(
  //                                                               onTap: () {
  //                                                                 if (mounted) {
  //                                                                   Future.delayed(Duration
  //                                                                           .zero)
  //                                                                       .then((value) =>
  //                                                                           setState(() {
  //                                                                             _groupController!.deselectAll();
  //                                                                             data = '';
  //                                                                             _selectedList.clear();
  //                                                                           }));
  //                                                                 }
  //                                                                 Navigator.pop(
  //                                                                     context);
  //                                                               },
  //                                                               child:
  //                                                                   Container(
  //                                                                 decoration: BoxDecoration(
  //                                                                     border: Border.all(
  //                                                                         color:
  //                                                                             Colors.red)),
  //                                                                 width: 30.w,
  //                                                                 height: 35,
  //                                                                 child: const Center(
  //                                                                     child: const Text(
  //                                                                         'Cancel')),
  //                                                               ),
  //                                                               // color: Colors.transparent,
  //                                                             ),
  //                                                             InkWell(
  //                                                               onTap: () {
  //                                                                 Navigator.pop(
  //                                                                     context);
  //                                                               },
  //                                                               child:
  //                                                                   Container(
  //                                                                 decoration: BoxDecoration(
  //                                                                     border: Border.all(
  //                                                                         color:
  //                                                                             Colors.red)),
  //                                                                 width: 30.w,
  //                                                                 height: 35,
  //                                                                 child: const Center(
  //                                                                     child: const Text(
  //                                                                         'Apply')),
  //                                                               ),
  //                                                               // color: Colors.transparent,
  //                                                             ),
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         );
  //                                       },
  //                                     );
  //                                   },
  //                                   child: Container(
  //                                     height: 4.6.h,
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                         horizontal: 4.0,
  //                                       ),
  //                                       child: Center(
  //                                         child: AutoSizeText(
  //                                           productAttributeName,
  //                                           maxLines: 1,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(
  //                                         color: ConstantsVar.appColor,
  //                                       ),
  //                                       borderRadius: const BorderRadius.all(
  //                                         const Radius.circular(10),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 )
  //                               : Visibility(
  //                                   visible:
  //                                       _attributeText == '' ? false : true,
  //                                   child: Container(
  //                                     height: 4.6.h,
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                         vertical: 2,
  //                                         horizontal: 2,
  //                                       ),
  //                                       child: AutoSizeText(
  //                                         _attributeText,
  //                                         wrapWords: true,
  //                                         softWrap: true,
  //                                         maxLines: 2,
  //                                         textAlign: TextAlign.center,
  //                                       ),
  //                                     ),
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(
  //                                         color: ConstantsVar.appColor,
  //                                       ),
  //                                       borderRadius: const BorderRadius.all(
  //                                         const Radius.circular(10),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     width: 100.w,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         RichText(
  //                           text: TextSpan(
  //                             text: 'Availability: ',
  //                             style: TextStyle(
  //                                 color: Colors.grey.shade700,
  //                                 fontSize: 5.w,
  //                                 fontWeight: FontWeight.w400),
  //                             children: <TextSpan>[
  //                               TextSpan(
  //                                   text: stockAvaialbility,
  //                                   style: TextStyle(
  //                                       fontSize: 5.w,
  //                                       color: Colors.grey,
  //                                       fontWeight: FontWeight.w400))
  //                             ],
  //                           ),
  //                         ),
  //                         Visibility(
  //                           visible: showSubBtn,
  //                           child: InkWell(
  //                             focusColor: ConstantsVar.appColor,
  //                             radius: 48,
  //                             highlightColor: Colors.transparent,
  //                             splashColor: ConstantsVar.appColor,
  //                             onTap: () {
  //                               ApiCalls.subscribeProdcut(
  //                                       productId: widget._productId.toString(),
  //                                       customerId: guestCustomerID,
  //                                       apiToken: apiToken)
  //                                   .then((value) => setState(() {
  //                                         subBtnName = value;
  //                                       }));
  //                             },
  //                             child: Ink(
  //                               color: Colors.white,
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(4.0),
  //                                 child: Card(
  //                                   shape: const RoundedRectangleBorder(
  //                                     borderRadius: const BorderRadius.all(
  //                                       Radius.circular(8),
  //                                     ),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Text(subBtnName),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   Visibility(
  //                     visible: assemblyCharges == null ? false : true,
  //                     child: AutoSizeText(
  //                       assemblyCharges == null ? '' : assemblyCharges,
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                         fontSize: 5.w,
  //                         color: Colors.grey.shade700,
  //                         letterSpacing: 1,
  //                         wordSpacing: 2,
  //                       ),
  //                       textAlign: TextAlign.start,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Visibility(
  //                     visible: isDiscountAvail,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(left: 3.0),
  //                       child: discountWidget(
  //                           actualPrice: price,
  //                           fontSize: 3.6.w,
  //                           width: 50.w,
  //                           isSpace: !isDiscountAvail),
  //                     ),
  //                   ),
  //                   AutoSizeText(
  //                     discountedPrice == '' ? price : discountedPrice,
  //                     maxLines: 1,
  //                     style: TextStyle(
  //                       fontSize: 7.w,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.grey.shade700,
  //                       letterSpacing: 1,
  //                       wordSpacing: 2,
  //                     ),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Visibility(
  //         visible: _isGiftCard,
  //         child: addVerticalSpace(15),
  //       ),
  //       Visibility(
  //         visible: _isGiftCard,
  //         child: SizedBox(
  //           width: 100.w,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(
  //               vertical: 10.0,
  //             ),
  //             child: Column(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 10,
  //                     vertical: 3,
  //                   ),
  //                   child: TextFormField(
  //                     validator: (email) {
  //                       // if (isEmailValid(email!))
  //                       //   return null;
  //                       // else
  //                       //   return 'Enter a valid email address';
  //                     },
  //                     textInputAction: TextInputAction.next,
  //                     keyboardType: TextInputType.emailAddress,
  //                     controller: _recNameController,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     cursorColor: Colors.black,
  //                     style: const TextStyle(color: Colors.black, fontSize: 14),
  //                     decoration: InputDecoration(
  //                       focusedBorder: const OutlineInputBorder(),
  //
  //                       labelStyle: TextStyle(
  //                         fontSize: 3.5.w,
  //                       ),
  //                       // color:
  //                       // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
  //                       labelText: 'RECIPIENT\'S NAME:',
  //                       border: const OutlineInputBorder(),
  //                       counterText: '',
  //                     ),
  //                   ),
  //                 ),
  //                 addVerticalSpace(14),
  //                 Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  //                   child: TextFormField(
  //                     validator: (email) {
  //                       // if (isEmailValid(email!))
  //                       //   return null;
  //                       // else
  //                       //   return 'Enter a valid email address';
  //                     },
  //                     textInputAction: TextInputAction.next,
  //                     keyboardType: TextInputType.emailAddress,
  //                     controller: recEmailController,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     cursorColor: Colors.black,
  //                     style: const TextStyle(color: Colors.black, fontSize: 14),
  //                     decoration: InputDecoration(
  //                       focusedBorder: const OutlineInputBorder(),
  //
  //                       labelStyle: TextStyle(
  //                         fontSize: 3.5.w,
  //                       ),
  //                       // color:
  //                       // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
  //                       labelText: 'RECIPIENT\'S EMAIL:',
  //                       border: const OutlineInputBorder(),
  //                       counterText: '',
  //                     ),
  //                   ),
  //                 ),
  //                 addVerticalSpace(14),
  //                 Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  //                   child: TextFormField(
  //                     validator: (email) {
  //                       // if (isEmailValid(email!))
  //                       //   return null;
  //                       // else
  //                       //   return 'Enter a valid email address';
  //                     },
  //                     textInputAction: TextInputAction.next,
  //                     keyboardType: TextInputType.emailAddress,
  //                     controller: _yourNameController,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     cursorColor: Colors.black,
  //                     style: const TextStyle(color: Colors.black, fontSize: 14),
  //                     decoration: InputDecoration(
  //                       focusedBorder: const OutlineInputBorder(),
  //
  //                       labelStyle: TextStyle(
  //                         fontSize: 3.5.w,
  //                       ),
  //                       // color:
  //                       // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
  //                       labelText: 'YOUR NAME:',
  //                       border: const OutlineInputBorder(),
  //                       counterText: '',
  //                     ),
  //                   ),
  //                 ),
  //                 addVerticalSpace(14),
  //                 Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  //                   child: TextFormField(
  //                     validator: (email) {
  //                       // if (isEmailValid(email!))
  //                       //   return null;
  //                       // else
  //                       //   return 'Enter a valid email address';
  //                     },
  //                     textInputAction: TextInputAction.next,
  //                     keyboardType: TextInputType.emailAddress,
  //                     controller: _yourEmailController,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     cursorColor: Colors.black,
  //                     style: const TextStyle(color: Colors.black, fontSize: 14),
  //                     decoration: InputDecoration(
  //                       focusedBorder: const OutlineInputBorder(),
  //
  //                       labelStyle: TextStyle(
  //                         fontSize: 3.5.w,
  //                       ),
  //                       // color:
  //                       // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
  //                       labelText: 'YOUR EMAIL:',
  //                       border: const OutlineInputBorder(),
  //                       counterText: '',
  //                     ),
  //                   ),
  //                 ),
  //                 addVerticalSpace(14),
  //                 Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  //                   child: TextFormField(
  //                       validator: (val) {
  //                         // if (isAddress(val!.trim()))
  //                         //   return null;
  //                         // else
  //                         //   return 'Enter your address';
  //                       },
  //                       textInputAction: TextInputAction.newline,
  //                       maxLines: 3,
  //                       // autovalidateMode: AutovalidateMode.onUserInteraction,
  //                       controller: _messageController,
  //                       cursorColor: Colors.black,
  //                       style:
  //                           const TextStyle(color: Colors.black, fontSize: 16),
  //                       decoration: InputDecoration(
  //                           counterText: '',
  //                           labelStyle:
  //                               TextStyle(fontSize: 5.w, color: Colors.grey),
  //                           labelText: 'Message',
  //                           border: const OutlineInputBorder())),
  //                 ),
  //                 addVerticalSpace(14),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         width: MediaQuery.of(context).size.width,
  //         child: const Divider(
  //           thickness: 2,
  //         ),
  //       ),
  //       ExpandablePanel(
  //         header: Padding(
  //           padding: const EdgeInsets.all(14.0),
  //           child: AutoSizeText(
  //             'OVERVIEW',
  //             style: TextStyle(
  //               fontSize: 4.w,
  //             ),
  //           ),
  //         ),
  //         collapsed: const Text(
  //           '',
  //           softWrap: true,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         expanded: Center(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Container(
  //               child: HtmlWidget(
  //                 initialDatas!.fullDescription,
  //                 onTapUrl: (url) async {
  //                   if (url.contains(
  //                       'terms-and-conditions-for-on-line-accessory-styling-service')) {
  //                     Navigator.push(
  //                       context,
  //                       CupertinoPageRoute(
  //                         builder: (context) => TopicPage(
  //                             paymentUrl:
  //                                 'https://www.theone.com/terms-and-conditions-for-online-accessory-styling-service-app'),
  //                       ),
  //                     );
  //                   } else if (url.contains(
  //                       'terms-and-conditions-for-online-furniture-styling-service-by-the-one-total-home-experience-llc')) {
  //                     Navigator.push(
  //                       context,
  //                       CupertinoPageRoute(
  //                         builder: (context) => TopicPage(
  //                             paymentUrl:
  //                                 'https://www.theone.com/terms-and-conditions-for-online-furniture-styling-service-by-the-one-total-home-experience-llc-app'),
  //                       ),
  //                     );
  //                   } else {
  //                     ApiCalls.launchUrl(url);
  //                   }
  //                   return true;
  //                 },
  //                 // textStyle: GoogleFonts.architectsDaughter(),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       InkWell(
  //         onTap: () => Navigator.push(
  //             context,
  //             CupertinoPageRoute(
  //               builder: (context) => ContactUS(
  //                 id: sku,
  //                 name: name,
  //                 desc: descritption,
  //                 boolValue: true,
  //               ),
  //             )),
  //         child: Container(
  //           decoration: const BoxDecoration(
  //               border: Border.symmetric(
  //                   horizontal: BorderSide(width: 1, color: Colors.black))),
  //           child: const Padding(
  //             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 13.0),
  //             child: const Text('CONTACT US'),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 20,
  //       ),
  //     ],
  //   );
  // }

  cehckBackSwipe({required DragUpdateDetails details}) {
    if (details.delta.direction <= 0) {
      Navigator.pop(context);
    }
  }
}

InputDecoration editBoxDecoration(String name, Icon icon, String prefixText) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(),
    prefixText: prefixText,
    prefixIcon: icon,
    labelStyle: TextStyle(
      fontSize: 5.w,
    ),
    // color:
    // myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
    labelText: name,
    border: InputBorder.none,
    counterText: '',
  );
}

void showDialog1(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    context: context,
    pageBuilder: (_, __, ___) {
      return Card(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.PrimaryAccentColor, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: 5.8.h,
          child: CupertinoScrollbar(
            child: ListView(children: [
              ListTile(
                title: TextFormField(),
              ),
              ListTile(
                title: TextFormField(),
              ),
            ]),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, .7))
            .animate(anim),
        child: child,
      );
    },
  );
}

class GiftCardModel {
  String name;
  String id;

  GiftCardModel({required this.name, required this.id});
}
