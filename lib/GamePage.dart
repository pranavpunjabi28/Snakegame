import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snakegame/control_panel.dart';
import 'Piece.dart';
import 'direction.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperBoundX,upperBoundY,lowerBoundX,lowerBoundY;
  late double ScreenWidth,ScreenHeight;
  int step=20;//size of snake's single  block
  late final List<Offset> Positiones=[];
  int length=5;
  Direction direction=Direction.right;
  Timer timer=Timer(Duration(milliseconds: 200),(){});
  Offset? foodPosition;
  late Piece food;
  double speed=1;
  int score=0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restart();
  }

  void restart() {
    speed=1;
    score=0;
    length=5;
    int i=Random().nextInt(4);
    direction=Direction.values[i];
    Positiones.clear();
    changespeed();
  }

  void changespeed() {
    if(timer.isActive){
      timer.cancel();
    }
    timer=Timer.periodic(Duration(milliseconds:(400/speed).toInt()),(timer) {setState((){});});
    //set
  }
  
  int Nearesttens(int no){
    //truncate towards zero
    int result;
    result=(no~/step)*step;
    if(result==0){
      result+=step;
    }
    return result;
  }

  Offset getRandomPosition() {
    Offset Position;
    int x=Random().nextInt(upperBoundX);
    int y=Random().nextInt(upperBoundY);
    Position=Offset(Nearesttens(x).toDouble(),Nearesttens(y).toDouble());
    return Position;
  }

  Color colure(var j){
    if(j%2 ==0){return Colors.red;}
    else{return Colors.green;}
  }
  
  List<Piece> GetPiece()
  {
    final List<Piece> Pieces=[];
    draw();
    drawfood();

    for(int i = 0; i<= length ;i++){
      if(i > (Positiones.length-1)){
        continue;
      }
      Pieces.add(Piece(
          size: step,
          color:i == 0 ? Colors.yellow :colure(i),
          posX: Positiones[i].dx.toInt(),
          posY: Positiones[i].dy.toInt(),
          isanimated: false,));
    }
    return Pieces;
  }

  void draw() async {
    if(Positiones.length == 0) {
        Positiones.add(getRandomPosition());
    }
    while(length > Positiones.length){
      Positiones.add(Positiones[Positiones.length-1]);
    }
    for(int i=Positiones.length-1; i > 0 ;i--){
      Positiones[i]=Positiones[i-1];
      //3<--2
      //2<--1
      //1<--0
    }

    Positiones[0]=await GetNextposition(Positiones[0]);

  }

  bool detectcollision(Offset position){
    if(position.dx > upperBoundX  && direction == Direction.right){return true;}
    else if(position.dx < lowerBoundX  && direction == Direction.left){return true;}
    else if(position.dy < lowerBoundY - step && direction == Direction.up){return true;}
    else if(position.dy > upperBoundY + step && direction == Direction.down){return true;}
    return false;
  }

  void drawfood(){
    if(foodPosition==null){
      foodPosition=getRandomPosition();
    }
    if(foodPosition==Positiones[0]){
      length++;
      speed+=0.25;
      score+=1;
      changespeed();
      foodPosition=getRandomPosition();
    }
    food=Piece(size: step, color: Colors.black, posX: foodPosition!.dx.toInt(), posY: foodPosition!.dy.toInt(), isanimated: true,);
  }

  Future<Offset> GetNextposition(Offset current) async {
    Offset next;

    if(direction == Direction.up){
      next=Offset(current.dx,current.dy - step);
    }else if(direction == Direction.down){
      next=Offset(current.dx,current.dy + step);
    }else if(direction == Direction.right){
      next=Offset((current.dx + step) , current.dy);
    }else {
      next=Offset(current.dx - step,current.dy);
    }

    if(detectcollision(next) == true){
      if(timer.isActive){
        timer.cancel();
      }
      await Future.delayed(
          const Duration(milliseconds: 200),
              (){ getdialog(); }
      );
    }
    return next;
  }

  void getdialog() {
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            elevation: 10,
            shape: RoundedRectangleBorder(),
            icon: Icon(Icons.add_alert),
            title: Text("Game End"),
            content: const SingleChildScrollView(
              child: ListBody(children: [
                Text("OOPS"),
                Text("Better Luck Next Time"),
              ],),),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    restart();},
                  child: Text("Restart")),],
          );
        }
    );
  }

  Widget getscore(){
    return Align(
        heightFactor:1.5 ,
        alignment: Alignment.topCenter,
         child:  Text("Score : $score", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white)),
    );
  }
 

  @override
  Widget build(BuildContext context) {
    ScreenHeight=MediaQuery.of(context).size.height;
    ScreenWidth=MediaQuery.of(context).size.width;
    lowerBoundX=step;
    lowerBoundY=step;
    upperBoundX=Nearesttens(ScreenWidth.toInt()-step);
    upperBoundY=Nearesttens(ScreenHeight.toInt()-step);

    return  SafeArea(
      child: Controls(
        onswipe: (temp) {
          setState(() {
          direction=temp as Direction;
        });},
        stackwidget: Stack(
          children: [
            Stack(
              children: GetPiece(),
              //Always create a new list of children as a Widget is immutable.
              //children:GetPiece()
              //Reusing `List<Widget> _children` here is problematic.,
            ),
           food,
            getscore(),
          ],
        ),
      ),
    );
  }
}
