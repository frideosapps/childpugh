import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'choice.dart';

class ChildPughBloc {
  ChildPughBloc() {
    print('-------CHILDPUGH BLOC INIT--------');

    isComplete.listen((_) {
      print('----CALC CHILD PUGH---');
      calc();
    });
  }

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
    int result = 0;
    List<Score> scores = [];
    scores
      ..add(_bilirubin.value)
      ..add(_albumin.value)
      ..add(_inr.value)
      ..add(_ascites.value)
      ..add(_encephalopathy.value);

    for (var value in scores) {
      switch (value) {
        case Score.one:
          result += 1;
          break;
        case Score.two:
          result += 2;
          break;
        case Score.three:
          result += 3;
          break;
        default:
          break;
      }
    }

    // send the result to stream
    inResult(result);
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
  }
}
