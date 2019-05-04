enum Score { one, two, three }

class Choice {
  Choice(this.text, this.score);
  String text;
  Score score;
}

List<Choice> bilirubinChoices = [
  Choice('< 2', Score.one),
  Choice('2 - 3', Score.two),
  Choice('> 3', Score.three),
];

List<Choice> albuminChoices = [
  Choice('> 3.5', Score.one),
  Choice('2.8 - 3.5', Score.two),
  Choice('< 2.8', Score.three),
];

List<Choice> inrChoices = [
  Choice('< 1.7', Score.one),
  Choice('1.7 - 2.3', Score.two),
  Choice('> 2.3', Score.three),
];

List<Choice> ascitesChoices = [
  Choice('Absent', Score.one),
  Choice('Slight', Score.two),
  Choice('Moderate', Score.three),
];

List<Choice> encephalopathyChoices = [
  Choice('Absent', Score.one),
  Choice('Grade 1-2', Score.two),
  Choice('Grade 3-4', Score.three),
];
