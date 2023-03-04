import 'dart:async';
import 'dart:io';

import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/PageView/PageView1.dart';
import 'package:findout/PageView/StartApp.dart';
import 'package:findout/internet.dart';
import 'package:findout/notification_helper.dart';
import 'package:findout/provider/findout_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:device_preview/device_preview.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
  if (kDebugMode) {
    print(message.data);
  }
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
      ));
}

var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
    sound: 'notification',
    presentSound: true,
    presentAlert: true,
    presentBadge: true);

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  enableLights: true,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('notification'),
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD85g_dAN9sqLoK89L876VSi5ZFxvGT6HY",
          authDomain: "artista-70da8.firebaseapp.com",
          projectId: "artista-70da8",
          storageBucket: "artista-70da8.appspot.com",
          messagingSenderId: "589397315207",
          appId: "1:589397315207:web:41a82eb2972d4539f4b222",
          measurementId: "G-6Z57YGPN5N"),
    );
  } else {
    await Firebase.initializeApp();
  }

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  if (Platform.isIOS) {
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } else {
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/lang/',
  );

  runApp(
    LocalizedApp(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FindoutProvider(),
          ),
        ],
        child: 
         MyApp(), // Wrap your app
        
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Find-Out',
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Splash(),
          localizationsDelegates: translator.delegates,
          locale: translator.locale,
          supportedLocales: translator.locals(),
        );
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double opacity = 0.0;
  String _message = '';
  StreamSubscription? subscription;
  SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('pub.dev');

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      pSetting();
      var androidInitialize =
          const AndroidInitializationSettings('@drawable/ic_launcher');
      var iOSInitialize = const IOSInitializationSettings();
      var initializationsSettings = InitializationSettings(
          android: androidInitialize, iOS: iOSInitialize);
      flutterLocalNotificationsPlugin.initialize(initializationsSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print("onMessage: ${message.data}");
        }

        NotificationHelper.showNotification(
            message, flutterLocalNotificationsPlugin, false);
      });
    } else {
      var initialzationSettingsAndroid =
          const AndroidInitializationSettings('@drawable/ic_launcher');
      const IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );
      var initializationSettings = InitializationSettings(
          android: initialzationSettingsAndroid,
          iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print(message);
        }
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: android.smallIcon,
                ),
              ));
        }
      });
    }

    GF().loading();

    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected ? 'Connected' : 'Not connected';
      });
    });
    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        opacity = 1.0;
      });
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 1900), () async {
        bool _isConnected =
            await SimpleConnectionChecker.isConnectedToInternet();
        if (_isConnected) {
          GF().dismissLoading();

          checkUserSharedPref();
        } else {
          GF().dismissLoading();
          GF().ToastMessage(
              context, _message, const Icon(Icons.wifi_off_rounded));
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: internet(),
            ),
          );
        }
      });
    });
  }

  pSetting() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  Future<void> checkUserSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var findprov = Provider.of<FindoutProvider>(context, listen: false);
    bool userFounded = prefs.containsKey('token');
    if (userFounded) {
      String? token = prefs.getString('token');
      findprov.savetoken(token!).then((v) {});
      findprov.getToken(token);
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          child: StartApp(),
        ),
      );
    } else {
      var findprov = Provider.of<FindoutProvider>(context, listen: false);
      findprov.regester(context).then((v) {});
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: PageView1(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blueWColor,
            AppColors.blueDColor,
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200.h,
              ),
              Hero(
                  tag: 'logo',
                  flightShuttleBuilder: _flightShuttleBuilder,
                  child: Image.asset(
                    "assets/images/logo_w.png",
                    width: 128.w,
                    height: 155.h,
                  )),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'text1'.tr(),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16.sp,
                  color: AppColors.whiteColor,
                ),
              ),
              SizedBox(
                height: 200.h,
              ),
              Image.asset(
                "assets/images/ic_searsh.png",
                width: 36.w,
                height: 36.h,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}
