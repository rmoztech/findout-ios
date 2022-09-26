import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class PlaySound{
  AudioCache audioCache = AudioCache();


  void play(){
    if (kDebugMode) {
      print("########ffffff");
    }
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }
    audioCache.play('pom.mp3');

  }
}