// ignore_for_file: use_key_in_widget_constructors, unnecessary_new

import 'package:findout/Model/searchclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:story_view/story_view.dart';

class ImageStory1 extends StatefulWidget {
  SearchClass events_list;
  ImageStory1(this. events_list);

  // PropertyClass property;
  // ImageStory1(this. property);

  @override
  State<ImageStory1> createState() => _ImageStory1State();
}

class _ImageStory1State extends State<ImageStory1>
    with TickerProviderStateMixin {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    storyController.dispose();

  }
  StoryItem a =          StoryItem.text(
    title: "I guess you'd love to see more of our food. That's great.",
    backgroundColor: Colors.blue,
  );
  final StoryController storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("More"),
      // ),
      body: StoryView(
        storyItems:widget.events_list.storyItems!,
          // [
        //   StoryItem.text(
        //     title: "I guess you'd love to see more of our food. That's great.",
        //     backgroundColor: Colors.blue,
        //   ),
        //   StoryItem.text(
        //     title: "Nice!\n\nTap to continue.",
        //     backgroundColor: Colors.red,
        //     textStyle: TextStyle(
        //       fontFamily: 'Dancing',
        //       fontSize: 40,
        //     ),
        //   ),
        //   StoryItem.pageImage(
        //     url:
        //     "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
        //     caption: "Still sampling",
        //     controller: storyController,
        //   ),
        //   StoryItem.pageImage(
        //       url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
        //       caption: "Working with gifs",
        //       controller: storyController),
        //   StoryItem.pageImage(
        //     url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        //     caption: "Hello, from the other side",
        //     controller: storyController,
        //   ),
        //   StoryItem.pageImage(
        //     url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        //     caption: "Hello, from the other side2",
        //     controller: storyController,
        //   ),
        //   StoryItem.pageVideo(
        //    "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        //     controller: storyController,
        //   ),
        // ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          Navigator.of(context).pop();
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}