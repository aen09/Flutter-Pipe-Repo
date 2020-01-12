import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg_pipe/Enum/VideoType.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

class ListenerWidgetVideo extends ChangeNotifier {
  //==========================================================================================================//
  //------------------------------------------GLOBAL VARIABLES START------------------------------------------//
  //==========================================================================================================//
  String _videoAddressOne =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  String _videoAddressTwo =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
  String _videoAddressThree =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4";

  String _localVideo = "";

  String _currentTime = "0:00:00.00000";
  String _totalTime = "0:00:00.00000";

  double _sliderMin = 0.0;
  double _sliderMax = 0.0;
  double _sliderVal = 0.0;

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  VideoPlayerController _controller;

  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  //------------------------------------------GLOBAL VARIABLES END---------------------------------------------//
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

  //==========================================================================================================//
  //------------------------------------------------GETTER START----------------------------------------------//
  //==========================================================================================================//
  VideoPlayerController get Controller => _controller;
  String get LocalVideo => _localVideo;
  String get CurrentTime => _currentTime;
  String get TotalTime => _totalTime;
  double get SliderMin => _sliderMin;
  double get SliderMax => _sliderMax;
  double get SliderVal => _sliderVal;
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  //------------------------------------------------GETTER END-------------------------------------------------//
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

  //==========================================================================================================//
  //------------------------------------------------SETTER START----------------------------------------------//
  //==========================================================================================================//
  set LocalVideo(String localvideopath) {
    _localVideo = localvideopath;
    notifyListeners();
  }

  set Controller(VideoPlayerController videoPlayerController) {
    _controller = videoPlayerController
      ..initialize().then((_) {
        CurrentTime = _controller.value.position.toString();
        TotalTime = _controller.value.duration.toString();
        SliderMin = 0.0;
        SliderMax = _controller.value.duration.inMilliseconds * 0.001;
        SliderVal = 0.0;
        notifyListeners();
      });
    _controller
      ..addListener(() {
        checkVideo();
        notifyListeners();
      });
    notifyListeners();
  }

  set CurrentTime(String currentTime) {
    _currentTime = currentTime;
    notifyListeners();
  }

  set TotalTime(String totalTime) {
    if (totalTime != "null")
      _totalTime = totalTime;
    else
      _totalTime = "0:00:00.00000";
    notifyListeners();
  }

  set SliderMin(double val) {
    _sliderMin = val;
    notifyListeners();
  }

  set SliderMax(double val) {
    _sliderMax = val;
    notifyListeners();
  }

  set SliderVal(double val) {
    _sliderVal = val;
    notifyListeners();
  }
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  //------------------------------------------------SETTER END-------------------------------------------------//
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

  //==========================================================================================================//
  //----------------------------------------------CONSTRUCTOR START-------------------------------------------//
  //==========================================================================================================//
  ListenerWidgetVideo() {
    GetPermission();
    debugPrint("______ListenerWidgetVideo Initialized______");
    Controller = VideoPlayerController.network(_videoAddressOne);
  }
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  //----------------------------------------------CONSTRUCTOR END----------------------------------------------//
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

  //==========================================================================================================//
  //----------------------------------------------METHOD START------------------------------------------------//
  //==========================================================================================================//
  SeekVideo(double val) {
    Controller.seekTo(Duration(seconds: val.toInt()));
  }

  checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (Controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      debugPrint(
          '________##########______video Started________##########______');
      CurrentTime = "0:00:00.00000";
      TotalTime = Controller.value.duration.toString();
      SliderVal = _controller.value.position.inMilliseconds * 0.001;
    }

    if ((Controller.value.position >
            Duration(seconds: 0, minutes: 0, hours: 0)) &&
        (Controller.value.position < Controller.value.duration)) {
      //debugPrint('________@@@@@______'+Controller.value.position.toString()+'________@@@@@______');
      CurrentTime = Controller.value.position.toString();
      SliderVal = _controller.value.position.inMilliseconds * 0.001;
    }

