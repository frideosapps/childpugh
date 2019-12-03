import 'package:flutter/material.dart';
import 'childpugh_bloc.dart';
import 'choice.dart';

class ChildPughPage extends StatefulWidget {
  final bloc = ChildPughBloc();

  @override
  ChildPughPageState createState() {
    return ChildPughPageState();
  }
}

class ChildPughPageState extends State<ChildPughPage> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child-Pugh calculator'),
      ),
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 12.0, left: 6.0, right: 6.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500], width: 4.0)),
              child: ChildPughResult(bloc: widget.bloc)),
          Expanded(child: ChildPughForm(bloc: widget.bloc)),
        ],
      ),
    );
  }
}

class ChildPughResult extends StatelessWidget {
  const ChildPughResult({Key key, this.bloc}) : super(key: key);
  final ChildPughBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 96.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<bool>(
              stream: bloc.isComplete,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? StreamBuilder<int>(
                        stream: bloc.outResult,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Result(result: snapshot.data)
                              : Container();
                        })
                    : Center(
                        child: const Text('Complete the form.',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({Key key, this.result}) : super(key: key);

  final int result;

  @override
  Widget build(BuildContext context) {
    final styleH = TextStyle(
      color: Colors.grey[900],
      fontSize: 18.0,
      fontStyle: FontStyle.italic,
    );

    final styleR = TextStyle(
        color: Colors.indigo[800], fontSize: 20.0, fontWeight: FontWeight.w800);

    String res = '';

    if (result == 5 || result == 6) res = 'A';
    if (result >= 7 && result <= 9) res = 'B';
    if (result >= 10) res = 'C';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Grade:',
              style: styleH,
            ),
            Container(width: 8.0),
            Text('$res', style: styleR),
          ],
        ),
        Container(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total points:',
              style: styleH,
            ),
            Container(width: 8.0),
            Text(
              '$result',
              style: styleR,
            ),
          ],
        ),
      ],
    );
  }
}

class ChildPughForm extends StatelessWidget {
  const ChildPughForm({Key key, this.bloc}) : super(key: key);

  final ChildPughBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 12.0,
          ),
          HeaderSection(text: 'Bilirubin (mg/dL)'),
          ChildPughSection(
              inStream: bloc.inBilirubin,
              outStream: bloc.outBilirubin,
              choices: bilirubinChoices),
          HeaderSection(text: 'Albumin (g/dL)'),
          ChildPughSection(
              inStream: bloc.inAlbumin,
              outStream: bloc.outAlbumin,
              choices: albuminChoices),
          HeaderSection(text: 'INR'),
          ChildPughSection(
              inStream: bloc.inInr,
              outStream: bloc.outInr,
              choices: inrChoices),
          HeaderSection(text: 'Ascites'),
          ChildPughSection(
              inStream: bloc.inAscites,
              outStream: bloc.outAscites,
              choices: ascitesChoices),
          HeaderSection(text: 'Encephalopathy'),
          ChildPughSection(
              inStream: bloc.inEncephalopathy,
              outStream: bloc.outEncephalopathy,
              choices: encephalopathyChoices),
          Container(
            height: 12.0,
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      height: 32.0,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(200),
          border: Border.all(color: Colors.blueGrey[800], width: 1.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class ChildPughSection extends StatelessWidget {
  const ChildPughSection({Key key, this.inStream, this.outStream, this.choices})
      : super(key: key);

  final Stream outStream;
  final Function(Score) inStream;
  final List<Choice> choices;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Score>(
      stream: outStream,
      builder: (context, snapshot) {
        return Column(children: [
          for (var choice in choices)
            InkWell(
              onTap: () {
                // When the user taps the choice the value is sent to stream
                inStream(choice.score);
                print("${choice.text}: ${choice.score}");
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                child: Row(
                  children: [
                    // If the stream has the same value of the current choice
                    // it is selected so it shows the checked box otherwise
                    // the empty square
                    snapshot.data == choice.score
                        ? Icon(
                            Icons.check_box,
                          )
                        : Icon(
                            Icons.crop_square,
                          ),
                    //To show the text of the current choice
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(choice.text,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              ),
            )
        ]);
      },
    );
  }
}
