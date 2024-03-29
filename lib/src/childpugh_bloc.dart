import 'dart:async';

import 'package:rxdart/rxdart.dart';

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
  final _bilirubin = BehaviorSubject<Score>();
  Function(Score) get inBilirubin => _bilirubin.sink.add;
  Stream<Score> get outBilirubin => _bilirubin.stream;

  // ALBUMIN (< 2.8 g/dL +3, 2.8 - 3.5  +2, > 3.5  +1)
  final _albumin = BehaviorSubject<Score>();
  Function(Score) get inAlbumin => _albumin.sink.add;
  Stream<Score> get outAlbumin => _albumin.stream;

  // INR (<1.7  +1, 1.7 - 2.2  +2, > 2.2  +3)
  final _inr = BehaviorSubject<Score>();
  Function(Score) get inInr => _inr.sink.add;
  Stream<Score> get outInr => _inr.stream;

  // ASCITES (Absent +1, slight +2, moderate +3)
  final _ascites = BehaviorSubject<Score>();
  Function(Score) get inAscites => _ascites.sink.add;
  Stream<Score> get outAscites => _ascites.stream;

  // ENCEPHALOPATHY (NO +1, Grade 1-2 +2, Grade 3-4 +3)
  final _encephalopathy = BehaviorSubject<Score>();
  Function(Score) get inEncephalopathy => _encephalopathy.sink.add;
  Stream<Score> get outEncephalopathy => _encephalopathy.stream;

  //RESULT
  final _result = BehaviorSubject<int>();
  Function(int) get inResult => _result.sink.add;
  Stream<int> get outResult => _result.stream;

  Stream<bool> get isComplete => Observable.combineLatest5(
      outBilirubin,
      outAlbumin,
      outAscites,
      outInr,
      outEncephalopathy,
      (a, b, c, d, e) => true);

  void calc() {
    int total = 0;

    // Assign only the items not null
    final scores = [
      _bilirubin.value,
      _albumin.value,
      _inr.value,
      _ascites.value,
      _encephalopathy.value,
    ];

    for (var value in scores) {
      total += scorePoints[value];
    }

    // send the result to stream
    inResult(total);
    print('RESULT: ${_result.value}');
  }

  void dispose() {
    print('---------CHILDPUGH BLOC DISPOSE-----------');
    _bilirubin.close();
    _albumin.close();
    _inr.close();
    _ascites.close();
    _encephalopathy.close();
    _result.close();
    _isCompleteSubscription.cancel();
  }
}