    if (Controller.value.position == Controller.value.duration) {
      debugPrint('________##########______video Ended________##########______');
      //Controller.seekTo(Duration(microseconds: 0, milliseconds: 0, seconds: 0, minutes: 0, hours: 0));
      //if(Controller.value.isPlaying) Controller.pause();
      CurrentTime = Controller.value.position.toString();
      TotalTime = Controller.value.duration.toString();
      SliderVal = _controller.value.position.inMilliseconds * 0.001;
    }
  }

  PickLocalFile() async {
    await GetPermission();
    File file = await FilePicker.getFile();
    Controller = VideoPlayerController.file(file);
    LocalVideo = file.path;
  }

  GetPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions.values.elementAt(0) == PermissionStatus.granted) {
        Controller = VideoPlayerController.network(_videoAddressTwo)
          ..initialize().then((_) {
            notifyListeners();
          });
      }
    }
  }

  PlayPause() {
    //Controller.value.isPlaying ? Controller.pause() : Controller.play();
    if (Controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      Controller.value.isPlaying ? Controller.pause() : Controller.play();
    } else if ((Controller.value.position >
            Duration(seconds: 0, minutes: 0, hours: 0)) &&
        (Controller.value.position < Controller.value.duration)) {
      Controller.value.isPlaying ? Controller.pause() : Controller.play();
    } else if (Controller.value.position == Controller.value.duration) {
      Restart();
    }
    notifyListeners();
  }

  Stop() {
    Controller.seekTo(Duration(
        microseconds: 0, milliseconds: 0, seconds: 0, minutes: 0, hours: 0));
    if (Controller.value.isPlaying) Controller.pause();
    notifyListeners();
  }

  Restart() {
    Controller.seekTo(Duration(
        microseconds: 0, milliseconds: 0, seconds: 0, minutes: 0, hours: 0));
    Controller.value.isPlaying ? Controller.pause() : Controller.play();
    notifyListeners();
  }

  changeVideo(String address, VideoType videoType) {
    if (videoType == VideoType.network) {
      Controller = VideoPlayerController.network(address);
    } else if (videoType == VideoType.file) {
      Controller = VideoPlayerController.file(File(address));
    }
  }

  ProcessPipe() {
////--------------------------------------------------------------------------------------------------------------------------------//
////    First Test Code, _flutterFFmpeg.registerNewFFmpegPipe() is executed first and then after getting path, rest of code is initiated
////    This Code Gives output as Broken Pipe. Here First Video Controller is initialized and then _flutterFFmpeg.execute()
////--------------------------------------------------------------------------------------------------------------------------------//
//    if (LocalVideo != "") {
//      debugPrint("__________LOCAL VIDEO PATH = " + LocalVideo);
//
//      _flutterFFmpeg.registerNewFFmpegPipe().then((val) {
//        _controller = VideoPlayerController.network("$val")
//          ..initialize().then((_) {
//            notifyListeners();
//            debugPrint("___________VIDEO CONTROLLER INITIALIZED____________");
//          });
//
//        _flutterFFmpeg
//            .execute(
//                "-y -i $LocalVideo -c:v copy -c:a copy -f mp4 -movflags frag_keyframe+empty_moov $val")
//            .then((_) {
//          debugPrint("______PIPE ADDRESS______ = $val");
//        });
//      });
//    }
////---------------------------------------------------------------------------------------------------------------------------------//



////--------------------------------------------------------------------------------------------------------------------------------//
////    Second Test Code, _flutterFFmpeg.registerNewFFmpegPipe() is executed first and then after getting path, rest of code is initiated
////    This Code Gives output as Broken Pipe. Here First _flutterFFmpeg.execute() is done and then Video Controller is initialized
////    After Process Pipe button is clicked, Video playing here is from choosing the video using choose button and not the piped video from ffmpeg
////--------------------------------------------------------------------------------------------------------------------------------//
//    if (LocalVideo != "") {
//      debugPrint("__________LOCAL VIDEO PATH = " + LocalVideo);
//
//      _flutterFFmpeg.registerNewFFmpegPipe().then((val) {
//        _flutterFFmpeg
//            .execute(
//                "-y -i $LocalVideo -c:v copy -c:a copy -f mp4 -movflags frag_keyframe+empty_moov $val")
//            .then((_) {
//          debugPrint("______PIPE ADDRESS______ = $val");
//        });
//
//        _controller = VideoPlayerController.network("$val")
//          ..initialize().then((_) {
//            notifyListeners();
//            debugPrint("___________VIDEO CONTROLLER INITIALIZED____________");
//          });
//      });
//    }
////---------------------------------------------------------------------------------------------------------------------------------//


////--------------------------------------------------------------------------------------------------------------------------------//
////    Third Test Code, _flutterFFmpeg.registerNewFFmpegPipe() is executed first and then after getting path, rest of code is initiated
////    This Code Seems to Work. Here in _flutterFFmpeg.execute() section, in ffmpeg command, instead of giving pipe path $val, i wrote pipe:1
////    pipe:1 seems to work but to catch that stream ? like how to catch stdout or sterr ?
////    After Process Pipe button is clicked, Video playing here is from choosing the video using choose button and not the piped video from ffmpeg
////--------------------------------------------------------------------------------------------------------------------------------//
    if (LocalVideo != "") {
      debugPrint("__________LOCAL VIDEO PATH = " + LocalVideo);

      _flutterFFmpeg.registerNewFFmpegPipe().then((val) {
        _flutterFFmpeg
            .execute(
            "-y -i $LocalVideo -c:v copy -c:a copy -f mp4 -movflags frag_keyframe+empty_moov pipe:1")
            .then((_) {
          debugPrint("______PIPE ADDRESS______ = $val");
        });

        _controller = VideoPlayerController.network("$val")
          ..initialize().then((_) {
            notifyListeners();
            debugPrint("___________VIDEO CONTROLLER INITIALIZED____________");
          });
      });
    }
////---------------------------------------------------------------------------------------------------------------------------------//


  }
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//
  //------------------------------------------------METHOD END-------------------------------------------------//
  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//

}
