import 'package:flutter/material.dart';
import 'package:entangle/main.dart';
import 'package:flutter/services.dart';
import 'Video_player.dart';
import 'package:entangle/preferences.dart';

WillPopScope save(BuildContext context) {
  Column buildVideo() {
    return Column(
      children: [
        for (int video = 0; video < SavedVideo.length; video++)
          Column(
            children: [
              FlatButton(
                onPressed: () {
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
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        SavedVideo.remove(SavedVideo[video]);
                        SavedLink.remove(SavedLink[video]);
                        setSavedVideo(SavedVideo);
                        setSavedLink(SavedLink);
                      }),
                ),
              ),
              Divider(
                color: Colors.grey,
              )
            ],
          )
      ],
    );
  }

  return WillPopScope(
    onWillPop: () => SystemNavigator.pop(),
    child: Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          if (SavedVideo.length != 0)
            Column(
              children: [
                Image.asset(
                  'images/saved.jpg',
                  scale: 10,
                ),
                buildVideo()
              ],
            )
          else
            nothingtoshow2()
        ],
      ),
    ),
  );
}
