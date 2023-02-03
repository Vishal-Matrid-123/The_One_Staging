import 'dart:async';
import 'dart:convert';

// import 'dart:developer';
import 'dart:io' show Platform;

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/RecentlyViewedProductResponse.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/TopicPageResponse/TopicPageResponse.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/home_screen_main.dart';
import 'package:untitled2/AppPages/NewSubCategoryPage/NewSCategoryPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/AppPages/THEOneAds/AdsResponse.dart';
import 'package:untitled2/AppPages/THEOneAds/TheOneAdd.dart';
import 'package:untitled2/AppPages/WebxxViewxx/TopicPagexx.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/NewIcons.dart';
import 'package:untitled2/utils/models/homeresponse.dart';
import 'package:untitled2/utils/utils/build_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

// import '../../models/OrderSummaryResponse.dart';

class NewHomeScreenMain extends StatefulWidget {
  const NewHomeScreenMain({Key? key}) : super(key: key);

  @override
  _NewHomeScreenMainState createState() {
    return _NewHomeScreenMainState();
  }
}

class _NewHomeScreenMainState extends State<NewHomeScreenMain>
    with WidgetsBindingObserver {
  dynamic isFirstTime;

  bool _isError = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        ConstantsVar.prefs.setBool('isFirstTime', true);
        // TODO: Handle this case.
        log(ConstantsVar.prefs.getBool('isFirstTime'));
        log('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        log('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        log('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        ConstantsVar.prefs.setBool('isFirstTime', true);
        // TODO: Handle this case.
        log(ConstantsVar.prefs.getBool('isFirstTime'));
        log('I am detached');
        break;
    }
  }

  final FacebookEvents _fbEvents = FacebookEvents();
  late final FirebaseEvents _fireEvents;
  dynamic _previousTimeStamp;
  String bannerImage = '';
  List<TopicItems> modelList = [];
  List<Bannerxx> banners = [];
  List<HomePageCategoriesImage> categoryList = [];
  List<HomePageProductImage> productList = [];
  AssetImage assetImage = const AssetImage("MyAssets/imagebackground.png");
  List<Widget> viewsList = [];
  int activeIndex = 0;
  bool showLoading = true;
  bool categoryVisible = false;
  List<SocialModel> socialLinks = [];
  List<String> searchSuggestions = [];
  dynamic userId;
  List<Product> products = [];

  TextEditingController _searchController = TextEditingController();
  var _focusNode = FocusNode();

  var isVisible = false;

  Color btnColor = Colors.black;
  final _suggestController = ScrollController();
  String _titleName = '';
  late AdsResponse adsResponse;

  // ScrollController _scrollController = ScrollController();
  String listString = '';
  dynamic cokkie;

  final ScrollController _productController = ScrollController();
  final ScrollController _recentlyProductController = ScrollController();
  final ScrollController _serviceController = ScrollController();
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;
  var isVisibled = false;

  var apiToken = '';
  List<String> _productIds = [];

  // var _recentlyProductController;

  Future initSharedPrefs() async {
    if (mounted) {
      isFirstTime = ConstantsVar.prefs.getBool('isFirstTime') ?? true;
      log('Is First Time:- $isFirstTime');
      setState(() {});
    }
  }

  bool isLoading = true;
  NewApisProvider _provider = NewApisProvider();
  GlobalKey<ProgressHudState> _globalKey = GlobalKey();

  _showLoadingHud(BuildContext context) async {
    _globalKey.currentState?.show(ProgressHudType.loading, "loading...");
    await Future.delayed(const Duration(seconds: 4));
    _globalKey.currentState?.dismiss();
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _provider = Provider.of<NewApisProvider>(context, listen: false);
    _provider.getHomeScreenBanners();
    _provider.getHomeScreenProducts();
    _provider.getHomeScreenCategories();
    _provider.setBogoCategoryValue();
    _provider.readJson();
    _provider.returnInitialPrefix();
    _provider.getBookingStatus();
    getTopicPage();
    getSocialMediaLink();
    // _globalKey.currentState?.show(ProgressHudType.loading, "loading...");
    _showLoadingHud(context);
    if (mounted) {
      //
      _provider.isupdated == false ? setState(() {}) : null;
      log('First Time >>>>>>>>' +
          ConstantsVar.prefs.getBool('isFirstTime').toString());
      initSharedPrefs();
      WidgetsBinding.instance.addObserver(this);
      if (mounted) {

      }

      getApiToken().whenComplete(() async {
        setState(() {});

        showAdDialog().whenComplete(() {
          // await FirebaseAnalytics.instance.logEvent(
          //     name: 'screen_view_', parameters: {'screen_name': 'Home Screen'});
          initSharedPrefs().whenComplete(
            () => getRecentlyViewedProduct(),
          );
        });
      }).then((v) => setState(() {
            isLoading = false;
          }));
      // overlayState!.deactivate();

      // _globalKey.currentState?.dismiss();
      // ApiCa readCounter(customerGuid: gUId).then((value) => context.read<cartCounter>().changeCounter(value));

      /*Facebook events*/
      _fireEvents = FirebaseEvents.initialize(context: context);

      _provider.getSearchSuggestions();
      _fbEvents
          .sendScreenViewData(
            type: "Home Screen",
            id: "Home",
          )
          .whenComplete(
            () => log("Screen event complete"),
          );
      /*Firebase Events*/
      _fireEvents
          .sendScreenViewData(
            screenName: "Home Screen",
          )
          .whenComplete(
            () => log("Firebase Screen Event Complete"),
          );

      ;
    }
    getTopicPage();

    super.initState();
  }

  Future showAdDialog() async {
    String baseUrl = await ApiCalls.getSelectedStore();
    setState(() {
      userId = ConstantsVar.prefs.getString('email');
    });
    log(userId);

    setState(() {
      _previousTimeStamp =
          ConstantsVar.prefs.getString('previousTimeStamp') ?? '';
    });
    log('Show ads popup Customer Id:-${ConstantsVar.prefs.getString(kcustomerIdKey)}');
    final url = Uri.parse(baseUrl +
        'GetHomeScreenPopup?CustId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&StoreId=${await secureStorage.read(key: kselectedStoreIdKey) ?? '1'}');
    log('Ads Url ' + url.toString());
    var customerGuid = ConstantsVar.prefs.getString(kguidKey);
    final String cookie = '.Nop.Customer=' + customerGuid!;

    try {
      var response = await get(url, headers: {'Cookie': cookie});
      log('Ads Response>>>>>' + response.body);
      if (mounted)
        setState(() {
          adsResponse = AdsResponse.fromJson(
            jsonDecode(response.body),
          );

          if (adsResponse.active == true) {
            if ((userId == null || userId == '') && isFirstTime == true) {
              log('Guest user ');
              /*Ads For Guest User for first time*/
              showDialog(
                      // barrierColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return AdsDialog(
                          responseHtml: adsResponse.responseData,
                        );
                      },
                      context: context)
                  .then((value) {});
              ConstantsVar.prefs.setBool('isFirstTime', false);
            } else if ((userId == null || userId == '') &&
                isFirstTime == false) {
              /*Ads For Guest User when ads appeared already*/
              log('Guest user after ads appear once $_previousTimeStamp');
              if (_previousTimeStamp != '' && _previousTimeStamp != null) {
                var _currentTimeStamp = DateTime.now();

                if (adsResponse.active == true &&
                    adsResponse.status.contains('Success') &&
                    _currentTimeStamp
                            .difference(DateTime.parse(_previousTimeStamp))
                            .inHours >=
                        adsResponse.intervalTime) {
                  showDialog(
                          // barrierColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return isVisibled
                                ? Container()
                                : AdsDialog(
                                    responseHtml: adsResponse.responseData,
                                  );
                          },
                          context: context)
                      .then((value) {});
                  log('TimeDifference:-');
                  ConstantsVar.prefs.setString(
                      'previousTimeStamp', _currentTimeStamp.toIso8601String());
                }
              } else {
                log("Sorry Can't show popup now");
                log('Guest user after ads appear once but no time stamp');
                ConstantsVar.prefs.setString(
                    'previousTimeStamp', DateTime.now().toIso8601String());
              }
            } else {
              /*Ads For Login User*/
              log('Logged in  user ');
              if (_previousTimeStamp != '' && _previousTimeStamp != null) {
                var _currentTimeStamp = DateTime.now();

                if (adsResponse.active == true &&
                    adsResponse.status.contains('Success') &&
                    _currentTimeStamp
                            .difference(DateTime.parse(_previousTimeStamp))
                            .inHours >=
                        adsResponse.intervalTime) {
                  showDialog(
                          // barrierColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return isVisibled
                                ? Container()
                                : AdsDialog(
                                    responseHtml: adsResponse.responseData,
                                  );
                          },
                          context: context)
                      .then((value) {});
                  log('TimeDifference:-');
                  ConstantsVar.prefs.setString(
                      'previousTimeStamp', _currentTimeStamp.toIso8601String());
                }
              } else {
                log("Sorry Can't show popup now");

                ConstantsVar.prefs.setString(
                    'previousTimeStamp', DateTime.now().toIso8601String());
              }
            }
          }
        });
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  void _launchURL(String _url) async {
    if (_url.contains('fb')) {
      Platform.isIOS ? forIos(_url) : forAndroid(_url);
    } else {
      await canLaunch(_url)
          ? await launch(
              _url,
              forceWebView: false,
              forceSafariVC: false,
            )
          : Fluttertoast.showToast(msg: 'Could not launch $_url');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _suggestController.dispose();
    _productController.dispose();
    _serviceController.dispose();
    _recentlyProductController.dispose();
    // progressDialog.dismiss();
    log('Hi There I am dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _showOverlay(context);
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        body: buildSafeArea(context),
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        color: Colors.white,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: .1,
                    child: Container(
                      constraints: BoxConstraints.tightFor(
                        width: 100.w,
                        height: 38.h,
                      ),
                      child: Image.asset(
                        "MyAssets/banner.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      // physics: NeverScrollableScrollPhysics(),
                      //   physics: ScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 6),
                          child: SizedBox(
                            width: 100.w,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Hero(
                                tag: 'HomeImage',
                                transitionOnUserGestures: true,
                                child: Image.asset('MyAssets/logo.png',
                                    fit: BoxFit.fill,
                                    width: Adaptive.w(14),
                                    height: Adaptive.w(14)),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Consumer<NewApisProvider>(
                                  builder: (_, value, c) {
                                    return RawAutocomplete<String>(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '' ||
                                            textEditingValue.text.length < 3) {
                                          return const Iterable<String>.empty();
                                        }
                                        return value.searchSuggestions
                                            .where((String option) {
                                          return option.toLowerCase().contains(
                                              RegExp(
                                                  textEditingValue.text
                                                      .toLowerCase(),
                                                  caseSensitive: false));
                                        });
                                      },
                                      onSelected: (String selection) {
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
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
                                                var value =
                                                    _searchController.text;
                                                Navigator.of(context)
                                                    .push(
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            SearchPage(
                                                          isScreen: true,
                                                          keyword: value,
                                                          enableCategory: false,
                                                          cartIconVisible: true,
                                                        ),
                                                      ),
                                                    )
                                                    .then(
                                                        (value) => setState(() {
                                                              _searchController
                                                                  .clear();
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
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 5.w),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 13,
                                            ),
                                            hintText: 'Search here',
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
                                                if (mounted) {
                                                  setState(() {
                                                    var _value =
                                                        _searchController.text;
                                                    Navigator.of(context).push(
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            SearchPage(
                                                          isScreen: true,
                                                          keyword: _value,
                                                          enableCategory: false,
                                                          cartIconVisible: true,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                }
                                              },
                                              child: const Icon(
                                                  Icons.search_sharp),
                                            ),
                                          ),
                                          focusNode: _focusNode,
                                        );
                                      },
                                      optionsViewBuilder: (BuildContext context,
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
                                                      controller:
                                                          _suggestController,
                                                      physics:
                                                          const ScrollPhysics(),
                                                      // padding: EdgeInsets.all(8.0),
                                                      itemCount:
                                                          options.length + 1,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        if (index >=
                                                            options.length) {
                                                          return Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: TextButton(
                                                              child: const Text(
                                                                'Clear',
                                                                style:
                                                                    TextStyle(
                                                                  color: ConstantsVar
                                                                      .appColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
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
                                                        return InkWell(
                                                            onTap: () {
                                                              if (!currentFocus
                                                                  .hasPrimaryFocus) {
                                                                currentFocus
                                                                    .unfocus();
                                                              }
                                                              onSelected(
                                                                  option);
                                                              Navigator.push(
                                                                context,
                                                                CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SearchPage(
                                                                    keyword:
                                                                        option,
                                                                    isScreen:
                                                                        true,
                                                                    enableCategory:
                                                                        false,
                                                                    cartIconVisible:
                                                                        true,
                                                                  ),
                                                                ),
                                                              ).then((value) =>
                                                                  setState(() {
                                                                    _searchController
                                                                        .clear();
                                                                  }));
                                                            },
                                                            child: SizedBox(
                                                              height: 5.8.h,
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
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 2,
                                right: 2,
                                bottom: 4,
                              ),
                              child: Consumer<NewApisProvider>(
                                builder: (context, value, _) => value
                                        .homeBannerLoading
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Card(
                                          child: Shimmer.fromColors(
                                            direction: ShimmerDirection.btt,
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.white,
                                            enabled: true,
                                            child: Container(
                                              color: Colors.grey,
                                              width: 100.w,
                                              height: 45.w,
                                            ),
                                          ),
                                        ),
                                      )
                                    : value.homeBannerError
                                        ? Container(
                                            color: Colors.grey,
                                            width: 100.w,
                                            height: 40.w,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5.w,
                                                  ),
                                                  Text(kerrorString),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      _provider
                                                          .getHomeScreenBanners();
                                                    },
                                                    child: Text(
                                                      'Retry',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : CarouselSlider(
                                            options: CarouselOptions(
                                                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                                                disableCenter: true,
                                                pageSnapping: true,
                                                // height: 24.h,
                                                viewportFraction: 1,
                                                aspectRatio: 4.5 / 2,
                                                autoPlay: true,
                                                enlargeCenterPage: false),
                                            items: value.banners.map((banner) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return InkWell(
                                                    onTap: () {
                                                      String type = banner.type;

                                                      if (type.contains(
                                                          'Category')) {
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (context) =>
                                                                ProductList(
                                                                    categoryId:
                                                                        banner
                                                                            .id,
                                                                    title: ''),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 2.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          errorWidget: (context,
                                                                  error, _) =>
                                                              Center(
                                                            child: AutoSizeText(
                                                              kerrorString,
                                                              style: TextStyle(
                                                                fontSize: 4.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                          ),
                                                          imageUrl:
                                                              banner.imageUrl,
                                                          fit: BoxFit.fill,
                                                          placeholder: (context,
                                                                  reason) =>
                                                              Shimmer
                                                                  .fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors.white,
                                                            child: Container(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        )),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                          ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 7.0),
                              color: Colors.white,
                              height: 60.w,
                              child: Consumer<NewApisProvider>(
                                  builder: (context, value, _c) {
                                if (value.homeProductLoading == true) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                      width: 100.w,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(
                                            3,
                                            (index) => Card(
                                              child: Shimmer.fromColors(
                                                direction: ShimmerDirection.btt,
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.white,
                                                enabled: true,
                                                child: Container(
                                                  color: Colors.grey,
                                                  width: 35.w,
                                                  height: 45.w,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return value.homeProductError == true
                                      ? Container(
                                          color: Colors.grey,
                                          width: 100.w,
                                          height: 40.w,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5.w,
                                                ),
                                                Text(kerrorString),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await _provider
                                                        .getHomeScreenProducts();
                                                  },
                                                  child: Text(
                                                    'Retry',
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  AutoSizeText(
                                                    value.titleHome
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                          offset: const Offset(
                                                              1.0, 1.2),
                                                          blurRadius: 3.0,
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                        Shadow(
                                                          offset: const Offset(
                                                              1.0, 1.2),
                                                          blurRadius: 8.0,
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                      ],
                                                      fontSize: 5.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: VsScrollbar(
                                                style: const VsScrollbarStyle(
                                                    thickness: 3.5),
                                                controller: _productController,
                                                isAlwaysShown: true,
                                                child: ListView.builder(
                                                    controller:
                                                        _productController,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    // padding: EdgeInsets.symmetric(vertical:6),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        value.productListHome.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return listContainer(
                                                          value.productListHome[
                                                              index]);
                                                    }),
                                              ),
                                            ),
                                          ],
                                        );
                                }
                              }),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 7.0),
                              color: Colors.white,
                              child: Consumer<NewApisProvider>(
                                  builder: (context, value, _c) {
                                if (value.homeCategoryLoading == true &&
                                    value.homeScreenCategories.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 100.w,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                2,
                                                (index) => Card(
                                                  child: Shimmer.fromColors(
                                                    direction:
                                                        ShimmerDirection.btt,
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.white,
                                                    enabled: true,
                                                    child: Container(
                                                      color: Colors.grey,
                                                      width: 48.w,
                                                      height: 48.w,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                2,
                                                (index) => Card(
                                                  child: Shimmer.fromColors(
                                                    direction:
                                                        ShimmerDirection.btt,
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.white,
                                                    enabled: true,
                                                    child: Container(
                                                      color: Colors.grey,
                                                      width: 48.w,
                                                      height: 48.w,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                2,
                                                (index) => Card(
                                                  child: Shimmer.fromColors(
                                                    direction:
                                                        ShimmerDirection.btt,
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.white,
                                                    enabled: true,
                                                    child: Container(
                                                      color: Colors.grey,
                                                      width: 48.w,
                                                      height: 48.w,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (value.homeCategoryError == true) {
                                    return Container(
                                      color: Colors.grey,
                                      width: 100.w,
                                      height: 40.w,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5.w,
                                            ),
                                            Text(kerrorString),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await _provider
                                                    .getHomeScreenCategories();
                                              },
                                              child: Text(
                                                'Retry',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(4),
                                      // margin: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: categoriesView(
                                          list: value.homeScreenCategories,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }),
                            ),
                            Visibility(
                              visible:products.isEmpty?false:true,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7.0),
                                color: Colors.white,
                                height: 60.w,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          AutoSizeText(
                                            'Recently Viewed'.toUpperCase(),
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: VsScrollbar(
                                        style: const VsScrollbarStyle(
                                            thickness: 3.5),
                                        controller: _recentlyProductController,
                                        isAlwaysShown: true,
                                        child: ListView.builder(
                                            controller:
                                                _recentlyProductController,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            // padding: EdgeInsets.symmetric(vertical:6),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: products.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _listContainer(
                                                  list: products[index],
                                                  theme: theme);
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: AutoSizeText(
                                  'Our Services'.toUpperCase(),
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
                                      fontSize: 5.w,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Visibility(
                                visible: modelList.isEmpty ? false : true,
                                child: VsScrollbar(
                                  controller: _serviceController,
                                  style:
                                      const VsScrollbarStyle(thickness: 3.5),
                                  isAlwaysShown: true,
                                  child: SingleChildScrollView(
                                    controller: _serviceController,
                                    scrollDirection: Axis.horizontal,
                                    physics: const ScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: modelList
                                            .map((e) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          5.0),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return TopicPage(
                                                          paymentUrl: e.url,
                                                          screenName: ConstantsVar
                                                                  .prefs
                                                                  .getString(
                                                                      'guestGUID') ??
                                                              '',
                                                        );
                                                      }));
                                                    },
                                                    onLongPress: () {},
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                e.imagePath,

                                                                errorListener:
                                                                    () => log(
                                                                        'Something went wrong'),
                                                              ),
                                                              fit:
                                                                  BoxFit.fill,

                                                            ),
                                                          ),
                                                          width: Adaptive.w(
                                                              43.6),
                                                          height:
                                                              Adaptive.w(45),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 2.0,
                                                            vertical: 11,
                                                          ),
                                                          child: SizedBox(
                                                            width: 45.w,
                                                            child:
                                                                AutoSizeText(
                                                              e.textToDisplay,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: 100.w,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AutoSizeText(
                                  'Follow us!'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 5.w,
                                    fontWeight: FontWeight.bold,
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
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 100.w,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: socialLinks
                                        .map((e) => InkWell(
                                            onTap: () async =>
                                                _launchURL(e.url),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6.0,
                                              ),
                                              child: e.icon,
                                            )))
                                        .toList()),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getSocialMediaLink() {
    socialLinks.add(SocialModel(
      icon: Icon(
        Icons.facebook,
        color: Colors.black.withOpacity(.8),
        size: 48,
      ),
      url: 'fb://page/10150150309565478',
      color: Colors.white,
    ));
    socialLinks.add(SocialModel(
      icon: const Icon(
        NewIcons.pinterest__1_,
        size: 42,
      ),
      url: 'https://in.pinterest.com/theoneplanet/_created/',
      color: Colors.red.shade800,
    ));
    socialLinks.add(SocialModel(
      icon: const Icon(
        NewIcons.instagram__8_,
        size: 42,
        // color: Colors.redAccent,
      ),
      url: 'https://www.instagram.com/theoneplanet/',
      color: Colors.white,
    ));
    socialLinks.add(SocialModel(
      icon: const Icon(
        NewIcons.youtube__1_,
        size: 42,
      ),
      url: 'https://www.youtube.com/user/theoneplanet',
      color: Colors.red.shade800,
    ));
    setState(() {});
  }

  Widget listContainer(HomePageProductImage list) {
    ThemeData theme = Theme.of(context);
    if (mounted) {
      return OpenContainer(
        closedElevation: 0,
        clipBehavior: Clip.hardEdge,
        openColor: Colors.transparent,
        closedBuilder: (BuildContext context, void Function() action) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                // height: Adaptive.w(50),
                color: Colors.white,
                width: Adaptive.w(34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        color: Colors.white,
                        width: 33.w,
                        padding: EdgeInsets.all(1.w),
                        height: 33.w,
                        // width: Adaptive.w(32),
                        // height: Adaptive.w(40),
                        child: Hero(
                          tag: 'ProductImage${list.id}',
                          transitionOnUserGestures: true,
                          child: CachedNetworkImage(
                            errorWidget: (context, error, _) => Center(
                              child: AutoSizeText(
                                kerrorString,
                                style: theme.textTheme.headline4,
                              ),
                            ),
                            placeholder: (context,
                                reason) =>
                                Shimmer
                                    .fromColors(
                                  baseColor: Colors
                                      .grey[300]!,
                                  highlightColor:
                                  Colors.white,
                                  child: Container(
                                    color:
                                    Colors.grey,
                                  ),
                                ),
                            imageUrl: list.imageUrl[0],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36.w,
                      child: Center(
                        child: AutoSizeText(
                          list.price.contains('incl')
                              ? list.price.splitBefore('incl')
                              : list.price,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            wordSpacing: 4,
                            color: Colors.grey,
                            fontSize: 4.1.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<NewApisProvider>(
                builder: (ctx, val, _) => !list.parentCategoryId
                            .contains(val.bogoValue) ||
                        val.bogoValue.isEmpty
                    ? Visibility(
                        visible: list.discountPercentage != '' ? true : false,
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
                                      alignment: Alignment.center,
                                      child: Text(
                                        list.discountPercentage,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
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
              ),
            ],
          );
        },
        openBuilder: (BuildContext context,
            void Function({Object? returnValue}) action) {
          return NewProductDetails(
              productId: list.id.toString(), screenName: 'HomeScreen');
        },
        onClosed: (context) async {
          await getRecentlyViewedProduct();
        },
      );
    } else {
      return Container();
    }
  }

  OpenContainer _listContainer(
      {required Product list, required ThemeData theme}) {
    return OpenContainer(
      closedElevation: 0,
      openColor: Colors.transparent,
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return NewProductDetails(
            productId: list.id.toString(), screenName: 'HomeScreen');
      },
      onClosed: (context) async {
        await getRecentlyViewedProduct();
      },
      closedBuilder: (BuildContext context, void Function() action) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              // height: Adaptive.w(50),
              color: Colors.white,
              width: Adaptive.w(34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      color: Colors.white,
                      width: 33.w,
                      padding: EdgeInsets.all(1.w),
                      height: 33.w,
                      // width: Adaptive.w(32),
                      // height: Adaptive.w(40),
                      child: Hero(
                        tag: 'ProductImage${list.id}',
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                          errorWidget: (context, error, _) => Center(
                            child: AutoSizeText(
                              kerrorString,
                              style: TextStyle(
                                fontSize: 4.w,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          placeholder: (context,
                              reason) =>
                              Shimmer
                                  .fromColors(
                                baseColor: Colors
                                    .grey[300]!,
                                highlightColor:
                                Colors.white,
                                child: Container(
                                  color:
                                  Colors.grey,
                                ),
                              ),
                          imageUrl: list.imageUrl[0],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36.w,
                    child: Center(
                      child: AutoSizeText(
                        list.price.splitBefore('incl'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          wordSpacing: 4,
                          color: Colors.grey,
                          fontSize: 4.1.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer<NewApisProvider>(
              builder: (ctx, val, _) =>
                  !list.parentCAtegoryId.contains(val.bogoValue) ||
                          val.bogoValue.isEmpty
                      ? Visibility(
                          visible: list.discountPercent != '' ? true : false,
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
                                        alignment: Alignment.center,
                                        child: Text(
                                          list.discountPercent,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
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
            ),
          ],
        );
      },
    );
  }

  Future<void> getRecentlyViewedProduct() async {
    log('Recently Viewed Products CustomerId:-' +
        ConstantsVar.prefs.getString('guestCustomerID')!);
    if (mounted) {
      setState(() {
        _productIds = ConstantsVar.prefs.getStringList('RecentProducts') ?? [];
      });
    }

    final url = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetRecentlyViewedProducts?CustId=${ConstantsVar.prefs.getString('guestCustomerID')}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');
    var customerGuid = ConstantsVar.prefs.getString(kguidKey);
    final String cookie = '.Nop.Customer=' + customerGuid!;

    log('Recent Url' + url.toString());

    try {
      var jsonResponse = await http.get(
        url,
        headers: {
          'Cookie': cookie +
              ';' +
              '.Nop.RecentlyViewedProducts=${_productIds.join('%2C')}',
        },
      );
      if (jsonDecode(jsonResponse.body)['status'].contains('Success')) {
        log('Recently View Product Headers>>>>>>>>' +
            jsonEncode(jsonResponse.headers));
        if (mounted) {
          RecentlyViewProductResponse _result =
              RecentlyViewProductResponse.fromJson(
            jsonDecode(jsonResponse.body),
          );
          products = _result.products;

          setState(() {});
        }
      } else {
        if (mounted) products = [];

        setState(() {});
      }
      log('Recently Viewed Products>>>>>>>>>>>>>>>>>>>>' + jsonResponse.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      if (mounted) products = [];

      setState(() {});
    }
  }

/* Api call to home screen */
  Future<void> apiCallToHomeScreen(String value) async {
    // getSearchSuggestions();
    // ApiCalls.getRecentlyViewedProduct();
    // var guestCustomerId = ConstantsVar.prefs.getString('guestGUID')!;
    if (mounted) {
      setState(() {
        _isError = false;
      });
    }
    String _baseUrl = await ApiCalls.getSelectedStore();

    log('Home Screen Customer Id:- ${ConstantsVar.prefs.getString('guestCustomerID')}');
    String url = _baseUrl +
        BuildConfig.banners +
        '?CustId=${ConstantsVar.prefs.getString('guestCustomerID')}' +
        kstoreIdVar +
        (await secureStorage.read(key: kselectedStoreIdKey) ?? '1');

    log('home_url $url');
    log('Hi there');
    var customerGuid = ConstantsVar.prefs.getString(kguidKey);
    final String cookie = '.Nop.Customer=' + customerGuid!;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Cookie': cookie},
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          if (mounted) {
            setState(() {
              _isError = true;
            });
          }
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
// response.headers                                                           Firebase Screen Event Complete
      if (response.statusCode == 200) {
        mounted
            ? setState(() {
                showLoading = false;
                _isError = false;
              })
            : null;
        log('Home Screen Response>>>>>' + response.body);

        if (jsonDecode(response.body)['status']
            .toString()
            .toLowerCase()
            .contains('failed')) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          if (mounted) {
            setState(() {
              _isError = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isError = false;
              categoryVisible = true;
            });
          }
          HomeResponse1 homeResponse = HomeResponse1.fromJson(
              jsonDecode(jsonDecode(response.body)['ResponseData']));
          if (homeResponse.banners.isEmpty ||
              homeResponse.homePageCategoriesImage.isEmpty ||
              homeResponse.homePageProductImage.isEmpty ||
              homeResponse.homepageProductsTitle == '') {
            log('NULL NO VALUE return');
          } else {
            _titleName = homeResponse.homepageProductsTitle;
            banners = homeResponse.banners;
            mounted
                ? setState(() {
                    var products = homeResponse.homePageProductImage;
                    var categories = homeResponse.homePageCategoriesImage;
                    if (products.isNotEmpty) {
                      productList = products;
                      categoryList = categories;
                      String _categoryString = jsonEncode(categoryList);
                      String _productString = jsonEncode(productList);
                      ConstantsVar.prefs
                          .setString('productString', _productString);
                      ConstantsVar.prefs
                          .setString('categoryString', _categoryString);

                      // getServiceList();

                      for (var i = 0; i < categoryList.length; i++) {
                        if (i % 2 == 0) {
                          viewsList.add(
                            categroryLeftView(
                                categoryList[i].name,
                                categoryList[i].imageUrl,
                                categoryList[i].id,
                                categoryList[i].isSubCategory),
                          );
                        } else {
                          viewsList.add(
                            categoryRightView(
                                categoryList[i].name,
                                categoryList[i].imageUrl,
                                categoryList[i].id.toString(),
                                categoryList[i].isSubCategory),
                          );
                        }
                      }
                    }
                  })
                : viewsList.add(
                    const Center(child: Text('Something Went Wrong')),
                  );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            showLoading = false;
          });
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
    }
  }

  Widget categroryLeftView(
      String name, String imageUrl, final categoryId, final type) {
    // ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),

      // padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            OpenContainer(
              onClosed: (context) async {
                await getRecentlyViewedProduct();
              },
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              openColor: Colors.transparent,
              transitionType: _transitionType,
              closedBuilder: (BuildContext context, void Function() action) {
                return SizedBox(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    errorWidget: (context, error, _) => Center(
                      child: AutoSizeText(
                        kerrorString,
                        style: TextStyle(
                          fontSize: 4.w,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    placeholder: (context,
                        reason) =>
                        Shimmer
                            .fromColors(
                          baseColor: Colors
                              .grey[300]!,
                          highlightColor:
                          Colors.white,
                          child: Container(
                            color:
                            Colors.grey,
                          ),
                        ),
                  ),
                );
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: '$categoryId',
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }
              },
            ),
            OpenContainer(
              onClosed: (context) async {
                await getRecentlyViewedProduct();
              },
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              transitionType: _transitionType,
              openColor: Colors.transparent,
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: '$categoryId',
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: '$categoryId',
                    title: name,
                  );
                }
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return SizedBox(
                  width: Adaptive.w(48),
                  height: Adaptive.w(45),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: Adaptive.w(48),
                          height: Adaptive.w(45),
                          color: Colors.black,
                          // height: 12.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 4.w),
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  AutoSizeText(
                                    name.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: SizedBox(
                                      width: 15.w,
                                      child: const Divider(
                                          height: 2, color: Colors.white),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: AutoSizeText('Shop Now',
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: Image.asset('MyAssets/icon.png')),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryRightView(
      String name, String imageUrl, final String categoryId, final type) {
    // ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            OpenContainer(
              onClosed: (context) async {
                await getRecentlyViewedProduct();
              },
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              openColor: Colors.transparent,
              transitionType: _transitionType,
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: categoryId,
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: categoryId,
                    title: name,
                  );
                }
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return SizedBox(
                  width: Adaptive.w(48),
                  height: Adaptive.w(45),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 11.0),
                        child: Container(
                          width: Adaptive.w(48),
                          height: Adaptive.w(45),
                          color: Colors.black,
                          // height: 12.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 4.w),
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  AutoSizeText(
                                    name.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: SizedBox(
                                      width: 15.w,
                                      child: const Divider(
                                          height: 2, color: Colors.white),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: AutoSizeText('Shop Now',
                                        style: TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            width: 10.w,
                            height: 10.w,
                            child: Image.asset(
                              'MyAssets/icon1.png',
                              fit: BoxFit.fill,
                            )),
                      )
                    ],
                  ),
                );
              },
            ),
            OpenContainer(
              onClosed: (context) async {
                await getRecentlyViewedProduct();
              },
              tappable: true,
              closedElevation: 0,
              openElevation: 0,
              openColor: Colors.transparent,
              transitionType: _transitionType,
              closedBuilder: (BuildContext context, void Function() action) {
                return SizedBox(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child: CachedNetworkImage(
                    errorWidget: (context, error, _) => Center(
                      child: AutoSizeText(
                        kerrorString,
                        style: TextStyle(
                          fontSize: 4.w,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    placeholder: (context,
                        reason) =>
                        Shimmer
                            .fromColors(
                          baseColor: Colors
                              .grey[300]!,
                          highlightColor:
                          Colors.white,
                          child: Container(
                            color:
                            Colors.grey,
                          ),
                        ),
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                  ),
                );
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                if (type == true) {
                  return SubCatNew(
                    catId: categoryId,
                    title: name,
                  );
                } else {
                  return ProductList(
                    categoryId: categoryId,
                    title: name,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> categoriesView({required List<HomePageCategoriesImage> list}) {
    List<Widget> _viewsList = [];

    for (var i = 0; i < list.length; i++) {
      if (i % 2 == 0) {
        _viewsList.add(
          categroryLeftView(list[i].name, list[i].imageUrl,
              list[i].id, list[i].isSubCategory),
        );
      } else {
        _viewsList.add(
          categoryRightView(list[i].name, list[i].imageUrl,
              list[i].id.toString(), list[i].isSubCategory),
        );
      }
    }
    return _viewsList;
  }

  Future getApiToken() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    // setState(() {});

    return ConstantsVar.prefs.get('apiTokken');
  }

  void navigate(Widget className) => Navigator.push(
      context, CupertinoPageRoute(builder: (context) => className));

  void _scrollToBottom() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (_serviceController.hasClients) {
        _serviceController.animateTo(modelList.length + 30.w,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut);
      } else {
        Timer(const Duration(milliseconds: 400), () => _scrollToBottom());
      }
    });
  }

  Future<void> getTopicPage() async {
    if (mounted)
      log('Topic Page Customer Id:- ${ConstantsVar.prefs.getString('guestCustomerID')}');
    var customerGuid = ConstantsVar.prefs.getString(kguidKey);
    final String cookie = '.Nop.Customer=' + customerGuid!;
    final uri = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetAppTopics?CustId=${ConstantsVar.prefs.getString('guestCustomerID')}&apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');
    log('Topic Page Url:- $uri');
    try {
      var response = await http.get(uri, headers: {'Cookie': cookie});
      log("Topic Response>>>>>" + response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusSuccess) {
          if (mounted) {
            setState(() {
              TopicPageResponse result = TopicPageResponse.fromJson(
                jsonDecode(response.body),
              );
              modelList = result.responseData;
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)["Message"].toString(),
              toastLength: Toast.LENGTH_LONG);
        }
      } else {
        Fluttertoast.showToast(
            msg: kerrorString + " Status Code: ${response.statusCode}",
            toastLength: Toast.LENGTH_LONG);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  forIos(String _url) async {
    await canLaunch(_url)
        ? await launch(
            _url,
            forceWebView: false,
            forceSafariVC: false,
          )
        : await launch(
            'fb://profile/10150150309565478',
            forceWebView: false,
            forceSafariVC: false,
          );
  }

  forAndroid(String _url) async {
    await canLaunch(_url)
        ? await launch(
            _url,
            forceWebView: false,
            forceSafariVC: false,
          )
        : Fluttertoast.showToast(msg: 'Could not launch $_url');
  }

  final itemSize = 45.w;
}
