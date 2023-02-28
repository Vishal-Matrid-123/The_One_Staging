import 'dart:async';
import 'dart:collection';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeCategory/HomeCategory.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreenMain/home_screen_main.dart';
import 'package:untitled2/AppPages/NavigationPage/MenuPage.dart';
import 'package:untitled2/AppPages/SearchPage/SearchPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/PojoClass/GridViewModel.dart';
import 'package:untitled2/PojoClass/itemGridModel.dart';
import 'package:untitled2/utils/CartBadgeCounter/CartBadgetLogic.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> setFireStoreData(
    RemoteMessage message,
  ) async {
    final refrence = FirebaseFirestore.instance.collection('UserNotifications');
    String formattedDate =
        DateFormat('dd-MM-yyyy – hh:mm').format(message.sentTime!);
    Map<String, dynamic> data = {
      'Title': message.notification!.title,
      'Desc': message.notification!.body,
      'Time': Timestamp.fromDate(message.sentTime!)
    };
    refrence.add(data);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(
        builder: (context, ori, deviceType) => MyHomePage(
          pageIndex: 0,
        ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.pageIndex});

  int pageIndex;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  List<GridViewModel> mList = [];
  List<GridPojo> mList1 = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();
  var activeIndex = 0;

  ListQueue<int> _navQueue = new ListQueue();

  @override
  void initState() {
    super.initState();

    setState(() => activeIndex = widget.pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: WillPopScope(
        onWillPop: () async {
          if (activeIndex == 0) return true;
          setState(() {
            activeIndex = 0;
          });

          return false;

          if (_navQueue.isEmpty) return true;
          setState(() {
            activeIndex = _navQueue.last;
            _navQueue.removeLast();
          });

          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: getBodies(activeIndex),
          ),
          bottomNavigationBar: Container(
            color: Colors.black,
            height: 50,
            child: RollingNavBar.iconData(
              activeIconColors: const [
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
                Colors.white,
              ],
              activeIndex: activeIndex,
              badges: [
                null,
                null,
                null,
                Consumer<CartCounter>(builder: (context, value, child) {
                  return Text(
                    value.badgeNumber.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  );
                }),
                null
              ],
              iconData: const <IconData>[
                Icons.home_filled,
                Icons.shopping_bag,
                Icons.search,
                Icons.shopping_cart,
                Icons.menu,
              ],
              indicatorColors: const <Color>[
                ConstantsVar.appColor,
                ConstantsVar.appColor,
                ConstantsVar.appColor,
                ConstantsVar.appColor,
                ConstantsVar.appColor,
              ],
              iconText: const <Widget>[
                Text('Home',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Products',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Search',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Cart',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
                Text('Profile',
                    style: TextStyle(color: Colors.black, fontSize: 11)),
              ],
              onTap: (index) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  bool get wantKeepAlive => false;

  Widget getBodies(int index) {
    switch (index) {
      case 0:
        return const HomeScreenMain();
      case 1:
        return const HomeCategory();
      case 2:
        return SearchPage(
          keyword: '',
          isScreen: false,
          enableCategory: true, cartIconVisible: false,
        );
      case 3:
        return const CartScreen2(
          isOtherScren: false,
          otherScreenName: '',
        );
      case 4:
        return const MenuPage();
      default:
        return Container(
          child: const Center(
            child: const Text('Wrong Route'),
          ),
        );
    }
  }
}
