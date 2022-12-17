import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:menu_button/menu_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchResponse/SearchResponse.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:untitled2/utils/models/homeresponse.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

enum AniProps { color }

class SearchPage extends StatefulWidget {
  SearchPage({
    Key? key,
    required this.keyword,
    required this.isScreen,
    required this.enableCategory,
  }) : super(key: key);
  final String keyword;
  bool isScreen, enableCategory;
  double? _maxPrice, _minPrice;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  String _selectedSeats = '', _selectedColors = '', _selectedFaimly = '';
  String _selectedSeatsId = '',
      _selectedColorsId = '',
      _selectedFaimlyId = '',
      _mainString = '';
  bool _isUAE = true;

  void returnVisibility() async {
    String _selectedStoreId =
        await secureStorage.read(key: kselectedStoreIdKey) ?? "1";
    setState(() {
      if (_selectedStoreId == "1") {
        _isUAE = true;
      } else {
        _isUAE = false;
      }
    });
  }

  final colorizeColors = [
    Colors.white,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];
  final _suggestController = ScrollController();
  late AnimationController _animationController;
  final colorizeTextStyle = TextStyle(
    fontSize: 6.w,
    fontWeight: FontWeight.bold,
  );
  bool isAlreadySet = false;
  var _range = const RangeValues(0, 0);
  var color1 = ConstantsVar.appColor;
  var color2 = Colors.black54;
  late Animation<double> size;
  bool isLoadVisible = false;
  bool isListVisible = false, isFilterVisible = false;
  late TextEditingController _searchController;

  List<SpecificationAttributeFilter> mList = [];

