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
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 12.0, left: 6.0, right: 6.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[500], width: 4.0)),
              child: childPughResult()),
          Expanded(child: childPughForm()),
        ],
      ),
    );
  }

  // Widget to show the result
  Widget childPughResult() {
    return Container(
      color: Colors.white,
      height: 96.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<bool>(
              stream: widget.bloc.isComplete,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? StreamBuilder<int>(
                        stream: widget.bloc.outResult,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? _buildResult(snapshot.data)
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

  // Widget for the form to calculate the score
  Widget childPughForm() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: <Widget>[
          Container(
            height: 12.0,
          ),
          _buildHeader('Bilirubin (mg/dL)'),
          _bilirubin(),
          _buildHeader('Albumin (g/dL)'),
          albumin(),
          _buildHeader('INR'),
          inr(),
          _buildHeader('Ascites'),
          ascites(),
          _buildHeader('Encephalopathy'),
          encephalopathy(),
          Container(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  // Bilirubin
  void _handleBilirubin(Score value) {
    widget.bloc.inBilirubin(value);
    print('Bilirubin: $value');
  }

  Widget bilirubin() {
    return StreamBuilder<Score>(
      stream: widget.bloc.outBilirubin,
      builder: (context, snapshot) {
        return Column(
          children: _buildChoicesGroup(
              _handleBilirubin, bilirubinChoices, snapshot.data),
        );
      },
    );
  }

  Widget _bilirubin() {
    // Create the list of choices and assign every of them a score.
    List<Choice> choices = [
      Choice('< 2', Score.one),
      Choice('2 - 3', Score.two),
      Choice('> 3', Score.three),
    ];

    return StreamBuilder<Score>(
      stream: widget.bloc.outBilirubin,
      builder: (context, snapshot) {
        // Create a list of the three choices with List.generate
        // to avoid to manually create every choice
        List<Widget> widgets = List.generate(choices.length, (index) {
          return InkWell(
            onTap: () {
              var value = choices[index].score;
              //when the user taps the choice the value is sent to stream
              widget.bloc.inBilirubin(value);
              print('Bilirubin: $value');
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  // If the stream has the same value of the current choice
                  // it is selected so it shows the checked box otherwise
                  // the empty square
                  snapshot.data == choices[index].score
                      ? Icon(
                          Icons.check_box,
                        )
                      : Icon(
                          Icons.crop_square,
                        ),

                  //To show the text of the current choice
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(choices[index].text,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          );
        });

        // return the Column with the generated widgets
        return Column(children: widgets);
      },
    );
  }

  // Albumin
  void _handleAlbumin(Score value) {
    widget.bloc.inAlbumin(value);
    print('Albumin: $value');
  }

  Widget albumin() {
    return StreamBuilder<Score>(
      stream: widget.bloc.outAlbumin,
      builder: (context, AsyncSnapshot<Score> snapshot) {
        return Column(
          children:
              _buildChoicesGroup(_handleAlbumin, albuminChoices, snapshot.data),
        );
      },
    );
  }

  // INR
  _handleInr(Score value) {
    widget.bloc.inInr(value);
    print('INR: $value');
  }

  Widget inr() {
    return StreamBuilder<Score>(
      stream: widget.bloc.outInr,
      builder: (context, AsyncSnapshot<Score> snapshot) {
        return Column(
          children: _buildChoicesGroup(_handleInr, inrChoices, snapshot.data),
        );
      },
    );
  }

  // Ascites
  _handleAscites(Score value) {
    widget.bloc.inAscites(value);
    print('Ascites: $value');
  }

  Widget ascites() {
    return StreamBuilder<Score>(
      stream: widget.bloc.outAscites,
      builder: (context, AsyncSnapshot<Score> snapshot) {
        return Column(
          children:
              _buildChoicesGroup(_handleAscites, ascitesChoices, snapshot.data),
        );
      },
    );
  }

  // Encephalopathy
  _handleEncephalopathy(Score value) {
    widget.bloc.inEncephalopathy(value);
    print('Encephalopathy $value');
  }

  Widget encephalopathy() {
    return StreamBuilder<Score>(
      stream: widget.bloc.outEncephalopathy,
      builder: (context, AsyncSnapshot<Score> snapshot) {
        return Column(
          children: _buildChoicesGroup(
              _handleEncephalopathy, encephalopathyChoices, snapshot.data),
        );
      },
    );
  }

  _buildResult(int result) {
    var styleH = TextStyle(
      color: Colors.grey[900],
      fontSize: 18.0,
      fontStyle: FontStyle.italic,
    );

    var styleR = TextStyle(
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

  Widget _buildHeader(String text) {
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

  _buildChoicesGroup(Function handler, List<Choice> choices, Score stream) {
    List<Widget> widgets = List.generate(choices.length, (index) {
      return _buildChoice(
          handler, choices[index].text, choices[index].score, stream);
    });
    return widgets;
  }

  _buildChoice(Function handler, String text, Score toAdd, Score stream) {
    return InkWell(
      onTap: () => handler(toAdd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child: Row(
          children: <Widget>[
            toAdd == stream ? Icon(Icons.check_box) : Icon(Icons.crop_square),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
