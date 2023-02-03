import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/AppPages/AppWishlist/WishList.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/ContactsUS/ContactsUS.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/NotificationxxScreen/Notification_Screen.dart';
import 'package:untitled2/AppPages/Registration/RegistrationPage.dart';

// import 'package:untitled2/AppPages/SearchPage/NewSearchPage.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/HeartIcon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/ApiCalls/ApiCalls.dart';

enum AniProps { color }

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var color1 = ConstantsVar.appColor;
  var color2 = Colors.black54;
  late Animation<double> size;
  bool isLoadVisible = false;
  bool isListVisible = false;
  bool isLoading = true;
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
  Color topColor = ConstantsVar.appColor;
  Color bottomColor = Colors.black26;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  Color btnColor = Colors.black;
  int pageIndex = 0;
  var customerId;
  var userName, email, phnNumber;

  bool isEmailVisible = false,
      isPhoneNumberVisible = false,
      isUserNameVisible = false;

  var customerGuid;

  // var gUId;

  // RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    // TODO: implement initState
    getCustomerId();
    setState(() {
      customerId = ConstantsVar.prefs.getString('userId');
      email = ConstantsVar.prefs.getString('email');
      userName = ConstantsVar.prefs.getString('userName');
      phnNumber = ConstantsVar.prefs.getString('phone');
      customerGuid = ConstantsVar.prefs.getString(kguidKey);

      ApiCalls.readCounter(context: context);

      isEmailVisible = true;
      isPhoneNumberVisible = true;
      isUserNameVisible = true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ConstantsVar.appColor,
        toolbarHeight: 18.w,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.arrow_back),
        // ),
        title: InkWell(
          onTap: () => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => MyHomePage(
                  pageIndex: 0,
                ),
              ),
              (route) => false),
          child: Image.asset(
            'MyAssets/logo.png',
            width: 15.w,
            height: 15.w,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white,
                width: 100.w,
                height: 100.h,
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 4.w),
                          child: DelayedDisplay(
                            delay: const Duration(milliseconds: 50),
                            slidingBeginOffset: const Offset(
                              -1,
                              0,
                            ),
                            child: Container(
                              color: Colors.white,
                              width: 100.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: !isUserNameVisible ? 10 : 0),
                                    child: Container(
                                      width: 100.w,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Welcome to THE One',
                                          textAlign: TextAlign.center,
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
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userName == null ? false : true,
                                    child: Container(
                                      width: 100.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100.w,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: userName == null
                                                      ? false
                                                      : true,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Visibility(
                                                  visible: userName == null
                                                      ? false
                                                      : true,
                                                  child: AutoSizeText(
                                                    userName == null
                                                        ? ''
                                                        : userName,
                                                    style: TextStyle(
                                                        shadows: <Shadow>[
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                    1.0, 1.2),
                                                            blurRadius: 3.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                    1.0, 1.2),
                                                            blurRadius: 8.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ],
                                                        fontSize: 5.w,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Visibility(
                                            visible:
                                                email == null ? false : true,
                                            child: Container(
                                              width: 100.w,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  const Icon(
                                                    Icons.email,
                                                    color:
                                                        ConstantsVar.appColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  AutoSizeText(
                                                    email == null ? '' : email,
                                                    style: TextStyle(
                                                        shadows: <Shadow>[
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                    1.0, 1.2),
                                                            blurRadius: 3.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                    1.0, 1.2),
                                                            blurRadius: 8.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ],
                                                        fontSize: 5.w,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Visibility(
                                            visible: phnNumber == null
                                                ? false
                                                : true,
                                            child: Container(
                                              width: 100.w,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.phone,
                                                      color: ConstantsVar
                                                          .appColor),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  AutoSizeText(
                                                    phnNumber == null
                                                        ? ''
                                                        : phnNumber,
                                                    style: TextStyle(
                                                        shadows: <Shadow>[
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                    1.0, 1.2),
                                                            blurRadius: 3.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                    1.0, 1.2),
                                                            blurRadius: 8.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ],
                                                        fontSize: 5.w,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                      ],
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MyAccount())),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    Icons.account_circle_sharp,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    'My Account'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const CartScreen2(
                                        otherScreenName: 'Cart Screen2',
                                        isOtherScren: true,
                                      )));
                          if (result == true) {
                            setState(() {
                              customerId =
                                  ConstantsVar.prefs.getString('userId');
                              email = ConstantsVar.prefs.getString('email');
                              userName =
                                  ConstantsVar.prefs.getString('userName');
                              phnNumber = ConstantsVar.prefs.getString('phone');
                              isPhoneNumberVisible = true;
                              isUserNameVisible = true;
                              isEmailVisible = true;
                            });
                          }
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    'My Cart'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const WishlistScreen(),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: ConstantsVar.appColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                AutoSizeText(
                                  'Wishlist'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    const NotificationClass())),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    Icons.notifications,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    'notifications'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () {
                          customerId == '' || customerId == null
                              ? Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => RegstrationPage()))
                              : Fluttertoast.showToast(
                                  msg: 'You are already logged in.',
                                  toastLength: Toast.LENGTH_LONG,
                                );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    HeartIcon.user,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    'Register'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ContactUS(
                                id: '',
                                name: '',
                                desc: '',
                                boolValue: false,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    Icons.connect_without_contact,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    'Contact Us'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () async => _launchURL(
                            'https://www.theone.com/privacy-policy-uae'),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    Icons.visibility,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    'PRIVACY POLICY',
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(
                        milliseconds: 70,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (customerId == '' || customerId == null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LoginScreen(
                                  screenKey: 'Menu Page',
                                ),
                              ),
                            );
                          } else {
                            clearUserDetails()
                                .whenComplete(() => Phoenix.rebirth(context));
                          }
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.w,
                              horizontal: 8.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Card(
                                  child: Icon(
                                    HeartIcon.logout,
                                    color: ConstantsVar.appColor,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  // color: Colors.white,
                                  child: AutoSizeText(
                                    customerId == '' || customerId == null
                                        ? 'login'.toUpperCase()
                                        : 'logout'.toUpperCase(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
               
                    // Visibility(
                    //   visible: true,
                    //   child: DelayedDisplay(
                    //     delay: const Duration(
                    //       milliseconds: 70,
                    //     ),
                    //     child: InkWell(
                    //       onTap: () {
                    //         // FirebaseCrashlytics.instance.crash();
                    //
                    //         final provider = Provider.of<NewApisProvider>(context,listen: false);
                    //         provider.showMaterialDialogBox(context: context) ;
                    //       },
                    //       child: Card(
                    //         color: Colors.white,
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(
                    //             vertical: 6.w,
                    //             horizontal: 8.w,
                    //           ),
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               const Card(
                    //                 child: Icon(
                    //                   Icons.search,
                    //                   color: ConstantsVar.appColor,
                    //                   size: 34,
                    //                 ),
                    //               ),
                    //               const SizedBox(
                    //                 width: 20,
                    //               ),
                    //               Container(
                    //                 // color: Colors.white,
                    //                 child: AutoSizeText(
                    //                   'MAterial Dialog Box'.toUpperCase(),
                    //                   style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 5.w,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Visibility(
                    //   visible: true,
                    //   child: DelayedDisplay(
                    //     delay: const Duration(
                    //       milliseconds: 70,
                    //     ),
                    //     child: InkWell(
                    //       onTap: () {
                    //         // FirebaseCrashlytics.instance.crash();
                    //
                    //         final provider = Provider.of<NewApisProvider>(context,listen: false);
                    //         provider.showCupertinoAlertaDialog(context: context) ;
                    //       },
                    //       child: Card(
                    //         color: Colors.white,
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(
                    //             vertical: 6.w,
                    //             horizontal: 8.w,
                    //           ),
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               const Card(
                    //                 child: Icon(
                    //                   Icons.search,
                    //                   color: ConstantsVar.appColor,
                    //                   size: 34,
                    //                 ),
                    //               ),
                    //               const SizedBox(
                    //                 width: 20,
                    //               ),
                    //               Container(
                    //                 // color: Colors.white,
                    //                 child: AutoSizeText(
                    //                   'cupertino Dialog Box'.toUpperCase(),
                    //                   style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 5.w,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    await canLaunch(_url)
        ? await launch(
            _url,
            forceWebView: false,
            forceSafariVC: false,
          )
        : Fluttertoast.showToast(msg: 'Could not launch $_url');
  }

  Future getCustomerId() async {
    ConstantsVar.prefs =
        await SharedPreferences.getInstance().whenComplete(() async {
      // await FirebaseAnalytics.instance.logEvent(name: 'screen_view_',parameters: {'screen_name':'Menu Screen'});
    });


    setState(() {});
  }

  void getUserCreds() async {
    if (email == '') {
      setState(() {
        isEmailVisible = false;
        email = '';
      });
    }
    if (userName == '') {
      setState(() {
        userName =
            'Guestuser' + ConstantsVar.prefs.getString('guestCustomerID')!;
      });
    }
    if (phnNumber == '') {
      setState(() {
        isPhoneNumberVisible = false;
        phnNumber = '';
      });
    }
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
    await secureStorage.deleteAll();
  }

  String returnFlag({required String storeId}) {
    switch (storeId) {
      case "1":
        return "mapsIcons/uae.png";
      case "3":
        return "mapsIcons/kuwait.png";
      case "4":
        return "mapsIcons/bahrain.png";
      default:
        return "mapsIcons/qatar.png";
    }
  }
}
