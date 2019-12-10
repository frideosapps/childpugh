import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:frideos/frideos.dart';

import 'choice.dart';

class ChildPughBloc {
  ChildPughBloc() {
    print('-------CHILDPUGH BLOC INIT--------');

    _isCompleteSubscription = isComplete.listen((_) {
      print('----CALC CHILD PUGH---');
      calc();
    });
  }

  StreamSubscription _isCompleteSubscription;

  // BILIRUBIN (< 2mg/dL  +1, 2 - 3 +2, >3 +3)
  final bilirubin = StreamedValue<Score>();

  // ALBUMIN (< 2.8 g/dL +3, 2.8 - 3.5  +2, > 3.5  +1)
  final albumin = StreamedValue<Score>();

  // INR (<1.7  +1, 1.7 - 2.2  +2, > 2.2  +3)
  final inr = StreamedValue<Score>();

  // ASCITES (Absent +1, slight +2, moderate +3)
  final ascites = StreamedValue<Score>();

  // ENCEPHALOPATHY (NO +1, Grade 1-2 +2, Grade 3-4 +3)
  final encephalopathy = StreamedValue<Score>();

  // RESULT
  final result = StreamedValue<int>();

  Stream<bool> get isComplete => Observable.combineLatest5(
      bilirubin.outStream,
      albumin.outStream,
      ascites.outStream,
      inr.outStream,
      encephalopathy.outStream,
      (a, b, c, d, e) => true);

  void calc() {
    int total = 0;

    final scores = [
      bilirubin.value,
      albumin.value,
      inr.value,
      ascites.value,
      encephalopathy.value,
    ];

    for (var value in scores) {
      total += scorePoints[value];
    }

    // send the result to stream
    result.value = total;
    print('RESULT: $total');
  }

  void dispose() {
    print('---------CHILDPUGH BLOC DISPOSE-----------');
    bilirubin.dispose();
    albumin.dispose();
    inr.dispose();
    ascites.dispose();
    encephalopathy.dispose();
    result.dispose();
    _isCompleteSubscription.cancel();
  }
}
