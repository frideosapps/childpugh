import 'package:rebuilder/rebuilder.dart';

import 'choice.dart';

class ChildPughModel extends DataModel {
  ChildPughModel() {
    bilirubin = RebuilderObject<Score>.init(
        rebuilderState: bilirubinState, onChange: calc);

    albumin = RebuilderObject<Score>.init(
        rebuilderState: albuminState, onChange: calc);

    inr = RebuilderObject<Score>.init(rebuilderState: inrState, onChange: calc);

    encephalopathy = RebuilderObject<Score>.init(
        rebuilderState: encephalopathyState, onChange: calc);

    ascites = RebuilderObject<Score>.init(
        rebuilderState: ascitesState, onChange: calc);

    result = RebuilderObject<int>.init(rebuilderState: resultState);
  }

  // BILIRUBIN (< 2mg/dL  +1, 2 - 3 +2, >3 +3)
  RebuilderObject<Score> bilirubin;

  // ALBUMIN (< 2.8 g/dL +3, 2.8 - 3.5  +2, > 3.5  +1)
  RebuilderObject<Score> albumin;

  // INR (<1.7  +1, 1.7 - 2.2  +2, > 2.2  +3)
  RebuilderObject<Score> inr;

  // ASCITES (Absent +1, slight +2, moderate +3)
  RebuilderObject<Score> ascites;

  // ENCEPHALOPATHY (NO +1, Grade 1-2 +2, Grade 3-4 +3)
  RebuilderObject<Score> encephalopathy;

  // RESULT
  RebuilderObject<int> result;

  // STATES
  final bilirubinState = RebuilderState();
  final albuminState = RebuilderState();
  final inrState = RebuilderState();
  final ascitesState = RebuilderState();
  final encephalopathyState = RebuilderState();
  final resultState = RebuilderState();

  void calc() {
    int total = 0;

    // Assign only the items not null
    final scores = [
      bilirubin.value,
      albumin.value,
      inr.value,
      ascites.value,
      encephalopathy.value,
    ].where((item) => item != null);

    for (var value in scores) {
      total += scorePoints[value];
    }

    // If all the scores are valid, assign the value to the
    // RebuilderObject result, triggering the rebuild of the
    // widgets associated to this state.
    if (scores.length == 5) {
      result.value = total;
    }
  }

  @override
  void dispose() {}
}
