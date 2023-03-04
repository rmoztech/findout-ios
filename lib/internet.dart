import 'dart:async';

import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/PageView/StartApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';


class internet extends StatefulWidget {
  @override
  State<internet> createState() => _internetState();
}

class _internetState extends State<internet> {
  String _message = '';
  StreamSubscription? subscription;
  SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('pub.dev');

  @override
  void initState() {
    super.initState();
    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected ? 'Connected' : 'Not connected';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  const BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.blueWColor,
              AppColors.blueDColor,

            ],
          ),),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100.h,
                ),
                Container(
                  width: 180.w,
                  height: 200.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/offline.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'network disconnect\n',
                  style: TextStyle(
                    fontFamily: 'Roboto Slab',
                    fontSize: 37,
                    color: Color(0xff57707b),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Text(
                  'Please make sure\nyou are connected to the\ninternet',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 23,
                    color: Color(0xff57707b),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 100.h,
                ),
                InkWell(
                  onTap: () async {
                    bool _isConnected =
                        await SimpleConnectionChecker.isConnectedToInternet();
                    if (_isConnected) {
                      GF().ToastMessage(
                          context, _message, const Icon(Icons.wifi));
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: StartApp(),
                        ),
                      );
                    } else {
                      GF().ToastMessage(
                          context, _message, const Icon(Icons.wifi_off_rounded));
                    }
                  },
                  child: Container(
                    width: 254.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: const Color(0xff57707b),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffe3e3e3),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child:  const Center(
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
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
}

const String _svg_u1bzzk =
    '<svg viewBox="57.8 126.9 74.6 74.6" ><path transform="translate(40.65, 94.76)" d="M 90.16946411132812 48.64572143554688 C 92.24755096435547 46.56765747070312 92.24755096435547 43.24272918701172 90.16946411132812 41.16464614868164 L 82.68838500976562 33.68356323242188 C 80.61032104492188 31.60548400878906 77.28539276123047 31.60548400878906 75.20731353759766 33.68356323242188 L 56.92021179199219 51.97066497802734 C 55.67337417602539 53.21751403808594 53.17967224121094 53.21751403808594 51.93281936645508 51.97066497802734 L 33.64572525024414 33.68356323242188 C 31.56765174865723 31.60548400878906 28.24272918701172 31.60548400878906 26.16464233398438 33.68356323242188 L 18.68356704711914 41.16464614868164 C 16.6054859161377 43.24272918701172 16.6054859161377 46.56765747070312 18.68356704711914 48.64572143554688 L 36.97065734863281 66.93283081054688 C 38.21750259399414 68.17967224121094 38.21750259399414 70.67337799072266 36.97065734863281 71.92021942138672 L 18.68356704711914 90.20732116699219 C 16.6054859161377 92.28540802001953 16.6054859161377 95.61032867431641 18.68356704711914 97.68840026855469 L 26.16464233398438 105.1694946289062 C 28.24272918701172 107.24755859375 31.56765174865723 107.24755859375 33.64572525024414 105.1694946289062 L 51.93281936645508 86.88238525390625 C 53.17966461181641 85.63554382324219 55.67336654663086 85.63554382324219 56.92021179199219 86.88238525390625 L 75.20731353759766 105.1694946289062 C 77.28539276123047 107.24755859375 80.61032104492188 107.24755859375 82.68838500976562 105.1694946289062 L 90.16946411132812 97.68840026855469 C 92.24755096435547 95.61032867431641 92.24755096435547 92.28540802001953 90.16946411132812 90.20732116699219 L 71.88238525390625 71.92021942138672 C 70.63553619384766 70.67337799072266 70.63553619384766 68.17967224121094 71.88238525390625 66.93283081054688 L 90.16946411132812 48.64572143554688 Z" fill="#fbd733" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_mpepy0 =
    '<svg viewBox="4.2 2.1 181.7 57.2" ><path  d="M 184.8497314453125 41.58350372314453 C 161.9908447265625 16.23093795776367 129.5728149414062 2.100000381469727 95.07670593261719 2.100000381469727 C 60.58058929443359 2.100000381469727 28.16255378723145 16.23093605041504 5.303683757781982 41.58350372314453 C 3.641220092773438 43.24596405029297 4.056835174560547 46.1552734375 5.71929931640625 47.40212631225586 L 18.18777465820312 58.20813369750977 C 19.85023880004883 59.87059783935547 22.34393501281738 59.45497894287109 24.00639533996582 57.79251861572266 C 42.29349136352539 38.25857162475586 68.06167602539062 27.03695106506348 95.07670593261719 27.03695106506348 C 122.0917282104492 27.03695106506348 147.8599090576172 38.25857162475586 166.1470184326172 57.79251861572266 C 167.8094787597656 59.45497894287109 170.3031921386719 59.45497894287109 171.9656524658203 58.20813369750977 L 184.4341278076172 47.40212631225586 C 186.0965881347656 45.73966598510742 186.5121917724609 43.24596405029297 184.8497314453125 41.58350372314453 Z" fill="#fbd733" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_n4n1 =
    '<svg viewBox="48.3 60.3 93.3 37.9" ><path transform="translate(33.46, 44.19)" d="M 61.62142944335938 16.09999847412109 C 44.16556549072266 16.09999847412109 27.54093551635742 23.58108329772949 15.90368366241455 36.88079071044922 C 14.2412223815918 38.54325103759766 14.65683746337891 41.45256805419922 16.31930351257324 43.11503219604492 L 29.61901092529297 53.08980941772461 C 31.28147125244141 54.33665466308594 33.77517318725586 54.33665466308594 35.02201080322266 52.67419052124023 C 42.08749008178711 45.19310760498047 51.64665222167969 41.03695297241211 61.62142944335938 41.03695297241211 C 71.59619903564453 41.03695297241211 81.15536499023438 45.19310760498047 87.80522918701172 52.25858688354492 C 89.05207061767578 53.92104721069336 91.5457763671875 53.92104721069336 93.20822143554688 52.67420196533203 L 106.507926940918 42.69942474365234 C 108.5860137939453 41.03696060180664 108.5860137939453 38.54326248168945 106.9235382080078 36.46518707275391 C 95.70191192626953 23.58108329772949 79.07728576660156 16.09999847412109 61.62142944335938 16.09999847412109 Z" fill="#fbd733" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
