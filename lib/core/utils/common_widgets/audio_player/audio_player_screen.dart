import 'dart:async';

import 'package:flutter/material.dart';
import '../../../services/extentions.dart';

import '../voice_recorder_sheet.dart';
import 'audio_player_service.dart';

class AudioPlayerScreen extends StatefulWidget {
  final FullPickerOutput audioItem;
  final Function()? deleteButton;

  const AudioPlayerScreen(this.audioItem, this.deleteButton, {super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  Duration? duration = Duration.zero;
  Duration? currentPosition = Duration.zero;

  Timer? timer;

  bool _isPlaying = false;

  @override
  void initState() {
    _audioPlayerService.setUrl(widget.audioItem.file.first?.path ?? "").then(
          (value) => {
            setState(() {
              duration = value;
            }),
          },
        );

    _audioPlayerService.audioPlayer.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _audioPlayerService.stop();
    timer?.cancel();
    _audioPlayerService.audioPlayer.dispose();
    super.dispose();
  }

  void seek(double milliseconds) {
    _audioPlayerService.audioPlayer
        .seek(Duration(milliseconds: milliseconds.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 70,
          //color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.orange,
                    ),
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      _audioPlayerService.stop();
                      timer?.cancel();
                    } else {
                      _audioPlayerService
                          .play(widget.audioItem.file.first?.path ?? "");

                      timer = Timer(duration!, () {
                        _audioPlayerService.stop();
                        setState(() {
                          _isPlaying = false;
                        });
                      });
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Row(
                    children: [
                      Text(widget.audioItem.name.first ?? ""),
                      const SizedBox(width: 5),
                      _isPlaying
                          ? Text(currentPosition?.fromatTimeDuration() ?? "")
                          : Text(duration?.fromatTimeDuration() ?? ""),
                      const Spacer(),
                      Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      Text(
                        _isPlaying ? 'Pause' : 'Play',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!_isPlaying) ...[
          Positioned(
            right: 0,
            top: 5,
            child: InkWell(
              onTap: widget.deleteButton,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ],
      ],
    );
  }
}
