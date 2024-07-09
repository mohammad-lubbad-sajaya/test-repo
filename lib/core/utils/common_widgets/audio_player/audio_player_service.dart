import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;

  Future<Duration?> setUrl(String audioUrl) async {
    final duration = await audioPlayer.setUrl(audioUrl);
    return duration;
  }

  Future play(String audioUrl) async {
    await audioPlayer.setUrl(audioUrl);
    await audioPlayer.play();
  }

  Future stop() async {
    await audioPlayer.stop();
  }

  Future pause() async {
    await audioPlayer.pause();
  }
}
