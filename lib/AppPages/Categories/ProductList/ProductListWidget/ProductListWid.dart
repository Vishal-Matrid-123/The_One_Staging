// import 'dart:html';

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/HeartIcon.dart';

import '../../../../new_apis_func/data_layer/new_model/new_product_list_response/new_product_list_response.dart';
import '../SubCatProducts.dart';

class ProdListWidget extends StatefulWidget {
  ProdListWidget({
    Key? key,
    required this.products,
    required this.title,
    required this.id,
    required this.pageIndex,
    required this.productCount,
  }) : super(key: key);
  List<ProductListResponse> products;
  final String title;
  FocusNode focusNode = FocusNode();

  // dynamic result;
  final int pageIndex;
  final String id;
  final int productCount;

  RefreshController myController = RefreshController();

  @override
  _ProdListWidgetState createState() => _ProdListWidgetState();
}

class _ProdListWidgetState extends State<ProdListWidget> {
  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        // String listString = ConstantsVar.prefs.getString('searchList')!??'';
        // // print(listString);
        // List<dynamic> testingList = jsonDecode(listString)??[];
        // searchSuggestions = testingList.cast<String>();
        //
      });
    }
  }

  List<String> searchSuggestions = [];
  var pageIndex1 = 1;

  bool isLoading = true;

  Color btnColor = Colors.black;

  final _suggestController = ScrollController();

  TextEditingController _searchController = TextEditingController();

  final bool _isGiftCard = false;
  final bool _isProductAttributeAvail = false;

  void _onLoading() async {
    final _provider = Provider.of<NewApisProvider>(context, listen: false);
    log('object');
    if (widget.products.length == widget.productCount) {
      widget.myController.loadComplete();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        pageIndex1 = pageIndex1 + 1;
        log('$pageIndex1');

        _provider.getProductList(
            // storeId: kkStoreId,
            // baseUrl: kkBaseUrl,
            catId: widget.id,
            pageIndex: pageIndex1,
            isLoading: true);
      });

      // monitor network fetch

      // if failed,use loadFailed(),if no data return,use LoadNodata()
      //   if(widget.myController.)
      if (mounted) setState(() {});
      widget.myController.loadComplete();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    pageIndex1 = widget.pageIndex;
    initSharedPrefs();
                                          print(jsonEncode(widget.products));
    final provider = Provider.of<NewApisProvider>(context, listen: false);
    provider.setBogoCategoryValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        Platform.isIOS ? checkBackSwipe(details) : log('Android Here');
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
                child: Consumer<NewApisProvider>(
                  builder: (_, value, c) => RawAutocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return value.searchSuggestions.where((String option) {
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
                        FocusNode focusNodee,
                        VoidCallback onFieldSubmitted) {
                      _searchController = textEditingController;
                      widget.focusNode = focusNodee;
                      // FocusScopeNode currentFocus = FocusScopeNode.of(context);
                      return TextFormField(
                        autocorrect: true,
                        enableSuggestions: true,
                        onFieldSubmitted: (val) {
                          widget.focusNode.unfocus();
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
                                        _searchController.clear();
                                      }));
                            });
                          }

                          log('Pressed via keypad');
                        },
                        textInputAction: TextInputAction.search,
                        // keyboardType: TextInputType.,
                        keyboardAppearance: Brightness.light,
                        // autofocus: true,
                        onChanged: (_) => setState(() {
                          btnColor = ConstantsVar.appColor;
                        }),
                        controller: _searchController,
                        style: TextStyle(color: Colors.black, fontSize: 5.w),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          hintText: 'Search here',
                          labelStyle:
                              TextStyle(fontSize: 7.w, color: Colors.grey),
                          suffixIcon: InkWell(
                            onTap: () async {
                              widget.focusNode.unfocus();

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
                                      .then(
                                        (value) => setState(() {
                                          _searchController.clear();
                                        }),
                                      );
                                });
                              }
                            },
                            child: const Icon(Icons.search_sharp),
                          ),
                        ),
                        focusNode: widget.focusNode,
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
                                                color: ConstantsVar.appColor,
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
                                                          enableCategory: false,
                                                          cartIconVisible: true,
                                                        ))).then(
                                              (value) => setState(
                                                () {
                                                  _searchController.clear();
                                                },
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 5.2.h,
                                            width: 95.w,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
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
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )

                                          // ListTile(
                                          //   title: Text(option),
                                          //   subtitle: Container(
                                          //     width: 100.w,
                                          //     child: Divider(
                                          //       thickness: 1,
                                          //       color:
                                          //           ConstantsVar.appColor,
                                          //     ),
                                          //   ),
                                          // ),
                                          );
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
          ),
          ListTile(
            title: Center(
              child: AutoSizeText(
                widget.title,
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
          Expanded(
            child: SizedBox(
              width: 100.w,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CupertinoScrollbar(
                  isAlwaysShown: true,
                  child: SmartRefresher(
                    onLoading: () async => _onLoading(),
                    controller: widget.myController,
                    footer: CustomFooter(
                      builder: (context, mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const SpinKitRipple(
                            color: Colors.red,
                            size: 90,
                          );
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = const AutoSizeText("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const AutoSizeText("release to load more");
                        } else {
                          body = const AutoSizeText("No more Data");
                        }
                        return SizedBox(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    enablePullDown: false,
                    enablePullUp: isLoading,
                    enableTwoLevel: false,
                    physics: const ClampingScrollPhysics(),
                    child: GridView.count(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: false,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 6,
                      cacheExtent: 20,
                      children: List.generate(
                        widget.products.length,
                        (index) {
                          return Stack(
                            children: [
                              Card(
                                // elevation: 2,
                                child: OpenContainer(
                                  closedElevation: 2,
                                  openColor:Colors.transparent,
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return NewProductDetails(
                                      productId:
                                          widget.products[index].id.toString(),
                                      screenName: 'Product List',
                                      // customerId: ConstantsVar.customerID,
                                    );
                                  },
                                  closedBuilder: (BuildContext context,
                                      void Function() action) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints.tightFor(
                                            width: 42.w,
                                            height: 42.w,
                                          ),
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(4.0),
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .products[index].productPicture,
                                            fit: BoxFit.cover,
                                            placeholder: (context, reason) =>
                                                const SpinKitRipple(
                                              color: Colors.red,
                                              size: 90,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 8.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // color: Color(0xFFe0e1e0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // sorry mam nahi hua!
                                              Container(
                                                child: Text(
                                                  widget.products[index].name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  // minFontSize:.w,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 4.5.w,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                        width: 48.w,
                                                        height: 18.w),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                      widget.products[index]
                                                                  .discountedPrice ==
                                                              ''
                                                          ? widget
                                                              .products[index]
                                                              .price
                                                          : widget
                                                              .products[index]
                                                              .discountedPrice,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          height: 1,
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontSize: 4.w,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Consumer<NewApisProvider>(
                                          builder: (ctx, val, _) => AddCartBtn(
                                            categoryId: widget.products[index]
                                                    .parentCategoryId,
                                            productId: widget.products[index].id
                                                .toString(),
                                            // width: 2.w,
                                            isTrue: true,
                                            guestCustomerId: '',
                                            checkIcon: widget.products[index]
                                                    .stockQuantity
                                                    .contains('Out of stock')
                                                ? const Icon(HeartIcon.cross)
                                                : const Icon(Icons.check),
                                            text: widget.products[index]
                                                    .stockQuantity
                                                    .contains('Out of stock')
                                                ? 'Out of Stock'.toUpperCase()
                                                : 'ADD TO CArt'.toUpperCase(),
                                            color: widget.products[index]
                                                    .stockQuantity
                                                    .contains('Out of stock')
                                                ? Colors.grey
                                                : ConstantsVar.appColor,
                                            isGiftCard: _isGiftCard,
                                            isProductAttributeAvail:
                                                _isProductAttributeAvail,
                                            attributeId: '',
                                            recipEmail: '',
                                            email: '',
                                            message: '',
                                            name: '',
                                            recipName: '',
                                            storeId: '',

                                            productName:
                                                widget.products[index].name,
                                            productPrice: widget
                                                .products[index].priceValue,
                                              minQuantity: widget.products[index].minimumQuantity.toString(),
                                            // fontSize: 12,
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Consumer<NewApisProvider>(
                                builder: (ctx, val, _) => !widget
                                        .products[index].parentCategoryId
                                        .contains(val.bogoValue) || val.bogoValue.isEmpty
                                    ? Visibility(
                                        visible: widget.products[index]
                                                    .discountPercent !=
                                                ''
                                            ? true
                                            : false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: SizedBox(
                                                width: 14.w,
                                                height: 14.w,
                                                child: Stack(
                                                  children: [
                                                    Image.asset(
                                                      'MyAssets/plaincircle.png',
                                                      width: 15.w,
                                                      height: 15.w,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        widget.products[index]
                                                            .discountPercent,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 4.8.w,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: SizedBox(
                                              width: 14.w,
                                              height: 14.w,
                                              child: Image.asset(
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
            ),
          ),
        ],
      ),
    );
  }

  checkBackSwipe(DragUpdateDetails details) {
    if (details.delta.direction <= 0) {
      Navigator.pop(context);
    }
  }
}
