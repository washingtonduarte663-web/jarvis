import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JarvisShiro()));

class JarvisShiro extends StatefulWidget {
  @override State<JarvisShiro> createState() => _JarvisShiroState();
}

class _JarvisShiroState extends State<JarvisShiro> {
  final FlutterTts tts = FlutterTts();
  final SpeechToText stt = SpeechToText();
  final TextEditingController input = TextEditingController();
  List<Map<String,String>> chat = [];
  List<String> tarefas = [];
  bool escutando = false;
  String status = "JARVIS SHIRO online";

  @override
  void initState(){
    super.initState();
    initTts();
    loadTarefas();
    falar("Jarvis Shiro completo ativado. Olá Washington, o que você precisa?");
  }

  initTts() async {
    await tts.setLanguage("pt-BR");
    await tts.setSpeechRate(0.5);
    await tts.setVolume(1.0);
  }

  falar(String texto) async {
    setState(()=> status = "Falando: $texto");
    await tts.speak(texto);
  }

  escutar() async {
    bool avail = await stt.initialize();
    if(avail){
      setState(()=> escutando = true);
      stt.listen(onResult: (res){
        if(res.finalResult){
          setState(()=> escutando = false);
          processarComando(res.recognizedWords);
        }
      });
    }
  }

  processarComando(String texto){
    input.text = texto;
    enviarMensagem();
  }  enviarMensagem(){
    String txt = input.text.trim();
    if(txt.isEmpty) return;
    setState((){
      chat.add({"user": txt, "jarvis": ""});
    });
    responder(txt);
    input.clear();
  }

  responder(String txt){
    String lower = txt.toLowerCase();
    String resp = "";
    
    if(lower.contains("oi") || lower.contains("ola") || lower.contains("olá")){
      resp = "Olá Washington! Sou o JARVIS com todo o projeto SHIRO integrado. Como posso ajudar?";
    } else if(lower.contains("tarefa") || lower.contains("adicionar")){
      String tarefa = txt.replaceAll(RegExp(r'adicionar tarefa|tarefa', caseSensitive: false), '').trim();
      if(tarefa.isEmpty) tarefa = txt;
      setState(()=> tarefas.add(tarefa));
      saveTarefas();
      resp = "Tarefa adicionada: $tarefa";
    } else if(lower.contains("listar") || lower.contains("tarefas")){
      if(tarefas.isEmpty) resp = "Nenhuma tarefa, Washington.";
      else resp = "Suas tarefas: " + tarefas.join(", ");
    } else if(lower.contains("horas") || lower.contains("hora")){
      resp = "Agora são ${TimeOfDay.now().format(context)}, Washington.";
    } else if(lower.contains("emergencia") || lower.contains("socorro")){
      resp = "Modo emergência ativado! Quer que eu ligue para alguém?";
    } else if(lower.contains("quem é você")){
      resp = "Eu sou o JARVIS, versão SHIRO completo. Fui criado para te ajudar, Washington. Tenho voz, escuta, tarefas e chat.";
    } else if(lower.contains("shiro")){
      resp = "SHIRO integrado com sucesso no JARVIS! Todo o projeto SHIRO está aqui dentro.";
    } else {
      resp = "Entendi: '$txt'. Sou o JARVIS SHIRO, posso adicionar tarefas dizendo 'adicionar tarefa comprar pão', listar tarefas, dizer as horas e conversar com você!";
    }
    
    setState((){
      chat.last["jarvis"] = resp;
    });
    falar(resp);
  }

  saveTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("tarefas", tarefas);
  }
  loadTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(()=> tarefas = prefs.getStringList("tarefas") ?? []);
  }
    @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF060A14),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(children:[
          Icon(Icons.memory, color: Colors.cyanAccent),
          SizedBox(width:10),
          Text("JARVIS SHIRO", style: TextStyle(color: Colors.cyanAccent, letterSpacing: 3)),
          Spacer(),
          Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text(status, style: TextStyle(fontSize:10, color: Colors.greenAccent))),
        ]),
      ),
      body: Column(children:[
        Expanded(child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: chat.length,
          itemBuilder: (c,i){
            return Column(children:[
              Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.all(6), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(16)), child: Text(chat[i]["user"]!, style: TextStyle(color: Colors.white)))),
              Align(alignment: Alignment.centerLeft, child: Container(margin: EdgeInsets.all(6), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1A2332), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.cyanAccent.withOpacity(0.3))), child: Text(chat[i]["jarvis"]!, style: TextStyle(color: Colors.cyanAccent)))),
            ]);
          },
        )),
        if(tarefas.isNotEmpty)
          Container(height: 40, child: ListView(scrollDirection: Axis.horizontal, children: tarefas.map((t)=> Container(margin: EdgeInsets.all(4), padding: EdgeInsets.symmetric(horizontal:12), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: Center(child: Text(t, style: TextStyle(color: Colors.white70, fontSize:12))))).toList())),
        Container(padding: EdgeInsets.all(10), color: Colors.black, child: Row(children:[
          IconButton(icon: Icon(escutando ? Icons.mic : Icons.mic_none, color: escutando ? Colors.red : Colors.cyanAccent), onPressed: escutar),
          Expanded(child: TextField(controller: input, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Fale com o JARVIS SHIRO...", hintStyle: TextStyle(color: Colors.white30), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)), filled: true, fillColor: Color(0xFF151B2A)), onSubmitted: (_)=> enviarMensagem())),
          SizedBox(width:8),
          FloatingActionButton(mini: true, backgroundColor: Colors.cyanAccent, onPressed: enviarMensagem, child: Icon(Icons.send, color: Colors.black)),
        ])),
      ]),
    );
  }
}
