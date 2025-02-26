import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:light_board/models/light_board_model.dart';
import 'package:light_board/src/light_board.dart';
import 'package:light_board/utils/color_selector.dart';
import 'package:light_board/utils/my_snackbar.dart';
import 'package:light_board/utils/shared_pref.dart';
import 'package:light_board/utils/speed_selector.dart';
import 'package:light_board/utils/text_format_selector.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  static const routeName = '/config_screen';

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final ConfigController _con = ConfigController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuración del Letrero')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _text(),
                    Divider(),
                    _format(),
                    Divider(),
                    _colors(),
                    Divider(),
                    _speed(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _con.invertColors,
                    icon: Icon(Icons.invert_colors, size: 30),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: _con.goToLightBoard,
                    icon: Icon(Icons.play_circle, size: 60),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colors() {
    return Column(
      children: [
        Text("Colores", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _textColor(),
            _backgroundColor(),
          ],
        ),
      ],
    );
  }

  Widget _textColor() {
    return Column(
      children: [
        Text("Texto"),
        ColorSelector(
          initialValue: _con.model.textColor,
          onChanged: (value) {
            _con.model.textColor = value;
            refresh();
          },
        ),
      ],
    );
  }

  Widget _backgroundColor() {
    return Column(
      children: [
        Text("Fondo"),
        ColorSelector(
          initialValue: _con.model.backgroundColor,
          onChanged: (value) {
            _con.model.backgroundColor = value;
            refresh();
          },
        ),
      ],
    );
  }

  Widget _format() {
    return Column(
      children: [
        Text("Formato de Texto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextFormatSelector(
          initialValue: _con.model.textFormat,
          onChanged: (value) {
            _con.model.textFormat = value;
            refresh();
          },
        ),
      ],
    );
  }

  Widget _text() {
    return Column(
      children: [
        Text("Texto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(
          controller: _con.textController,
          decoration: InputDecoration(
            labelText: 'Ingresa el texto',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: _con.recentTexts.isNotEmpty ? _con.recentTexts[0] : null,
          hint: Text('Seleccionar texto reciente'),
          isExpanded: true,
          items: _con.recentTexts.map((text) {
            return DropdownMenuItem<String>(
              value: text,
              child: Text(text),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _con.textController.text = value;
              _con.model.text = value;
              refresh();
            }
          },
        ),
      ],
    );
  }

  Widget _speed() {
    return Column(
      children: [
        Text("Velocidad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        SpeedSelector(
          speed: _con.model.speed.toDouble(),
          onChanged: (value) {
            _con.model.speed = (value).toInt();
            refresh();
          },
        ),
      ],
    );
  }

  void refresh() => setState(() {});
}

class ConfigController {
  BuildContext? context;
  late Function refresh;

  final SharedPref _sharedPref = SharedPref();

  TextEditingController textController = TextEditingController();
  LightBoardModel model = LightBoardModel(text: "");

  List<String> recentTexts = []; // Lista para almacenar los últimos textos

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    bool hasInfo = await _sharedPref.contains('model');
    if (hasInfo) {
      model = lightBoardModelFromJson(await _sharedPref.read("model"));
      textController.text = model.text;
    }

    // Cargar la lista de textos recientes desde SharedPreferences
    recentTexts = await _loadRecentTexts();

    refresh();
  }

  void goToLightBoard() async {
    if (textController.text.isEmpty) {
      MySnackbar.show(context: context!, text: "Debes escribir un texto");
      return;
    }
    model.text = textController.text;
    await _sharedPref.save("model", lightBoardModelToJson(model));

    // Agregar el texto a la lista de recientes y guardarla
    _addRecentText(textController.text);
    await _saveRecentTexts();

    await Navigator.pushNamed(context!, LightBoard.routeName, arguments: model);
    await _sharedPref.save("model", lightBoardModelToJson(model));
    refresh();
  }

  Future<List<String>> _loadRecentTexts() async {
    List<dynamic>? recentTextsJson = await _sharedPref.read('recentTexts');
    if (recentTextsJson == null) return [];
    return recentTextsJson.map((item) => item.toString()).toList();
  }

  Future<void> _saveRecentTexts() async {
    await _sharedPref.save('recentTexts', recentTexts);
  }

  void _addRecentText(String text) {
    if (recentTexts.contains(text)) {
      recentTexts.remove(text);
    }
    recentTexts.insert(0, text);
    if (recentTexts.length > 10) {
      recentTexts.removeLast();
    }
  }

  void removeRecentText(String text) async {
    recentTexts.remove(text);
    await _saveRecentTexts();
    refresh();
  }

  void invertColors() {
    Color tempColor = model.textColor;
    model.textColor = model.backgroundColor;
    model.backgroundColor = tempColor;

    // Llama a la función refresh si no es nula
    refresh.call();
  }
}