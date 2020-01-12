import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg_pipe/Listener/ListenerWidgetVideo.dart';
import 'package:flutter_ffmpeg_pipe/Widget/WidgetLaunchPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MaterialApp(
  title: "FLUTTER FFMPEG PIPE TEST",
  home: HomePage(),
));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    debugPrint('_______built homepage______');
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ListenerWidgetVideo>(create: (_) => ListenerWidgetVideo()),
        ],
        child: WidgetLaunchPage()
    );
  }
}
