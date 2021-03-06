import 'package:flutter/material.dart';

enum Mark { X, O, NONE }

const STROKE_WIDTH = 6.0;
const HALF_STROKE_WIDTH = STROKE_WIDTH / 2.0;
const DOUBLE_STROKE_WIDTH = STROKE_WIDTH * 2.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo, Colors.green])),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            color: Colors.deepPurple,
          ),
        ),
        home: TicTacToe(),
      ),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TicTacToeState();
}

class _TicTacToeState extends State {
  Map<int, Mark> _gameMarks = Map();
  Mark _currentMark = Mark.O;
  List<int> _winningLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TIC TAC TOE"),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            setState(() {
              if (_gameMarks.length >= 9 || _winningLine != null) {
                _gameMarks = Map<int, Mark>();
                _currentMark = Mark.O;
                _winningLine = null;
              } else {
                _addMark(details.localPosition.dx, details.localPosition.dy);
                _winningLine = _getWinningLine();
                if (_winningLine == null && _gameMarks.length >= 9) {
                  tieGame();
                }
              }
            });
          },
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              child: CustomPaint(
                painter: GamePainter(_gameMarks, _winningLine),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addMark(double x, double y) {
    double _dividedSize = GamePainter.getDividedSize();
    bool isAbsent = false;
    _gameMarks
        .putIfAbsent((x ~/ _dividedSize + (y ~/ _dividedSize) * 3).toInt(), () {
      isAbsent = true;
      return _currentMark;
    });
    if (isAbsent) _currentMark = _currentMark == Mark.O ? Mark.X : Mark.O;
  }

  List<int> _getWinningLine() {
    final winningLines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    List<int> winningLineFound;
    winningLines.forEach((winningLine) {
      int countNoughts = 0;
      int countCrosses = 0;

      winningLine.forEach((index) {
        if (_gameMarks[index] == Mark.O) {
          ++countNoughts;
        } else if (_gameMarks[index] == Mark.X) {
          ++countCrosses;
        }
      });

      if (countNoughts >= 3 || countCrosses >= 3) {
        winningLineFound = winningLine;
      }
      if (countNoughts >= 3) {
        player1Wins();
      } else if (countCrosses >= 3) {
        player2Wins();
      }
    });

    return winningLineFound;
  }

  void player1Wins() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.amber,
            title: Text(
              "G A M E  O V E R !",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            content: Text(
              "Player 1 wins!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void player2Wins() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.amber,
            title: Text(
              "G A M E  O V E R !",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            content: Text(
              "Player 2 wins",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void tieGame() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.amber,
            title: Text(
              "G A M E  O V E R !",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            content: Text(
              "It's a Tie Game!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class GamePainter extends CustomPainter {
  static double _dividedSize;
  Map<int, Mark> _gameMarks;
  List<int> _winningLine;

  GamePainter(this._gameMarks, this._winningLine);
  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = STROKE_WIDTH
      ..color = Colors.black;

    final blackThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.blue[900];

    final redThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.red[900];

    final orangeThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.orange[900];

    _dividedSize = size.width / 3.0;

    // 1st horizintal line
    canvas.drawLine(
      Offset(STROKE_WIDTH, _dividedSize - HALF_STROKE_WIDTH),
      Offset(size.width - STROKE_WIDTH, _dividedSize - HALF_STROKE_WIDTH),
      blackPaint,
    );

    // 2nd horizontal line
    canvas.drawLine(
        Offset(STROKE_WIDTH, _dividedSize * 2 - HALF_STROKE_WIDTH),
        Offset(size.width - STROKE_WIDTH, _dividedSize * 2 - HALF_STROKE_WIDTH),
        blackPaint);

    // 1st vertical line
    canvas.drawLine(
        Offset(_dividedSize - HALF_STROKE_WIDTH, STROKE_WIDTH),
        Offset(_dividedSize - HALF_STROKE_WIDTH, size.width - STROKE_WIDTH),
        blackPaint);

    // 2nd vertical line
    canvas.drawLine(
        Offset(_dividedSize * 2 - HALF_STROKE_WIDTH, STROKE_WIDTH),
        Offset(_dividedSize * 2 - HALF_STROKE_WIDTH, size.width - STROKE_WIDTH),
        blackPaint);

    _gameMarks.forEach((index, mark) {
      switch (mark) {
        case Mark.O:
          drawNought(canvas, index, redThickPaint);
          break;
        case Mark.X:
          drawCross(canvas, index, blackThickPaint);
          break;
        default:
          break;
      }
    });
    drawWinningLine(canvas, _winningLine, orangeThickPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  static double getDividedSize() => _dividedSize;

  void drawNought(Canvas canvas, int index, Paint paint) {
    double left = (index % 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;
    double top = (index ~/ 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;
    double noughtSize = _dividedSize - DOUBLE_STROKE_WIDTH * 4;

    canvas.drawOval(Rect.fromLTWH(left, top, noughtSize, noughtSize), paint);
  }

  void drawCross(Canvas canvas, int index, Paint paint) {
    double x1, y1;
    double x2, y2;
    x1 = (index % 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;
    y1 = (index ~/ 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;

    x2 = (index % 3 + 1) * _dividedSize - DOUBLE_STROKE_WIDTH * 2;
    y2 = (index ~/ 3 + 1) * _dividedSize - DOUBLE_STROKE_WIDTH * 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    x1 = (index % 3 + 1) * _dividedSize - DOUBLE_STROKE_WIDTH * 2;
    y1 = (index ~/ 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;

    x2 = (index % 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;
    y2 = (index ~/ 3 + 1) * _dividedSize - DOUBLE_STROKE_WIDTH * 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  void drawWinningLine(Canvas canvas, List<int> winningLine, Paint paint) {
    if (winningLine == null) return;
    double x1 = 0, y1 = 0;
    double x2 = 0, y2 = 0;

    int firstIndex = winningLine.first;
    int lastIndex = winningLine.last;

    if (firstIndex % 3 == lastIndex % 3) {
      x1 = x2 = firstIndex % 3 * _dividedSize + _dividedSize / 2;
      y1 = STROKE_WIDTH;
      y2 = _dividedSize * 3 - STROKE_WIDTH;
    } else if (firstIndex ~/ 3 == lastIndex ~/ 3) {
      x1 = STROKE_WIDTH;
      x2 = _dividedSize * 3 - STROKE_WIDTH;
      y1 = y2 = firstIndex ~/ 3 * _dividedSize + _dividedSize / 2;
    } else {
      if (firstIndex == 0) {
        x1 = y1 = DOUBLE_STROKE_WIDTH;
        x2 = y2 = _dividedSize * 3 - DOUBLE_STROKE_WIDTH;
      } else {
        x1 = _dividedSize * 3 - DOUBLE_STROKE_WIDTH;
        x2 = DOUBLE_STROKE_WIDTH;
        y1 = DOUBLE_STROKE_WIDTH;
        y2 = _dividedSize * 3 - DOUBLE_STROKE_WIDTH;
      }
    }
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }
}
