import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomeSwiper extends StatefulWidget {
  final List<String> images;
final int curIndex;
  const MyHomeSwiper({Key? key, required this.images, required this.curIndex}) : super(key: key);

  @override
  State<MyHomeSwiper> createState() => _MyHomeSwiperState();
}

class _MyHomeSwiperState extends State<MyHomeSwiper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 100.r),
        child: Swiper(
          itemBuilder: (context, index) {
            return Image.network(
              widget.images[index],
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            );
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplay: true,
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
          itemCount: widget.images.length,
          index: widget.curIndex,
        ),
      ),
    );
  }
}
