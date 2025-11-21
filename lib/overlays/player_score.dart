import 'package:flame/components.dart';

class PlayerScore extends Component {
  int score = 0;

  void increaseScore(int amount) {
    score += amount;
  }
}
