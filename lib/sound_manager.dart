import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  void playJumpSound() {
    FlameAudio.play('jump.wav');
  }

  void playSpringSound() {
    FlameAudio.play('spring.mp3');
  }

  void playFallSound() {
    FlameAudio.play('fall.mp3');
  }

  void playButtonSound() {
    FlameAudio.play('button.wav');
  }

  void playPropellerSound() {
    FlameAudio.play('propeller.mp3');
  }

  void playJetpackSound() {
    FlameAudio.play('jetpack.mp3');
  }

  void playBreakSound() {
    FlameAudio.play('break.wav');
  }
}
