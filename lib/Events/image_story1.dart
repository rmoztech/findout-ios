// ignore_for_file: use_key_in_widget_constructors, unnecessary_new

import 'package:findout/Model/searchclass.dart';

import 'package:flutter/material.dart';

import 'package:story_view/story_view.dart';

class ImageStory1 extends StatefulWidget {
  SearchClass events_list;
  ImageStory1(this.events_list);

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

  StoryItem a = StoryItem.text(
    title: "I guess you'd love to see more of our food. That's great.",
    backgroundColor: Colors.blue,
  );
  final StoryController storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: widget.events_list.storyItems!,
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
