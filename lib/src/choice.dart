enum Score { one, two, three }

class Choice {
  Choice(this.text, this.score);
  String text;
  Score score;
}

final bilirubinChoices = [
  Choice('< 2', Score.one),
  Choice('2 - 3', Score.two),
  Choice('> 3', Score.three),
];

final albuminChoices = [
  Choice('> 3.5', Score.one),
  Choice('2.8 - 3.5', Score.two),
  Choice('< 2.8', Score.three),
];

final inrChoices = [
  Choice('< 1.7', Score.one),
  Choice('1.7 - 2.3', Score.two),
  Choice('> 2.3', Score.three),
];

final ascitesChoices = [
  Choice('Absent', Score.one),
  Choice('Slight', Score.two),
  Choice('Moderate', Score.three),
];

final encephalopathyChoices = [
  Choice('Absent', Score.one),
  Choice('Grade 1-2', Score.two),
  Choice('Grade 3-4', Score.three),
];

final scorePoints = {Score.one: 1, Score.two: 2, Score.three: 3};
