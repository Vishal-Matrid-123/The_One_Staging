import 'dart:developer';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
// import 'package:untitled2/AppPages/NewSubCategoryPage/ModelClass/NewSubCatProductModel.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/main_dev.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../new_apis_func/data_layer/new_model/new_subcateroy_response/new_subcategory_response.dart';

class SubCatNew extends StatefulWidget {
  const SubCatNew({Key? key, required String catId, required String title})
      : _catId = catId,
        _title = title,
        super(key: key);
  final String _catId;
  final String _title;

  @override
  _SubCatNewState createState() => _SubCatNewState();
}

class _SubCatNewState extends State<SubCatNew> {
  List<dynamic> myList = [];
  String customerId = '';
  late bool isSubCategory;

  bool isShown = false;

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;

  Color btnColor = Colors.black;

  final _suggestController = ScrollController();

  Future<void> initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        // String listString = ConstantsVar.prefs.getString('searchList')!??'';
        // // print(listString);
        // List<dynamic> testingList = jsonDecode(listString);
        // searchSuggestions = testingList.cast<String>();
        // log(searchSuggestions.length.toString());
      });
    }
  }

  List<String> searchSuggestions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("SubCatNew Screen is Here");
    initSharedPrefs().whenComplete(
      () {
        final _provider = Provider.of<NewApisProvider>(context, listen: false);
        _provider.getSubcategoryList(
          context: context,
          catId: widget._catId,
        );
        setState(() {
          searchSuggestions = _provider.searchSuggestions;
        });
      },
    );
    log(widget._catId);

    // getSubCategories(widget.catId);
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
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
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            Platform.isIOS ? checkBackSwipe(details) : log('Android Here');
          },
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              SizedBox(
                height: 100.h,
                child: Consumer<NewApisProvider>(
                  builder: (_, value, c) {
                    if (value.loading) {
                      return const Center(
                        child: SpinKitRipple(
                          color: ConstantsVar.appColor,
                          size: 40,
                        ),
                      );
                    } else {
                      return value.isSubCategoryScreenError == true
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
                                      await _provider.getSubcategoryList(
                                        context: context,
                                        catId: widget._catId,
                                      );
                                      _dialog.dismiss();
                                    },
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            )
                          : SubCatWidget(
                              title: widget._title,
                              myList: value.subCategoryList,
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkBackSwipe(DragUpdateDetails details) {
    if (details.delta.direction <= 0) {
      Navigator.pop(context);
    }
  }
}

class SubCatWidget extends StatefulWidget {
  const SubCatWidget({
    Key? key,
    required this.title,
    required this.myList,
  }) : super(key: key);
  final String title;
  final List<SubcategoriesData> myList;

  @override
  _SubCatWidgetState createState() => _SubCatWidgetState();
}

class _SubCatWidgetState extends State<SubCatWidget> {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: fromHex('#948a7e'),
            padding: EdgeInsets.all(2.h),
            child: Center(
              child: AutoSizeText(
                widget.title.toString().toUpperCase(),
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
                softWrap: true,
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: widget.myList.length,
          shrinkWrap: false,
          padding: const EdgeInsets.only(bottom: 220),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: OpenContainer(
                closedElevation: 2,
                openElevation: 0,
                middleColor: Colors.white,
                transitionType: _transitionType,
                openColor: Colors.transparent,
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  if (widget.myList[index].isSubcategory == true) {
                    log('I am going to Subcategory Page');
                    return SubCatNew(
                        catId: widget.myList[index].id.toString(),
                        title: widget.myList[index].name);
                  } else {
                    log('I am going to Product Page');
                    return ProductList(
                      categoryId: widget.myList[index].id.toString(),
                      title: widget.myList[index].name,
                    );
                  }
                },
                closedBuilder: (BuildContext context, void Function() action) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.myList[index].pictureUrl,
                              fit: BoxFit.fill,
                              width: 33.w,
                              height: 33.w,
                              placeholder: (context, reason) {
                                return const Center(
                                  child: SpinKitRipple(
                                    color: Colors.red,
                                    size: 90,
                                  ),
                                );
                              },
                            ),
                          )),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(2.w),
                          height: 18.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: AutoSizeText(
                                  widget.myList[index].name
                                      .toString()
                                      .toUpperCase(),
                                  // maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
        )),
      ],
    );
  }
}
