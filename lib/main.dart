import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JarvisShiro()));

class JarvisShiro extends StatefulWidget {
  @override State<JarvisShiro> createState() => _JarvisShiroState();
}
class _JarvisShiroState extends State<JarvisShiro> {
  final TextEditingController input = TextEditingController();
  List<Map<String,String>> chat = [
    {"user":"Oi","jarvis":"Olá Washington! Sou o JARVIS SHIRO completo! Me fala o que precisa?"}
  ];
  List<String> tarefas = ["Testar JARVIS", "Instalar SHIRO completo"];
  String filtro = "tudo";
    void enviar(){
    String t = input.text.trim();
    if(t.isEmpty) return;
    String resp;
    String l = t.toLowerCase();
    if(l.contains("tarefa") || l.contains("adicionar")){
      String task = t.replaceAll(RegExp(r'adicionar tarefa|tarefa', caseSensitive: false), '').trim();
      if(task.length<3) task=t;
      setState(()=> tarefas.add(task));
      resp="✅ Tarefa adicionada: $task";
    } else if(l.contains("listar") || l.contains("tarefas")){
      resp = tarefas.isEmpty ? "Nenhuma tarefa!" : "📋 Suas tarefas:\n" + tarefas.map((e)=>"• $e").join("\n");
    } else if(l.contains("limpar") && l.contains("tarefa")){
      setState(()=> tarefas.clear());
      resp="🗑️ Todas as tarefas apagadas!";
    } else if(l.contains("hora") || l.contains("horas")){
      resp="⏰ Agora são ${TimeOfDay.now().format(context)}";
    } else if(l.contains("shiro")){
      resp="💙 SHIRO integrado! Todo o projeto SHIRO está dentro do JARVIS agora! Chat, tarefas, horas, memória.";
    } else if(l.contains("quem é voce") || l.contains("quem e voce")){
      resp="Eu sou JARVIS SHIRO MARK 2! Criado pelo Washington Duarte. Tenho chat, lista de tarefas, memória e muito mais. Fala 'adicionar tarefa' pra testar!";
    } else {
      resp="Entendi '$t'. Posso: adicionar tarefas, listar tarefas, falar horas, limpar tarefas. O que quer fazer?";
    }
    setState(()=> chat.add({"user":t,"jarvis":resp}));
    input.clear();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF060A14),
      appBar: AppBar(backgroundColor: Colors.black, title: Row(children:[Icon(Icons.memory, color: Colors.cyanAccent), SizedBox(width:8), Text("JARVIS SHIRO MARK 2", style: TextStyle(color: Colors.cyanAccent, fontSize:14, letterSpacing:2)), Spacer(), Icon(Icons.circle, color: Colors.greenAccent, size:12)])),
      body: Column(children:[
        Container(height:36, color: Color(0xFF0F1629), child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.all(4), children: [
          _chip("📋 ${tarefas.length} tarefas"),
          _chip("💬 ${chat.length} msgs"),
          _chip("💙 SHIRO ON"),
        ])),
        Expanded(child: ListView.builder(padding: EdgeInsets.all(10), itemCount: chat.length, itemBuilder: (c,i){
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
            Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(18)), child: Text(chat[i]["user"]!, style: TextStyle(color: Colors.white)))),
            Align(alignment: Alignment.centerLeft, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1A2332), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.cyanAccent.withOpacity(0.4))), child: Text(chat[i]["jarvis"]!, style: TextStyle(color: Colors.cyanAccent)))),
          ]);
        })),
        if(tarefas.isNotEmpty) Container(height:38, child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal:8), children: tarefas.map((t)=> Container(margin: EdgeInsets.all(4), padding: EdgeInsets.symmetric(horizontal:10), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: Row(children:[Icon(Icons.task_alt, size:14, color: Colors.cyanAccent), SizedBox(width:4), Text(t, style: TextStyle(color: Colors.white70, fontSize:11))]))).toList())),
        Container(padding: EdgeInsets.all(8), color: Colors.black, child: Row(children:[
          Expanded(child: TextField(controller: input, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Fale com JARVIS SHIRO... ex: adicionar tarefa", hintStyle: TextStyle(color: Colors.white30, fontSize:12), filled: true, fillColor: Color(0xFF151B2A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)), onSubmitted: (_)=> enviar())),
          SizedBox(width:6),
          FloatingActionButton(mini: true, backgroundColor: Colors.cyanAccent, onPressed: enviar, child: Icon(Icons.send, color: Colors.black)),
        ])),
      ]),
    );
  }
  Widget _chip(String t)=> Container(margin: EdgeInsets.symmetric(horizontal:4), padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: Text(t, style: TextStyle(color: Colors.white70, fontSize:10)));
}
