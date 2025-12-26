import 'package:flame/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerScore extends Component {
  int score = 0;
  int highScore = 0;

  static const _highScoreKey = 'high_score';

  @override
  Future<void> onLoad() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(_highScoreKey) ?? 0;
  }

  void increaseScore(int amount) {
    score += amount;
    if (score > highScore) {
      highScore = score;
      _saveHighScore();
    }
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, highScore);
  }

  void resetScore() {
    score = 0;
  }
}
