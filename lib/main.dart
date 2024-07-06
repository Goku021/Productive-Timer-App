import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productive_timer/timer.dart';
import 'package:productive_timer/timermodel.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title : 'Productive Timer APP',
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget{


  @override
  TimerState createState()=> TimerState();
}
class TimerState extends State<HomePage>{
  final CountDownTimer timer = CountDownTimer();
  late Stream<TimerModel> timerStream;

  String time = "30:00";
  double percent = 1.0;
  int workTime = 30;
  int shortBreakTime = 5;
  int longBreakTime = 15;

  @override
  void initState(){
    super.initState();
    timerStream = timer.stream();
  }

  void startTimer(int minutes){
    setState(() {

      timerStream = timer.stream();
      timer.work = minutes;
      timer.startWork();
    });
  }

  void stopTimer(){
    setState(() {
      timer.isActive = false;
    });
  }

  void restartTimer(){
    setState(() {
      timerStream = timer.stream();
      timer.startWork();
    });
  }
 void updateTimes(int work, int short, int long){
    setState(() {
      workTime = work;
      shortBreakTime = short;
      longBreakTime = long;
    });
 }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Timer App", style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed:() async{
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context){
                return SettingsPage(
                  worktime: workTime,
                  shortbreaktime: shortBreakTime,
                  longbreaktime: longBreakTime,
                );
              }),
            );
            if(result != null){
              updateTimes(result['work'], result['shortBreak'], result['longBreak']);
            }
          }, icon: const Icon(Icons.settings))
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains){
          final double availableWidth = constrains.maxWidth;
          return  Column(
        children: [
          Row(
            children: [
              Expanded(child: Padding(padding: const EdgeInsets.all(10.0), child:
               ProductiveButton(color: Colors.teal, text: 'Work', onPressed:()=> startTimer(workTime),width: 228.0,)
              ),
              ),
              Expanded(child: Padding(padding: const EdgeInsets.all(10.0), child:
               ProductiveButton(color: Colors.teal, text: 'Short Break', onPressed:()=> startTimer(shortBreakTime),width: 228.0,)
              ),
              ),
              Expanded(child: Padding(padding: const EdgeInsets.all(10.0), child:
               ProductiveButton(color: Colors.teal, text: 'Long Break', onPressed:()=> startTimer(longBreakTime),width: 228.0,)
              ),
              )
            ],
          ),
          Expanded(child: StreamBuilder<TimerModel>(
            stream: timerStream,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.active){
                percent = snapshot.data ?.radius ?? 1;
                time = snapshot.data ?.time ?? "30:00";
              }
              return CircularPercentIndicator(radius: availableWidth / 4, lineWidth: 10.0, percent: percent,
                center: Text(time, style: const TextStyle(fontSize: 45.00),),
                progressColor: Colors.red,
              );
            },
          )
          ),
          Row(
            children: [

              Expanded(child: Padding(padding: const EdgeInsets.all(10.0), child:
              ProductiveButton(color: Colors.teal, text: 'Restart', onPressed: restartTimer,width: 228.0,)
              ),
              ),
              Expanded(child: Padding(padding: const EdgeInsets.all(10.0), child:
              ProductiveButton(color: Colors.teal, text: 'Stop', onPressed: stopTimer,width: 228.0,)
              ),
              ),
            ],
          )
        ],

    );
    },
    ),
    );
  }
}


class ProductiveButton extends StatelessWidget{
final Color color;
final double width;
final VoidCallback onPressed;
final String text;
ProductiveButton({ required this.color, required this.width, required this.onPressed, required this.text});

@override
  Widget build(BuildContext context){
  return MaterialButton(
      color: color,
      minWidth: width,
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white),
      ),
  );
}
 }

class SettingsPage extends StatefulWidget{
  final int worktime;
  final int shortbreaktime;
  final int longbreaktime;
  SettingsPage({required this.worktime, required this.longbreaktime, required this.shortbreaktime});
  @override
  _SettingsPageState createState()=> _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  late TextEditingController workController;
  late TextEditingController shortBreakTimeController;
  late TextEditingController longBreakTimeController;
  @override
  void initState(){
    super.initState();
    workController = TextEditingController(text: widget.worktime.toString());
    shortBreakTimeController = TextEditingController(text: widget.shortbreaktime.toString());
    longBreakTimeController = TextEditingController(text: widget.longbreaktime.toString());
  }
  void dispose(){
    super.dispose();
    workController.dispose();
    shortBreakTimeController.dispose();
    longBreakTimeController.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"),
      ),
      body: Padding(padding: const EdgeInsets.all(8.0),child: Column(
        children: [
          TextField(controller: workController, decoration: const InputDecoration(labelText: "Work Time (minutes)"),keyboardType: TextInputType.number,),
          TextField(controller: shortBreakTimeController,decoration: const InputDecoration(labelText: "Short break Time (minutes)"),keyboardType: TextInputType.number),
          TextField(controller: longBreakTimeController, decoration: const InputDecoration(labelText: "Long break time (minutes)"), keyboardType: TextInputType.number,),
          ElevatedButton(onPressed:(){
            final workTime = int.tryParse(workController.text) ?? widget.worktime;
            final shortBreakTime = int.tryParse(shortBreakTimeController.text) ?? widget.shortbreaktime;
            final longBreakTime  = int.tryParse(longBreakTimeController.text) ?? widget.longbreaktime;
            Navigator.pop(context,{
              "work":workTime,
              "shortBreak":shortBreakTime,
              "longBreak":longBreakTime,
            });
          },
              child: const Text("Save"))
        ],
      ),),
    );
  }

}
