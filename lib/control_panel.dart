import 'package:flutter/material.dart';
import 'package:snakegame/direction.dart';


class Controls extends StatelessWidget {
  void Function(Direction direction) onswipe;
  Widget stackwidget;
  Controls({super.key,required this.onswipe,required this.stackwidget});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(

        onVerticalDragEnd:(details){
            if(details.velocity.pixelsPerSecond.dy < 1){onswipe(Direction.up);}
            else {onswipe(Direction.down);}
        },
        onHorizontalDragEnd:(details){
          if(details.velocity.pixelsPerSecond.dx < 1){onswipe(Direction.left);}
          else {onswipe(Direction.right);}
        },
        child: Container(
          child:stackwidget ,
          color: Colors.grey,
        ),
        ),
    );
  }
}
