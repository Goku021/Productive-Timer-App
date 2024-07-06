import 'dart:async';

import 'package:productive_timer/timermodel.dart';

class CountDownTimer{
  int work = 30;
  Timer? time;
  double radius = 1;
  bool isActive = true;

  late Duration  remainingTime;
  late Duration fullTime;
 CountDownTimer(){
   // remainingTime = Duration(minutes: work, seconds: 0);
   // fullTime = remainingTime;
   startWork();
 }
  void startWork(){
    radius = 1;

    remainingTime = Duration(minutes: work, seconds: 0);
    fullTime = remainingTime;
    isActive = true;
  }
  String returnTimer(Duration t){
    String minutes = (t.inMinutes < 10) ? "0${t.inMinutes}": t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds = (numSeconds < 10) ? "0$numSeconds" : numSeconds.toString();
    String formattedTime = "$minutes:$seconds";
    return formattedTime;
  }
  Stream<TimerModel> stream() async*{
    yield* Stream.periodic(Duration(seconds: 1),(int a){
      String time;
      if(this.isActive){
        if(remainingTime.inSeconds > 0){
          remainingTime = remainingTime - Duration(seconds: 1);
        }
        else{
          isActive = false;
        }
        radius = remainingTime.inSeconds / fullTime.inSeconds;

      }
      time = returnTimer(remainingTime);
      return TimerModel(time, radius);
    });
  }

}
