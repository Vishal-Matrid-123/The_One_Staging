import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/main_dev.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

class HomeCategory extends StatefulWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;
  Color btnColor = Colors.black;

  final _suggestController = ScrollController();
  List<String> searchSuggestions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final _provider = Provider.of<NewApisProvider>(context, listen: false);
    _provider.getCategoryList(
        context: context,
        // baseUrl:  _baseUrl,
        // storeId: kkStoreId,
        customerId: ConstantsVar.prefs.getString('guestCustomerID')!);
    setState(() {
      searchSuggestions = _provider.searchSuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 18.w,
          backgroundColor: ConstantsVar.appColor,
          // leading: IconButton(
          //     onPressed: () => Navigator.pushAndRemoveUntil(context,
          //             CupertinoPageRoute(builder: (context) {
          //           return MyHomePage();
          //         }), (route) => false),
          //     icon: Icon(Icons.arrow_back)),
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => MyApp()),
                (route) => false),
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: ListView(
            padding: EdgeInsets.only(
              bottom: 16.h,
            ),
            physics: const NeverScrollableScrollPhysics(),
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
                        if (textEditingValue.text == '' ||
                            textEditingValue.text.length < 3) {
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
                                          enableCategory: false, cartIconVisible: true,
                                        ),
                                      ),
                                    )
                                    .then((value) => setState(() {
                                          _searchController.clear();
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
                                                  ),
                                                ),
                                              ).then((value) => setState(() {
                                                    _searchController.clear();
                                                  }));
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
                                                      color:
                                                          Colors.grey.shade400,
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
              SizedBox(
                height: 100.h,
                child: Consumer<NewApisProvider>(
                  builder: (_, value, child) => value.loading == true
                      ? const Center(
                          child: SpinKitRipple(
                            size: 40,
                            color: ConstantsVar.appColor,
                          ),
                        )
                      : value.isError == false
                          ? FlutterSizer(
                              builder: (context, orientation, deviceType) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      color: fromHex('#948a7e'),
                                      padding: EdgeInsets.all(2.h),
                                      child: Center(
                                        child: AutoSizeText(
                                          'SHOP BY CATEGORY',
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset:
                                                      const Offset(1.0, 1.2),
                                                  blurRadius: 3.0,
                                                  color: Colors.grey.shade300,
                                                ),
                                                Shadow(
                                                  offset:
                                                      const Offset(1.0, 1.2),
                                                  blurRadius: 8.0,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ],
                                              fontSize: 5.w,
                                              fontWeight: FontWeight.bold),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        itemCount:
                                            value.categoryList.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index >=
                                              value.categoryList.length) {
                                            return Container(
                                              height: 35.h,
                                            );
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  1.h, 0, 1.h, 2.h),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      //TopLevel Category Details
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                                bottom: 8),
                                                        color:
                                                        fromHex('#948a7e'),
                                                        width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 2.0,
                                                                bottom: 2.0),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  border: Border(
                                                            top: BorderSide(
                                                                width: .3,
                                                                color:
                                                                    Colors.white),
                                                            bottom: BorderSide(
                                                                width: .3,
                                                                color:
                                                                    Colors.white),
                                                          )),
                                                          child: Center(
                                                            child: AutoSizeText(
                                                              value
                                                                  .categoryList[
                                                                      index]
                                                                  .name
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                shadows: <Shadow>[
                                                                  Shadow(
                                                                    offset:
                                                                        const Offset(
                                                                            1.0,
                                                                            1.2),
                                                                    blurRadius:
                                                                        3.0,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                  ),
                                                                  Shadow(
                                                                    offset:
                                                                        const Offset(
                                                                            1.0,
                                                                            1.2),
                                                                    blurRadius:
                                                                        8.0,
                                                                    color:fromHex('#948a7e'),
                                                                  ),
                                                                ],
                                                                fontSize: 5.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    padding:
                                                        const EdgeInsets.only(),
                                                    itemCount: value
                                                        .categoryList[index]
                                                        .sbc
                                                        .length,
                                                    itemBuilder:
                                                        (context, minindex) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 12.0,
                                                        ),
                                                        child: OpenContainer(
                                                          openColor: Colors.transparent,
                                                          useRootNavigator:
                                                              false,
                                                          closedElevation: 2,
                                                          openElevation: 0,
                                                          // padding: EdgeInsets.all(8.0),
                                                          openBuilder: (BuildContext
                                                                  context,
                                                              void Function(
                                                                      {Object?
                                                                          returnValue})
                                                                  action) {
                                                            if (value
                                                                    .categoryList[
                                                                        index]
                                                                    .sbc[
                                                                        minindex]
                                                                    .isSubCategory ==
                                                                true) {
                                                              var id = value
                                                                  .categoryList[
                                                                      index]
                                                                  .sbc[minindex]
                                                                  .id;

                                                              var title = value
                                                                  .categoryList[
                                                                      index]
                                                                  .sbc[minindex]
                                                                  .name;

                                                              return SubCatNew(
                                                                  catId: id
                                                                      .toString(),
                                                                  title: title);
                                                            } else {
                                                              var id = value
                                                                  .categoryList[
                                                                      index]
                                                                  .sbc[minindex]
                                                                  .id;
                                                              var title = value
                                                                  .categoryList[
                                                                      index]
                                                                  .sbc[minindex]
                                                                  .name;

                                                              return ProductList(
                                                                  categoryId: id
                                                                      .toString(),
                                                                  title: title);
                                                            }
                                                          },
                                                          closedBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  void Function()
                                                                      action) {
                                                            return Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: value
                                                                        .categoryList[
                                                                            index]
                                                                        .sbc[
                                                                            minindex]
                                                                        .imageUrl,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: 33.w,
                                                                    height:
                                                                        33.w,
                                                                    placeholder:
                                                                        (context,
                                                                            reason) {
                                                                      return const Center(
                                                                        child:
                                                                            SpinKitRipple(
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              90,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    padding: EdgeInsets
                                                                        .all(2
                                                                            .w),
                                                                    height:
                                                                        18.h,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            value.categoryList[index].sbc[minindex].name.toUpperCase(),
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
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
                                      final _provider =
                                          Provider.of<NewApisProvider>(context,
                                              listen: false);
                                      _provider.getCategoryList(
                                          context: context,
                                          customerId: ConstantsVar.prefs
                                              .getString('guestCustomerID')!);
                                      _dialog.dismiss();
                                    },
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }
}
