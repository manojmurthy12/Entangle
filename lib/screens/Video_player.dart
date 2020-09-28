import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'videotags.dart';
import 'package:share/share.dart';
import 'package:entangle/preferences.dart';

class player extends StatefulWidget {
  @override
  _playerState createState() => _playerState();
}

class _playerState extends State<player> {
  YoutubePlayerController _controller;
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    @override
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    YoutubePlayer play() {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(VideoUrl),
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
      return YoutubePlayer(
        controller: _controller,
        topActions: [
          BackButton(
            color: Colors.white,
          ),
          Expanded(child: SizedBox()),
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                Share.share('$VideoUrl');
              }),
        ],
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
          ),
          RemainingDuration(),
          SizedBox(
            width: 20,
          ),
          PlaybackSpeedButton(),
          FullScreenButton(),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
        _controller.pause();
        if (!fromSave)
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Videotags(),
            ),
          );
        else
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FirstScreen(),
            ),
          );
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            play(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[200]],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      children: [
                        Center(
                          child: ListTile(
                            title: Text(
                              VideoTitle,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: mainfont,
                                  fontWeight: FontWeight.w700),
                            ),
                            autofocus: true,
                            trailing: FlatButton(
                              onPressed: () {
                                _launchURL(VideoUrl);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.link,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    'Open in YouTube',
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.blueGrey),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: maincolor,
                                ),
                                onPressed: () {
                                  Share.share('$VideoUrl');
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!fromSave)
                    SizedBox(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[200],
                            child: ListTile(
                              leading: Text(
                                'Up Next',
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                            ),
                          ),
                          for (int video = 0;
                              video <
                                  SelectedCourseVideo[SubjectNumber]
                                          [TopicNumber][SubtopicNumber - 1]
                                      .length;
                              video++)
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    _controller.pause();
                                    SubtopicNumber = SubtopicNumber;
                                    VideoNumber = video;
                                    VideoUrl =
                                        SelectedCourseVideolinks[SubjectNumber]
                                                [TopicNumber]
                                            [SubtopicNumber - 1][VideoNumber];
                                    VideoTitle =
                                        SelectedCourseVideo[SubjectNumber]
                                                [TopicNumber]
                                            [SubtopicNumber - 1][VideoNumber];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => player(),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.play_circle_filled,
                                      color: maincolor,
                                    ),
                                    title: Text(
                                      SelectedCourseVideo[SubjectNumber]
                                              [TopicNumber][SubtopicNumber - 1]
                                          [video],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: (VideoNumber == video)
                                              ? maincolor
                                              : Colors.black,
                                          fontFamily: (VideoNumber == video)
                                              ? mainfont
                                              : '',
                                          fontWeight: (VideoNumber == video)
                                              ? FontWeight.w500
                                              : FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[200],
                            child: ListTile(
                              leading: Text(
                                'Saved Videos',
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                            ),
                          ),
                          for (int video = 0;
                              video < SavedVideo.length;
                              video++)
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    _controller.pause();
                                    VideoNumber = video;
                                    print(VideoNumber);
                                    VideoUrl = SavedLink[VideoNumber];
                                    VideoTitle = SavedVideo[VideoNumber];
                                    print(VideoUrl);
                                    print(VideoTitle);
                                    fromSave = true;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => player(),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.play_circle_filled,
                                      color: maincolor,
                                    ),
                                    title: Text(
                                      SavedVideo[video],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: (VideoNumber == video)
                                              ? maincolor
                                              : Colors.black,
                                          fontFamily: (VideoNumber == video)
                                              ? mainfont
                                              : '',
                                          fontWeight: (VideoNumber == video)
                                              ? FontWeight.w500
                                              : FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
