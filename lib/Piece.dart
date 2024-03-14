import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  Piece({super.key,required this.size,required this.color,required this.posX,required this.posY,required this.isanimated});
  Color color;
  bool isanimated;
  int posX,posY,size;
  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {

  //created a object of animation
  late AnimationController animationobject;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationobject=AnimationController(
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1.0,
    duration: Duration(milliseconds: 1000),);
    animationobject.addStatusListener((status) {
      if(status==AnimationStatus.completed){animationobject.reset();}
      else if(status == AnimationStatus.dismissed){animationobject.forward();}
    });

    animationobject.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.posY.toDouble(),
        left: widget.posX.toDouble(),
        child: Opacity(
          opacity: widget.isanimated ? animationobject.value : 1,
          child: Container(
            height: widget.size.toDouble(),
            width: widget.size.toDouble(),
            decoration: BoxDecoration(
              color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.white,width: 2)
            ),
          ),
        )
    );
  }
}
