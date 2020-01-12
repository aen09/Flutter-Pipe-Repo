## This is flutter ffmpeg pipe test from ffmpeg to flutter video_player
The main part of code to check is here in this location of project root.
__lib\Listener\ListenerWidgetVideo.dart__

There in __ListenerWidgetVideo.dart__, at the end of the file there is a method called __ProcessPipe()__
That __ProcessPipe()__ is where i tested the ffmpeg pipe.

## Some Steps to follow
* First put the sample video file provided in __assets/video__ folder, anywhere in device and then after starting the app, choose that video file by pressing __Choose__ button
* Now scroll sideways to view more buttons and you will see __Process Pipe__ button, press that and see the output of ffmpeg processes in IDE.
* I have used android device for testing this. So for iOS this won't work because few things are not added to info.plist
* __Storage Permission__ button won't do anything if already granted permission to read and write external storage when app starts or when choosing video.
* video playback won't be smooth because app is in debug mode.

