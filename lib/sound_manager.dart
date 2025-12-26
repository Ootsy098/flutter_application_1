import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  void playJumpSound() {
    FlameAudio.play('jump.wav');
  }

  void playSpringSound() {
    FlameAudio.play('spring.mp3');
  }
}
