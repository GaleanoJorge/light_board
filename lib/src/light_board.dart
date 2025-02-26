import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:light_board/models/light_board_model.dart';
import 'package:light_board/utils/letters_pattern.dart';
import 'package:light_board/utils/text_format.dart';

class LightBoard extends StatefulWidget {
  const LightBoard({super.key});

  static const routeName = '/light_board';

  @override
  State<LightBoard> createState() => _LightBoardState();
}

class _LightBoardState extends State<LightBoard> {
  final LightBoardController _con = LightBoardController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
                    onPressed: _con.invertColors,
                    icon: Icon(Icons.invert_colors, size: 30),
                  ),
      ),
      body: Container(
        color: _con.model.backgroundColor,
        child: !_con.initet ? Container(color: Colors.black,) : _con.model.textFormat == TextFormat.NORMAL ? _normalText() : _pixelText(),
      ),
    );
  }

  Widget _normalText() {
    return Center(
      child: SizedBox(
        height: 100, // Altura del letrero
        child: ListView.builder(
          controller: _con.scrollController,
          scrollDirection: Axis.horizontal,
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width + (_con.model.text.length*35),
              child: Text(
                _con.model.text,
                style: TextStyle(color: _con.model.textColor, fontSize: 100),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pixelText() {
    return Center(
      child: SizedBox(
            height: 250,
            child: _textBuilder(_con.model.text)
        ),
    );
  }

  Widget _textBuilder(String text) {
    return ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _con.scrollController,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: text.length*100,
                itemBuilder: (context, index) {
                  var ii = index;
                  while (ii >= text.length) {
                    ii = ii-text.length;
                  }
                  return _getChar(text,ii);
                },
              );
  }

  Widget _getChar(String text, int index) {
    var characters = text.characters;
    if (index >= characters.length) return SizedBox.shrink(); // Manejar el final de la cadena

    String char = characters.elementAt(index);

    if (letterPatterns[char.toUpperCase()] != null) {
      return _buildLetter(char);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(" $char ", style: TextStyle(fontSize: 200, color: _con.model.textColor)),
        ],
      );
    }
  }

  /// Genera una letra con bombillas
  Widget _buildLetter(String letter) {
    List<List<int>> pattern = letterPatterns[letter.toUpperCase()] ?? letterPatterns[' ']!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: pattern.map((row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: row.map((value) {
            return value == 1 ? _shadowCircle() : _nolmalCircle();
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _nolmalCircle() {
    return Padding(
              padding: const EdgeInsets.all(2.0), // Espacio entre bombillas
              child: Container(
                width: 15, // Tamaño de la bombilla
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _con.model.textColor.withOpacity(0.15), // Amarillo encendido, gris apagado
                ),
              ),
            );

  }

  Widget _shadowCircle() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        _con.model.textColor,
                        _con.model.textColor.withOpacity(0.9),
                        _con.model.textColor.withOpacity(0.8),
                        // _con.model.textColor.withOpacity(0.3),
                        _con.model.textColor.withOpacity(0.1),
                      ]),
        ),
      ),
    );

  }

  void refresh() => setState(() {});
}

class LightBoardController {
  BuildContext? context;
  late Function refresh;

  bool initet = false;

  final ScrollController scrollController = ScrollController();
  double _position = 0.0;

  Timer? timer;
  Timer? timerFinish;

  LightBoardModel model = LightBoardModel(text: "");

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    model = ModalRoute.of(context)?.settings.arguments as LightBoardModel;
    model.text = "  "+model.text;
    if (model.textFormat == TextFormat.LIGHT) model.text = model.text+"  ";
    initet = true;
    refresh();

    _startScrolling();
    _startFinishCount();
  }

  void _startScrolling() {
    timer = Timer.periodic(Duration(milliseconds: (500 / model.speed).toInt()), (timer) {
      if (scrollController.hasClients) {
        _position += 4; // Ajusta la velocidad
        scrollController.jumpTo(_position);
      }
      // if (_position > scrollController.position.maxScrollExtent) {
      //   _position = 0.0;
      // }
    });
    
  }

  void _startFinishCount() {
    timerFinish = Timer.periodic(Duration(seconds: 120), (timer) {
      Navigator.of(context!).pop();
      Navigator.pushNamed(context!,LightBoard.routeName, arguments: model);
    });
  }

  void dispose() {
    timer?.cancel();
    timerFinish?.cancel();
  }

  void invertColors() {
    Color tempColor = model.textColor;
    model.textColor = model.backgroundColor;
    model.backgroundColor = tempColor;

    // Llama a la función refresh si no es nula
    refresh.call();
  }

}

