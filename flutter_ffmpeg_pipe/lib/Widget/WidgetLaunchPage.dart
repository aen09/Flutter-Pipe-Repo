import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg_pipe/Enum/VideoType.dart';
import 'package:flutter_ffmpeg_pipe/Listener/ListenerWidgetVideo.dart';
import 'package:flutter_ffmpeg_pipe/Widget/WidgetVideo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WidgetLaunchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListenerWidgetVideo listenerWidgetVideo =
        Provider.of<ListenerWidgetVideo>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Flutter FFMPEG Pipe Test"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(
                child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: double.infinity,
              height: 240.0,
              child: WidgetVideo(),
            )),
            SizedBox(
                child: Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(listenerWidgetVideo.CurrentTime,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.w800)),
                  Text(listenerWidgetVideo.TotalTime,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w800))
                ],
              ),
            )),
            SizedBox(
              child: Center(
                child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: listenerWidgetVideo.SliderMin,
                  max: listenerWidgetVideo.SliderMax,
                  onChanged: (newVal) {
                    listenerWidgetVideo.SeekVideo(newVal);
                  },
                  value: listenerWidgetVideo.SliderVal,
                ),
              ),
            ),
            SizedBox(
              child: Center(
                child: Text('Scroll Horizontally To View More Buttons'),
              ),
            ),
            SizedBox(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: (() => {
                              listenerWidgetVideo.PickLocalFile(),
                              debugPrint("______browse local file")
                            }),
                        icon: Icon(Icons.mouse),
                        label: Text("Choose"),
                      ),
                      RaisedButton.icon(
                        onPressed: (() => {
                              listenerWidgetVideo.PlayPause(),
                              debugPrint("______PlayPause")
                            }),
                        icon: listenerWidgetVideo.Controller.value.isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                        label: listenerWidgetVideo.Controller.value.isPlaying
                            ? Text("Pause")
                            : Text("Play"),
                      ),
                      RaisedButton.icon(
                        onPressed: (() => {
                              listenerWidgetVideo.Stop(),
                              debugPrint("______Stop")
                            }),
                        //icon: videobloc.Controller.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                        icon: Icon(Icons.stop),
                        label: Text("Stop"),
                        //child: Text("Play or Pause"),
                      ),
                      RaisedButton.icon(
                        onPressed: (() => {
                          listenerWidgetVideo.ProcessPipe(),
                          debugPrint("______process pipe")
                        }),
                        //icon: videobloc.Controller.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                        icon: Icon(Icons.extension),
                        label: Text("Process Pipe"),
                        //child: Text("Play or Pause"),
                      ),
                      RaisedButton.icon(
                        onPressed: () async {
                          await listenerWidgetVideo.GetPermission();
                        },
                        icon: Icon(Icons.account_circle),
                        label: Text('Storage Permission'),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
