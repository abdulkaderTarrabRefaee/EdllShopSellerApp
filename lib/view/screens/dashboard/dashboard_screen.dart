
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/network_info.dart';
import 'package:sixvalley_vendor_app/helper/notification_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/view/screens/home/home_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/menu/menu_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/order/order_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/refund/refund_screen.dart';

import '../../../utill/dimensions.dart';


class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(callback: () {
        setState(() {
          _setPage(1);
        });
      }),

      OrderScreen(),
      RefundScreen(),

    ];

    NetworkInfo.checkConnectivity(context);

    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage: ${message.data}");
      NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onMessageOpenedApp: ${message.data}");

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 8,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: ColorResources.HINT_TEXT_COLOR,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle( fontFamily: 'Cairo'),
          unselectedLabelStyle: TextStyle( fontFamily: 'Cairo'),
          items: [
            _barItem(Icons.home, getTranslated('home', context), 0),
            _barItem(Icons.shopping_bag, getTranslated('my_order', context), 1),
            _barItem(Icons.monetization_on_rounded, getTranslated('refund', context), 2),
            _barItem(Icons.menu, getTranslated('menu', context), 3)
          ],
          onTap: (int index) {
            if (index != 3) {
              setState(() {
                _setPage(index);
              });
            } else {
              showModalBottomSheet(

                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => MenuBottomSheet()
              );
            }
          },
        ),
        body: PageView.builder(

          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(


      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: index == _pageIndex ? Theme.of(context).primaryColor : ColorResources.HINT_TEXT_COLOR, size: 25),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