  List<Color> colorList = [
    ConstantsVar.appColor,
    Colors.black26,
    Colors.white60
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  var totalCount = 0;
  Color topColor = ConstantsVar.appColor;
  Color bottomColor = Colors.black26;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  Color btnColor = Colors.black;
  int pageIndex = 0;
  var guestCustomerId = '';
  late bool noMore;
  bool isVisible = false;
  final RefreshController _refreshController = RefreshController();

  var _focusNode = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double? _minPRICE, _maxPRICE;

  double tempMin = 0, tempMax = 25000;
  double _width = 0;
  double _height = 0;
  List<Specificationoption> _colorList = [];
  List<Specificationoption> _numberOfSeatList = [];
  List<Specificationoption> _familyList = [];

  final ScrollController _scrollListController = ScrollController();

  String initialData = '';
  var _hintText = 'Search Here';

  List<String> searchSuggestions = [];

  var itemSize = 75.h;

  var _returnBool = false;

  List<HomePageProductImage> productList = [];
  List<HomePageCategoriesImage> categoryList = [];

  @override
  void initState() {
    initSharedPrefs();
    returnVisibility();
    setState(() {
      _height = 22.h;
      _width = 100.w;
      initialData = widget.keyword;
    });

    if (widget.isScreen == true) {
      if (initialData.toLowerCase().contains('return') ||
          initialData.toLowerCase().contains('policy') ||
          initialData.toString().toLowerCase().contains('refund')) {
        _returnBool = true;
        widget.enableCategory = false;

        setState(() {});
      } else {
        getInitSearch();
      }
    }

    _searchController = TextEditingController(text: initialData);

    _scrollListController.addListener(() {
      if (_scrollListController.position.pixels ==
          _scrollListController.position.maxScrollExtent) {
        log('Hi There I Am Triggered');
        if (searchedProducts.length == totalCount) {
          Fluttertoast.showToast(msg: 'No more product available');
        } else {
          _onLoading();
        }
      }
    });
    scrollControllerFunct();
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    noMore = false;
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID') ?? "";
    Future.delayed(Duration.zero).then(
      (value) => setState(
        () {
          _range =
              RangeValues(widget._minPrice ?? 0 + 1, widget._maxPrice ?? 2 - 1);
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    Animation<Offset> _animation = Tween<Offset>(
      begin: const Offset(1, -1),
      end: const Offset(0, 0),
    ).animate(_animationController)
      ..addListener(() => setState(() {}));
    _animationController.forward();
    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: searchedProducts.isEmpty || searchedProducts.length < 10
              ? false
              : true,
          child: FloatingActionButton.small(
            backgroundColor: ConstantsVar.appColor,
            onPressed: _moveDown,
            child: const Icon(Icons.arrow_downward),
          ),
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
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
          centerTitle: true,
          toolbarHeight: 18.w,
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: begin, end: end, colors: [bottomColor, topColor])),
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                        width: 100.w,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 8.0,
                                    child: Consumer<NewApisProvider>(
                                      builder: (_, value, c) =>
                                          RawAutocomplete<String>(
                                        initialValue: TextEditingValue(
                                            text: widget.keyword),
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '' ||
                                              textEditingValue.text.length <
                                                  3) {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return value.searchSuggestions
                                              .where((String option) {
                                            return option
                                                .toLowerCase()
                                                .contains(textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (String selection) {
                                          log('$selection selected');
                                        },
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          _searchController =
                                              textEditingController;
                                          _focusNode = focusNode;
                                          return TextFormField(
                                            autocorrect: true,
                                            enableSuggestions: true,
                                            onFieldSubmitted: (val) {
                                              focusNode.unfocus();
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              setState(() {
                                                _selectedColorsId = '';
                                                _selectedSeatsId = '';
                                                _selectedFaimlyId = '';
                                                _colorList = [];
                                                _numberOfSeatList = [];
                                                _familyList = [];
                                                _height = 0.h;
                                                isVisible = false;
                                                noMore = false;
                                                pageIndex = 0;
                                                isAlreadySet = false;

                                                _maxPRICE = null;
                                                _minPRICE = null;
                                              });
                                              if (val
                                                      .toLowerCase()
                                                      .contains('return') ||
                                                  val
                                                      .toLowerCase()
                                                      .contains('policy') ||
                                                  val
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains('refund')) {
                                                _returnBool = true;
                                                widget.enableCategory = false;
                                                searchedProducts = [];
                                                isFilterVisible = false;

                                                setState(() {});
                                              } else {
                                                searchProducts(val, 0, '', '')
                                                    .then(
                                                        (value) => log(value));
                                              }

                                              log('Pressed via keypad');
                                            },
                                            textInputAction: isVisible
                                                ? TextInputAction.done
                                                : TextInputAction.search,
                                            keyboardAppearance:
                                                Brightness.light,
                                            onChanged: (_) => setState(() {
                                              btnColor = ConstantsVar.appColor;
                                              _hintText = 'Search Here';
                                            }),
                                            controller: _searchController,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 5.w),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13,
                                                      horizontal: 10),
                                              hintText: _hintText,
                                              labelStyle: TextStyle(
                                                  fontSize: 7.w,
                                                  color: Colors.grey),
                                              suffixIcon: InkWell(
                                                onTap: () async {
                                                  focusNode.unfocus();

                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                  }
                                                  setState(() {
                                                    if (isFilterVisible ==
                                                        true) {
                                                      isFilterVisible = false;
                                                    }
                                                    _selectedSeats = '';
                                                    _selectedColors = '';
                                                    _selectedFaimly = '';
                                                    _selectedColorsId = '';
                                                    _selectedSeatsId = '';
                                                    _selectedFaimlyId = '';
                                                    _colorList = [];
                                                    _numberOfSeatList = [];
                                                    _familyList = [];
                                                    _height = 0.h;
                                                    noMore = false;
                                                    isAlreadySet = false;
                                                    _maxPRICE = null;
                                                    _minPRICE = null;
                                                    pageIndex = 0;
                                                  });
                                                  if (_searchController.text
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains('return') ||
                                                      _searchController.text
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains('policy') ||
                                                      _searchController.text
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains('refund')) {
                                                    _returnBool = true;
                                                    widget.enableCategory =
                                                        false;
                                                    searchedProducts = [];
                                                    isFilterVisible = false;

                                                    setState(() {});
                                                  } else {
                                                    searchProducts(
                                                      _searchController.text
                                                          .toString(),
                                                      pageIndex,
                                                    ).then((value) => null);
                                                  }
                                                },
                                                child: const Icon(
                                                    Icons.search_sharp),
                                              ),
                                            ),
                                            focusNode: _focusNode,
                                          );
                                        },
                                        optionsViewBuilder:
                                            (BuildContext context,
                                                AutocompleteOnSelected<String>
                                                    onSelected,
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
                                                      controller:
                                                          _suggestController,
                                                      thickness: 5,
                                                      isAlwaysShown: true,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            options.length + 1,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          if (index >=
                                                              options.length) {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: TextButton(
                                                                child:
                                                                    const Text(
                                                                  'Clear',
                                                                  style:
                                                                      TextStyle(
                                                                    color: ConstantsVar
                                                                        .appColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  _searchController
                                                                      .clear();
                                                                },
                                                              ),
                                                            );
                                                          }
                                                          final String option =
                                                              options.elementAt(
                                                                  index);
                                                          return GestureDetector(
                                                              onTap: () {
                                                                onSelected(
                                                                    option);
                                                                if (!currentFocus
                                                                    .hasPrimaryFocus) {
                                                                  currentFocus
                                                                      .unfocus();
                                                                }
                                                                setState(() {
                                                                  if (isFilterVisible ==
                                                                      true) {
                                                                    isFilterVisible =
                                                                        false;
                                                                  }
                                                                  _selectedSeats =
                                                                      '';
                                                                  _selectedColors =
                                                                      '';
                                                                  _selectedFaimly =
                                                                      '';
                                                                  _selectedColorsId =
                                                                      '';
                                                                  _selectedSeatsId =
                                                                      '';
                                                                  _selectedFaimlyId =
                                                                      '';
                                                                  _colorList =
                                                                      [];
                                                                  _numberOfSeatList =
                                                                      [];
                                                                  _familyList =
                                                                      [];
                                                                  _height = 0.h;
                                                                  noMore =
                                                                      false;
                                                                  searchedProducts =
                                                                      [];
                                                                  isFilterVisible =
                                                                      false;
                                                                  pageIndex = 0;
                                                                });

                                                                searchProducts(
                                                                  option
                                                                      .toString(),
                                                                  pageIndex,
                                                                ).then(
                                                                    (value) =>
                                                                        null);
                                                              },
                                                              child: SizedBox(
                                                                height: 5.2.h,
                                                                width: 95.w,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          100.w,
                                                                      child:
                                                                          AutoSizeText(
                                                                        '  ' +
                                                                            option,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          wordSpacing:
                                                                              2,
                                                                          letterSpacing:
                                                                              1,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          100.w,
                                                                      child:
                                                                          Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
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
                                Visibility(
                                  visible:
                                      searchedProducts.isEmpty ? false : true,
                                  child: InkWell(
                                    radius: 36,
                                    splashColor: Colors.red,
                                    hoverColor: Colors.red,
                                    highlightColor: Colors.red,
                                    onTap: () => _toggle(),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8),
                                      child: Icon(
                                        HeartIcon.searchFilter,
                                        color: Colors.white,
                                        size: 42,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: showSearchFilter(_animation),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: isListVisible,
                            child: SizedBox(
                              height: 100.h,
                              child: VsScrollbar(
                                style: const VsScrollbarStyle(
                                  thickness: 12,
                                ),
                                isAlwaysShown: true,
                                controller: _scrollListController,
                                child: GridView.count(
                                  controller: _scrollListController,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 3 / 6,
                                  mainAxisSpacing: 5,
                                  children: List.generate(
                                    searchedProducts.length,
                                    (index) {
                                      log(searchedProducts[index]
                                          .discountedPrice);

                                      return Stack(
                                        children: [
                                          Card(
                                            child: OpenContainer(
                                              closedElevation: 2,
                                              openBuilder: (BuildContext
                                                      context,
                                                  void Function(
                                                          {Object? returnValue})
                                                      action) {
                                                log(searchedProducts[index]
                                                    .discountedPrice);
                                                return NewProductDetails(
                                                  productId:
                                                      searchedProducts[index]
                                                          .id
                                                          .toString(),
                                                  screenName: 'Product List',
                                                );
                                              },
                                              closedBuilder:
                                                  (BuildContext context,
                                                      void Function() action) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints
                                                              .tightFor(
                                                        width: 42.w,
                                                        height: 42.w,
                                                      ),
                                                      color: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            searchedProducts[
                                                                    index]
                                                                .productPicture,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                reason) =>
                                                            const SpinKitRipple(
                                                          color: Colors.red,
                                                          size: 90,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 8.0),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              searchedProducts[
                                                                      index]
                                                                  .name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      4.5.w,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                            constraints:
                                                                BoxConstraints
                                                                    .tightFor(
                                                                        width: 48
                                                                            .w,
                                                                        height:
                                                                            18.w),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        6.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AutoSizeText(
                                                                  searchedProducts[index]
                                                                              .discountedPrice ==
                                                                          ''
                                                                      ? searchedProducts[
                                                                              index]
                                                                          .price
                                                                      : searchedProducts[
                                                                              index]
                                                                          .discountedPrice,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      height: 1,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontSize:
                                                                          4.w,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Consumer<NewApisProvider>(
                                                      builder: (ctx, val, _) =>
                                                          AddCartBtn(
                                                        productId:
                                                            searchedProducts[
                                                                    index]
                                                                .id
                                                                .toString(),
                                                        isTrue: true,
                                                        guestCustomerId:
                                                            guestCustomerId,
                                                        checkIcon: searchedProducts[
                                                                    index]
                                                                .stockQuantity
                                                                .contains(
                                                                    'Out of stock')
                                                            ? const Icon(
                                                                HeartIcon.cross)
                                                            : const Icon(
                                                                Icons.check),
                                                        text: searchedProducts[
                                                                    index]
                                                                .stockQuantity
                                                                .contains(
                                                                    'Out of stock')
                                                            ? 'Out of Stock'
                                                                .toUpperCase()
                                                            : 'ADD TO CArt'
                                                                .toUpperCase(),
                                                        color: searchedProducts[
                                                                    index]
                                                                .stockQuantity
                                                                .contains(
                                                                    'Out of stock')
                                                            ? Colors.grey
                                                            : ConstantsVar
                                                                .appColor,
                                                        isGiftCard:
                                                            searchedProducts[
                                                                    index]
                                                                .isGiftCard,
                                                        isProductAttributeAvail:
                                                            false,
                                                        attributeId: '',
                                                        recipEmail: '',
                                                        email: '',
                                                        message: '',
                                                        name: '',
                                                        recipName: '',
                                                        storeId: '',
                                                        productName:
                                                            searchedProducts[
                                                                    index]
                                                                .name,
                                                        productPrice:
                                                            searchedProducts[
                                                                    index]
                                                                .priceValue,
                                                        categoryId:
                                                            searchedProducts[
                                                                    index]
                                                                .parentCategoryId,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                          Consumer<NewApisProvider>(
                                            builder: (ctx, val, _) =>
                                                !searchedProducts[index]
                                                            .parentCategoryId
                                                            .contains(val
                                                                .bogoValue) ||
                                                        val.bogoValue.isEmpty
                                                    ? Visibility(
                                                        visible: searchedProducts[
                                                                        index]
                                                                    .discountPercent !=
                                                                ''
                                                            ? true
                                                            : false,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: SizedBox(
                                                                width: 14.w,
                                                                height: 14.w,
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(
                                                                      'MyAssets/plaincircle.png',
                                                                      width:
                                                                          15.w,
                                                                      height:
                                                                          15.w,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        searchedProducts[index]
                                                                            .discountPercent,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w800,
                                                                          fontSize:
                                                                              4.8.w,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: SizedBox(
                                                              width: 14.w,
                                                              height: 14.w,
                                                              child:
                                                                  Image.asset(
                                                                'MyAssets/bogo_logo.jpeg',
                                                                width: 15.w,
                                                                height: 15.w,
                                                              ),
                                                            )),
                                                      ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _returnBool,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => TopicPage(
                                      paymentUrl:
                                          'https://www.theone.com/terms-conditions-3',
                                        customerGUID:  ConstantsVar.prefs.getString('guestGUID')??''
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Card(
                                    child: SizedBox(
                                      height: 32.h,
                                      width: 42.w,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(4.0),
                                            constraints:
                                                BoxConstraints.tightFor(
                                              width: 42.w,
                                              height: 42.w,
                                            ),
                                            child: Image.asset(
                                              'ServicesImages/terms&conditions_icon.jpeg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Terms & Conditions',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 4.5.w,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                Visibility(
                  visible: widget.enableCategory,
                  child: Center(
                    child: SearchCategories(
                      productList: productList,
                      categoryList: categoryList,
                    ),
                  ),
                ),
                Visibility(
                  visible: noMore,
                  child: Align(
                    alignment: const Alignment(0, .3),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'No Product Found',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(Icon icon) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      hintText: 'Search here',
      labelStyle: TextStyle(fontSize: 7.w, color: Colors.grey),
      border: InputBorder.none,
    );
  }

  List<GetProductsByCategoryIdClass> searchedProducts = [];

  Future searchProducts(String productName, int pageNumber,
      [String? minPrice, String? maxPrice]) async {
    // await FirebaseAnalytics.instance.logSearch(searchTerm: productName);
    final _fireEvents = FirebaseEvents.initialize(context: context);
    _fireEvents.sendSearchData(searchTerm: productName);

    _fireEvents.sendScreenViewData(screenName: "Search Screen");
    _fireEvents.sendViewSearchResultData(searchTerm: productName);

    final _fbEvents = FacebookEvents();
    _fbEvents.sendScreenViewData(type: "Search Screen", id: "Search Screen");
    _fbEvents.sendSearchData(keyword: productName);

    setState(() {
      _returnBool = false;
    });
    log('Hi There');
    setState(() => widget.enableCategory = false);
    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 2, dismissable: false);
    progressDialog.setLoadingWidget(const SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));

    Future.delayed(Duration.zero, () {
      progressDialog.show();
    });

    setState(() {
      noMore = false;
      searchedProducts.clear();
      isLoadVisible = true;
      isListVisible = false;
      _mainString = _selectedSeatsId + _selectedColorsId + _selectedFaimlyId;
    });
    log('Search Product Customer Id:- ' +
        ConstantsVar.prefs.getString('guestCustomerID')!);
    String withUAE =
        '&minPrice=${minPrice}&maxPrice=$maxPrice&specId=$_mainString';
    final uri = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetSearch?keyword=$productName&${'CustId'}=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}&$kpageIndexVar$pageNumber&$kpageSizeVar${10}' +
        '${_isUAE == true ? withUAE : '&specId=$_mainString'}');

    // final uri = Uri.parse(await ApiCalls.getSelectedStore() +
    //     'GetSearch?CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&keyword=$productName&pagesize=10&pageindex=$pageNumber&minPrice=$minPrice&maxPrice=$maxPrice&specId=$_mainString&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}');

    log(uri);
    try {
      var response = await http.get(uri, headers: ApiCalls.header);
      var jsonMap = jsonDecode(response.body);
      log(response.body);

      if (mounted) {
        if (jsonMap['ResponseData'] == null) {
          Fluttertoast.showToast(msg: 'No Product found');
          if (mounted) {
            setState(() {
              isLoadVisible = false;
              isFilterVisible = true;
              noMore = true;
              progressDialog.dismiss();
            });
          }
        } else {
          SearchResponse mySearchResponse = SearchResponse.fromJson(jsonMap);
          progressDialog.dismiss();

          if (mySearchResponse.responseData.getProductsByCategoryIdClasses ==
              null) {
            setState(() {
              noMore = true;
              isListVisible = false;
              isFilterVisible = true;
              isLoadVisible = false;
              progressDialog.dismiss();
            });
          } else {
            if (mounted) {
              setState(() {
                if (isAlreadySet == false) {
                  widget._maxPrice =
                      mySearchResponse.responseData.priceRange.maxPrice;
                  widget._minPrice =
                      mySearchResponse.responseData.priceRange.minPrice;
                  _range = RangeValues(widget._minPrice!, widget._maxPrice!);
                  if (kDebugMode) {
                    log("minPrice >>>>>>>>" + widget._maxPrice.toString());
                  }

                  tempMin = widget._minPrice!;
                  tempMax = widget._maxPrice!;
                }

                isLoadVisible = false;
                isFilterVisible = true;
                progressDialog.dismiss();
                searchedProducts.addAll(mySearchResponse
                    .responseData.getProductsByCategoryIdClasses);
                mList =
                    mySearchResponse.responseData.specificationAttributeFilters;

                if (mList.isEmpty) {
                } else {
                  for (int i = 0; i <= mList.length - 1; i++) {
                    if (mList[i].name.contains('Number of Seats')) {
                      _numberOfSeatList.clear();
                      _numberOfSeatList = mList[i].specificationoptions;
                    }
                    if (mList[i].name.contains('Family')) {
                      _familyList.clear();
                      _familyList = mList[i].specificationoptions;
                    }
                    if (mList[i].name.contains('Colour')) {
                      _colorList.clear();

                      _colorList = mList[i].specificationoptions;
                    }
                  }
                }

                isListVisible = true;
                totalCount = mySearchResponse.responseData.totalCount;
              });
            }

            if (totalCount == 0) {
              setState(() {
                isListVisible = true;

                progressDialog.dismiss();
                Fluttertoast.showToast(msg: 'No Products found');
              });
            } else if (searchedProducts.length ==
                mySearchResponse.responseData.totalCount) {
              setState(() {
                isLoadVisible = false;
                progressDialog.dismiss();
              });
            }
            await Provider.of<FirebaseAnalytics>(context, listen: false)
                .logViewSearchResults(searchTerm: productName);
            return searchedProducts;
          }
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();
    }
    progressDialog.dismiss();
  }

  void _onLoading() async {
    Fluttertoast.showToast(msg: 'Loading please wait');
    var prodName = '';
    CustomProgressDialog progressDialog =
        CustomProgressDialog(context, blur: 2, dismissable: true);
    progressDialog.setLoadingWidget(const SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));

    Future.delayed(Duration.zero, () {
      progressDialog.show();
    });
    setState(() {
      widget.isScreen == true
          ? prodName = widget.keyword
          : prodName = _searchController.text.toString();
      pageIndex++;
      log(pageIndex);
    });

    log('Loading new searched product customerID:- ' +
        ConstantsVar.prefs.getString('guestCustomerID')!);

    final uri = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetSearch?keyword=$prodName&${'CustId'}=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}&$kpageIndexVar$pageIndex&$kpageSizeVar${10}&minPrice=$_minPRICE&maxPrice=$_maxPRICE&specId=$_mainString');
    log(uri);
    try {
      var response = await http.get(uri, headers: ApiCalls.header);
      var result = jsonDecode(response.body);

      progressDialog.dismiss();

      SearchResponse mySearchResponse = SearchResponse.fromJson(result);

      setState(() {
        searchedProducts.addAll(
            mySearchResponse.responseData.getProductsByCategoryIdClasses);
        if (isAlreadySet == false) {
          widget._maxPrice = mySearchResponse.responseData.priceRange.maxPrice;
          widget._minPrice = mySearchResponse.responseData.priceRange.minPrice;
          _range = RangeValues(widget._minPrice!, widget._maxPrice!);
          log("minPrice >>>>>>>>" + widget._maxPrice.toString());

          tempMin = widget._minPrice!;
          tempMax = widget._maxPrice!;
        }
        _refreshController.loadComplete();
      });

      if (searchedProducts.length == totalCount) {
        setState(() {
          _refreshController.loadComplete();
          progressDialog.dismiss();
        });
      }
      if (mySearchResponse.status.contains('Failed')) {
        progressDialog.dismiss();
        setState(() {});
      }
      progressDialog.dismiss();
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _refreshController.loadFailed();
      progressDialog.dismiss();
    }
    progressDialog.dismiss();

    Fluttertoast.showToast(
        msg: '${searchedProducts.length.toString()}/${totalCount.toString()}');
  }

  Widget showSearchFilter(Animation<Offset> _animation) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10.0,
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 2),
        child: isVisible == true
            ? SizedBox(
                height: _height,
                width: _width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                      visible: _numberOfSeatList.isEmpty ? false : true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          SizedBox(
                            width: 25.w,
                            child: AutoSizeText(
                              'No. of seats: ',
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 3.5.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: MenuButton<Specificationoption>(
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (value) {
                                return Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16),
                                  child: Text(value.name),
                                );
                              },
                              topDivider: true,
                              items: _numberOfSeatList,
                              toggledChild: SizedBox(
                                height: 2.w,
                                child: Text(_selectedSeats),
                              ),
                              showSelectedItemOnList: true,
                              onItemSelected: (value) async {
                                setState(() {
                                  _selectedSeats = value.name;
                                  pageIndex = 0;
                                  _selectedSeatsId = '';
                                  _selectedSeatsId = value.id.toString() + ',';
                                  searchedProducts = [];
                                  searchProducts(
                                      _searchController.text, pageIndex);
                                });
                              },
                              child: normalChildButton(_selectedSeats),
                            ),
                          ),
                          Visibility(
                            visible: _selectedSeatsId.isEmpty ? false : true,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedSeats = '';

                                  _selectedSeatsId = '';
                                  pageIndex = 0;
                                  searchedProducts = [];
                                  searchProducts(
                                      _searchController.text, pageIndex);
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Visibility(
                      visible: _colorList.isEmpty ? false : true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          SizedBox(
                            width: 25.w,
                            child: AutoSizeText(
                              'Color: ',
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 3.5.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: MenuButton<Specificationoption>(
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (value) {
                                return Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16),
                                  child: Text(value.name),
                                );
                              },
                              topDivider: true,
                              items: _colorList,
                              toggledChild: Text(_selectedColors),
                              showSelectedItemOnList: true,
                              onItemSelected: (value) {
                                setState(() {
                                  _selectedColorsId = '';

                                  _selectedColorsId = value.id.toString() + ',';
                                  pageIndex = 0;
                                  _selectedColors = value.name;
                                  searchedProducts = [];
                                });
                                searchProducts(
                                    _searchController.text, pageIndex);
                              },
                              child: normalChildButton(_selectedColors),
                            ),
                          ),
                          Visibility(
                            visible: _selectedColorsId.isEmpty ? false : true,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedColors = '';

                                  _selectedColorsId = '';
                                  pageIndex = 0;
                                  searchedProducts = [];
                                  searchProducts(
                                      _searchController.text, pageIndex);
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Visibility(
                      visible: _familyList.isEmpty ? false : true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          SizedBox(
                            width: 25.w,
                            child: AutoSizeText(
                              'Family: ',
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 3.5.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: MenuButton<Specificationoption>(
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (value) {
                                return Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16),
                                  child: Text(value.name),
                                );
                              },
                              topDivider: true,
                              items: _familyList,
                              toggledChild: Text(_selectedFaimly),
                              showSelectedItemOnList: true,
                              onItemSelected: (value) {
                                setState(() {
                                  _selectedFaimly = value.name;
                                  _selectedFaimlyId = '';
                                  _selectedFaimlyId = value.id.toString() + ',';
                                  pageIndex = 0;
                                  searchedProducts = [];
                                  searchProducts(
                                      _searchController.text, pageIndex);
                                });
                              },
                              child: normalChildButton(_selectedFaimly),
                            ),
                          ),
                          Visibility(
                            visible: _selectedFaimlyId.isEmpty ? false : true,
                            child: IconButton(
                              splashColor: Colors.red,
                              onPressed: () {
                                setState(() {
                                  _selectedFaimly = '';

                                  _selectedFaimlyId = '';
                                  pageIndex = 0;
                                  searchedProducts = [];
                                  searchProducts(
                                      _searchController.text, pageIndex);
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Visibility(
                      visible: _isUAE,
                      child: const SizedBox(
                        height: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Visibility(
                        visible: _isUAE,
                        child: AutoSizeText(
                          'Price Range: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 3.5.w,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Visibility(
                        visible: _isUAE,
                        child: SizedBox(
                          width: 100.w,
                          child: SliderTheme(
                            data: const SliderThemeData(
                              thumbColor: ConstantsVar.appColor,
                              overlayColor: ConstantsVar.appColor,
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                              trackHeight: 2,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 3.0,
                                disabledThumbRadius: 3.0,
                              ),
                            ),
                            child: RangeSlider(
                              activeColor: Colors.red,
                              inactiveColor: Colors.black,
                              min: widget._minPrice!,
                              max: widget._maxPrice!,
                              values: _range,
                              onChanged: (value) {
                                log('$value');
                                setState(() {
                                  _range = value;
                                  _minPRICE =
                                      double.parse(_range.start.toString())
                                          .toStringAsFixed(2)
                                          .toDouble();
                                  _maxPRICE =
                                      double.parse(_range.end.toString())
                                          .toStringAsFixed(2)
                                          .toDouble();
                                  tempMin = _minPRICE!;
                                  tempMax = _maxPRICE!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isUAE,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Min Price: $tempMin'),
                              Text('Max Price: $tempMax'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        /// alignment: Alignment.bottomCenter,
                        child: AppButton(
                          textStyle: const TextStyle(color: Colors.white),
                          height: 4.w,
                          text: 'Apply Filters',
                          color: ConstantsVar.appColor,
                          splashColor: Colors.white,
                          onTap: () {
                            setState(() {
                              noMore = false;
                              _height = 0;
                              isAlreadySet = true;
                              pageIndex = 0;
                              searchedProducts = [];
                              setState(() => isVisible = false);
                            });

                            searchProducts(
                                    _searchController.text.toString(),
                                    0,
                                    _minPRICE.toString() ?? '',
                                    _maxPRICE.toString() ?? '')
                                .then((value) => log(value));
                          },
                          width: 100.w,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  void _toggle() {
    if (mounted) {
      setState(() {
        if (isVisible == true) {
          isVisible = false;
        } else {
          isVisible = true;

          mList.isEmpty
              ? setState(() => _height = 22.h)
              : setState(() => _height = 76.w);
        }
      });
    }
    _focusNode.unfocus();
  }

  Widget normalChildButton(String _name) => SizedBox(
        width: 93,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(_name ?? '', overflow: TextOverflow.ellipsis)),
              const SizedBox(
                width: 12,
                height: 17,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void scrollControllerFunct() async {
    if (_suggestController.hasClients) {
      await _suggestController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void getInitSearch() async {
    await searchProducts(
      widget.keyword,
      0,
    );
  }

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        String listString = ConstantsVar.prefs.getString('searchList') ?? "";

        String _categoryString =
            ConstantsVar.prefs.getString('categoryString') ?? '';
        String _productString =
            ConstantsVar.prefs.getString('productString') ?? '';
        // List<dynamic> testingList = jsonDecode(listString)??[];
        // List<dynamic> _catList = jsonDecode(_categoryString)??[];
        // List<dynamic> _proList = jsonDecode(_productString)??'';
        // categoryList = List<HomePageCategoriesImage>.from(
        //     _catList.map((e) => HomePageCategoriesImage.fromJson(e)).toList())??[];
        // productList = List<HomePageProductImage>.from(
        //     _proList.map((e) => HomePageProductImage.fromJson(e)).toList())??[];
        // searchSuggestions = testingList.cast<String>()??[];
        // log('Product List >>>>>' '$_proList');
      });
    }
  }

  _moveDown() {
    _scrollListController.animateTo(_scrollListController.offset + itemSize,
        curve: Curves.linear, duration: const Duration(milliseconds: 500));
  }
}

class SearchCategories extends StatefulWidget {
  const SearchCategories(
      {Key? key, required this.categoryList, required this.productList})
      : super(key: key);
  final List<HomePageProductImage> productList;

  final List<HomePageCategoriesImage> categoryList;

  @override
  _SearchCategoriesState createState() => _SearchCategoriesState();
}

class _SearchCategoriesState extends State<SearchCategories> {
  @override
  void initState() {
    super.initState();
    initSharedPrefs();
    final postMdl = Provider.of<NewApisProvider>(context, listen: false);
    postMdl.getSearchCategory();
    setState(() {});
  }

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    // await FirebaseAnalytics.instance.logEvent(name: 'screen_view_',parameters: {'screen_name':'Search Screen'});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewApisProvider>(
      builder: (_, value, c) => value.loading == true
          ? const Center(
              child: SpinKitRipple(
                color: ConstantsVar.appColor,
                size: 40,
              ),
            )
          : value.isError
              ? Center(
                  child: AutoSizeText(
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
                )
              : value.searchCategoryList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AutoSizeText(
                          'No Featured Category Available ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: .8,
                              height: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.dp),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 60.0, left: 5, right: 5, bottom: 2),
                      child: Container(
                        color: Colors.white60,
                        padding: const EdgeInsets.all(1),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 2,
                          children: List.generate(
                            value.searchCategoryList.length,
                            (index) => InkWell(
                              onTap: () {
                                value.searchCategoryList[index].isSubCategory ==
                                        false
                                    ? Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ProductList(
                                              categoryId: value
                                                  .searchCategoryList[index].id
                                                  .toString(),
                                              title: value
                                                  .searchCategoryList[index]
                                                  .name),
                                        ),
                                      )
                                    : Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => SubCatNew(
                                            catId: value
                                                .searchCategoryList[index].id
                                                .toString(),
                                            title: value
                                                .searchCategoryList[index].name,
                                          ),
                                        ),
                                      );
                              },
                              child: Card(
                                color: Colors.white,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CachedNetworkImage(
                                            imageUrl: value
                                                .searchCategoryList[index]
                                                .imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, reason) =>
                                                const SpinKitRipple(
                                              color: Colors.red,
                                              size: 90,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: AutoSizeText(
                                          value.searchCategoryList[index].name,
                                          maxLines: 2,
                                          style: TextStyle(
                                              height: 1,
                                              color: Colors.grey.shade700,
                                              fontSize: 4.w,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
    );
  }
}
