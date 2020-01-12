import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg_pipe/Listener/ListenerWidgetVideo.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class WidgetVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListenerWidgetVideo listenerWidgetVideo = Provider.of<ListenerWidgetVideo>(context);
    return Container(
      width: double.infinity,
      height: 240.0,
      margin: EdgeInsets.all(20.0),
      //padding: EdgeInsets.all(3.0),
      color: Colors.black,
      child: Container(
        child: Center(
          child: listenerWidgetVideo.Controller.value.initialized
              ? AspectRatio(
            aspectRatio: listenerWidgetVideo.Controller.value.aspectRatio,
            //aspectRatio: 16.0/9.0,
            child: Stack(
              children: <Widget>[
                VideoPlayer(listenerWidgetVideo.Controller),
                //Additional Widgets to Overlay on video widget
              ],
            ),
          )
              : Container(),
        ),
      )
    );
  }
}

