import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/utils/general_functions.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with InputValidationMixin {
  var wishlistProvider = CartCounter();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _scrollController = ScrollController();

  @override
  initState() {
    initSharedPrefs();

    super.initState();
  }

  String _loginId = '';
  String apiToken = '';
  String customerId = '';
  String _customerEmail = '';
  TextEditingController? _customerEmailCtrl, _friendEmailCtrl, _messageCtrl;

  // late FocusScopeNode currentFocus;

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance().whenComplete(
      () => setState(
        () {
          _loginId = ConstantsVar.prefs.getString('userId') ?? '';
          customerId = ConstantsVar.prefs.getString('guestCustomerID')!;
          apiToken = ConstantsVar.prefs.getString('apiTokken')!;
          _customerEmail = ConstantsVar.prefs.getString('email') ?? '';
          _customerEmailCtrl = TextEditingController(text: _customerEmail);
          _friendEmailCtrl = TextEditingController();
          _messageCtrl = TextEditingController();
        },
      ),
    );
    wishlistProvider = Provider.of<CartCounter>(context, listen: false);
    wishlistProvider.getWishlist(
      baseUrl: await ApiCalls.getSelectedStore(),
      storeid: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // backgroundColor: ConstantsVar.appColor,
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: InkWell(
                radius: 48,
                child: Consumer<CartCounter>(
                  builder: (context, value, child) {
                    return Badge(
                      position: BadgePosition.topEnd(),
                      badgeColor: Colors.white,
                      badgeContent: AutoSizeText(
                        value.badgeNumber.toString(),
                      ),
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
        body: Consumer<CartCounter>(builder: (context, value, _) {
          if (value.isVisible == true) {
            return SizedBox(
              width: 100.w,
              height: 70.h,
              child: const Center(
                child: SpinKitRipple(
                  color: Colors.red,
                  size: 60,
                ),
              ),
            );
          } else {
            if (value.wishlistItems.isEmpty) {
              return SizedBox(
                height: 100.h,
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Center(
                          child: AutoSizeText(
                            'Wishlist'.toUpperCase(),
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
                    SizedBox(
                      width: 100.w,
                      height: 70.h,
                      child: Center(
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'No Data Available',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Stack(
                      children: [
                        Card(
                          child: ListTile(
                            title: Center(
                              child: AutoSizeText(
                                'Wishlist'.toUpperCase(),
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
                        Positioned(
                          right: .1,
                          top: 8,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_sweep,
                                  color: ConstantsVar.appColor,
                                ),
                                iconSize: 22,
                                onPressed: () async {
                                  final _formProvider =
                                      Provider.of<CartCounter>(context,
                                          listen: false);
                                  _formProvider.deleteWishlist(
                                    baseUrl: await ApiCalls.getSelectedStore(),
                                    storeId: await secureStorage.read(
                                            key: kselectedStoreIdKey) ??
                                        '1',
                                    ctx: context,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  HeartIcon.share,
                                  color: ConstantsVar.appColor,
                                ),
                                iconSize: 22,
                                onPressed: () {
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  _loginId != '' || _loginId.isNotEmpty
                                      ? showModalBottomSheet<void>(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          backgroundColor: Colors.white,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Form(
                                              key: _formKey,
                                              child: SizedBox(
                                                width: 100.w,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.80,

                                                // height: 60.h,
                                                child: Scaffold(
                                                  resizeToAvoidBottomInset:
                                                      true,
                                                  body: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 6.0),
                                                        child: AutoSizeText(
                                                          'SHARE YOUR WISHLIST',
                                                          maxLines: 1,
                                                          maxFontSize: 18,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: VsScrollbar(
                                                          controller:
                                                              _scrollController,
                                                          isAlwaysShown: true,
                                                          child: ListView(
                                                            controller:
                                                                _scrollController,
                                                            children: [
                                                              SizedBox(
                                                                height: 2.h,
                                                              ),
                                                              ListTile(
                                                                title:
                                                                    AutoSizeText(
                                                                  'YOUR EMAIL:',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        4.w,
                                                                  ),
                                                                ),
                                                                subtitle:
                                                                    TextFormField(
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  validator:
                                                                      (email) {
                                                                    if (isEmailValid(
                                                                        email!)) {
                                                                      return null;
                                                                    } else {
                                                                      return 'Enter a valid email address';
                                                                    }
                                                                  },
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  maxLines: 1,
                                                                  controller:
                                                                      _customerEmailCtrl,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              addVerticalSpace(
                                                                  10),
                                                              ListTile(
                                                                title:
                                                                    AutoSizeText(
                                                                  'FRIEND\'S EMAIL:',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        4.w,
                                                                  ),
                                                                ),
                                                                subtitle:
                                                                    TextFormField(
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  validator:
                                                                      (email) {
                                                                    if (isEmailValid(
                                                                        email!)) {
                                                                      return null;
                                                                    } else {
                                                                      return 'Enter a valid email address';
                                                                    }
                                                                  },

                                                                  decoration:
                                                                      const InputDecoration(
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,

                                                                  maxLines: 1,
                                                                  // maxLength: 20,
                                                                  controller:
                                                                      _friendEmailCtrl,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              addVerticalSpace(
                                                                  10),
                                                              ListTile(
                                                                title:
                                                                    AutoSizeText(
                                                                  'MESSAGE:',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        4.w,
                                                                  ),
                                                                ),
                                                                subtitle:
                                                                    TextFormField(
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  maxLines: 4,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  controller:
                                                                      _messageCtrl,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SafeArea(
                                                        bottom: true,
                                                        maintainBottomViewPadding:
                                                            true,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 64.w,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                child: Text(
                                                                  'Cancel',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        4.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: ConstantsVar
                                                                        .appColor,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  'Share',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        4.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: ConstantsVar
                                                                        .appColor,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  SystemChannels
                                                                      .textInput
                                                                      .invokeMethod(
                                                                          'TextInput.hide');

                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    _formKey
                                                                        .currentState!
                                                                        .save();
                                                                    final _formProvider = Provider.of<
                                                                            CartCounter>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                    _formProvider
                                                                        .shareMyWishlist(
                                                                      baseUrl:
                                                                          await ApiCalls
                                                                              .getSelectedStore(),
                                                                      storeId:
                                                                          await secureStorage.read(key: kselectedStoreIdKey) ??
                                                                              '1',
                                                                      friendEmail:
                                                                          _friendEmailCtrl!
                                                                              .text,
                                                                      customerEmail:
                                                                          _customerEmailCtrl!
                                                                              .text,
                                                                      ctx:
                                                                          context,
                                                                      message:
                                                                          _messageCtrl!
                                                                              .text,
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Fluttertoast.showToast(
                                          msg:
                                              "Only Registered customer can use this feature.",
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      // physics: NeverScrollableScrollPhysics(),

                      shrinkWrap: true,
                      children: List.generate(
                        value.wishlistItems.length,
                        (index) => OpenContainer(
                          onClosed: (_) async {
                            wishlistProvider.getWishlist(
                              baseUrl: await ApiCalls.getSelectedStore(),
                              storeid: await secureStorage.read(
                                      key: kselectedStoreIdKey) ??
                                  '1',
                            );
                          },
                          closedBuilder:
                              (BuildContext context, void Function() action) {
                            return SizedBox(
                              width: 100.w,
                              child: SizedBox(
                                height: 22.h,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 20),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8,
                                                  left: 8,
                                                  top: 8,
                                                  bottom: 8),
                                              width: 80,
                                              height: 80,
                                              child: CachedNetworkImage(
                                                imageUrl: value
                                                    .wishlistItems[index]
                                                    .picture
                                                    .imageUrl,
                                                fit: BoxFit.cover,
                                              )),
                                          Expanded(
                                            child: Container(
                                              height: 23.h,
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    value.wishlistItems[index]
                                                        .productName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: CustomTextStyle
                                                        .textFormFieldSemiBold
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                  // Utils.getSizedBox(null, 6),
                                                  AutoSizeText(
                                                    "SKU : ${value.wishlistItems[index].sku}",
                                                    style: CustomTextStyle
                                                        .textFormFieldRegular
                                                        .copyWith(
                                                            color: Colors.grey,
                                                            fontSize: 15),
                                                  ),
                                                  // Utils.getSizedBox(null, 6),
                                                  Visibility(
                                                    visible: value
                                                            .wishlistItems[
                                                                index]
                                                            .discount
                                                            .toString()
                                                            .contains('null')
                                                        ? false
                                                        : true,
                                                    child: AutoSizeText(
                                                      'Discount: ' +
                                                          value
                                                              .wishlistItems[
                                                                  index]
                                                              .discount
                                                              .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    'Unit Price: ' +
                                                        value
                                                            .wishlistItems[
                                                                index]
                                                            .unitPrice,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  AutoSizeText(
                                                    'Quantity: ' +
                                                        value
                                                            .wishlistItems[
                                                                index]
                                                            .quantity
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 100,
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 1,
                                      right: 1,
                                      child: Card(
                                        elevation: 10,
                                        shape: const CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: LikeButton(
                                            onTap: (isLiked) async {
                                              await ApiCalls.removeFromWishlist(
                                                      baseurl: await ApiCalls
                                                          .getSelectedStore(),
                                                      storeId: await secureStorage
                                                              .read(
                                                                  key:
                                                                      kselectedStoreIdKey) ??
                                                          '1',
                                                      productId: value
                                                          .wishlistItems[index]
                                                          .productId
                                                          .toString(),
                                                      context: context)
                                                  .then((value) =>
                                                      isLiked = value)
                                                  .then((value) async =>
                                                      wishlistProvider
                                                          .getWishlist(
                                                        baseUrl: await ApiCalls
                                                            .getSelectedStore(),
                                                        storeid: await secureStorage
                                                                .read(
                                                                    key:
                                                                        kselectedStoreIdKey) ??
                                                            '1',
                                                      ));
                                              return isLiked;
                                            },
                                            size:
                                                IconTheme.of(context).size! - 4,
                                            circleColor: const CircleColor(
                                              start: ConstantsVar.appColor,
                                              end: ConstantsVar.appColor,
                                            ),

                                            bubblesColor: const BubblesColor(
                                              dotPrimaryColor:
                                                  ConstantsVar.appColor,
                                              dotSecondaryColor:
                                                  ConstantsVar.appColor,
                                            ),
                                            // isLiked: isWishlisted,
                                            likeBuilder: (bool isLiked) {
                                              return Icon(
                                                Icons.close,
                                                color: ConstantsVar.appColor,
                                                size: IconTheme.of(context)
                                                        .size! -
                                                    2,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          openBuilder: (BuildContext context,
                              void Function({Object? returnValue}) action) {
                            return NewProductDetails(
                                productId: value.wishlistItems[index].productId
                                    .toString(),
                                screenName: 'Wishlist');
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        }),
      ),
    );
  }

  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  final colorizeColors = [
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];
}
