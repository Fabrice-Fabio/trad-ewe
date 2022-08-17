import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color customRed = const Color(0xffDD403A);
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';


  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    setState(() {_lastWords = '';});
    await _speechToText.listen(onResult: _onSpeechResult);
    debugPrint("--- startListening ---");
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  void _stopListening() async {
    await _speechToText.stop();
    debugPrint("--- stopListening ---");
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    debugPrint("--- onSpeechResult --- : $result");
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ewe translate"),
        centerTitle: true,
        backgroundColor: customRed,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Text("Bienvenue sur votre traducteur Ewe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),

              _lastWords.isEmpty ?
              Column(
                children: [
                  const SizedBox(height: 30,),
                  const Text("Cliker sur le micro pour commencer à parler", style: TextStyle(fontSize: 16,),),
                  Image.network(
                    "https://thumbs.dreamstime.com/b/african-family-tribe-members-man-warrior-housewife-tribe-members-african-family-man-warrior-spear-woman-fruit-151765054.jpg",
                    height: 300,
                  ),
                ],
              ) :
              Column(
                children: [
                  Text(_lastWords),
                  /// Rajouter un btn translate qui lancera la request api
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: customRed,
        onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
