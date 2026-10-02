import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:uuid/uuid.dart';

class BaseObject{
  static final Map<String, CoreActionWidgetState> registry = {};
  static void registerWidget( CoreActionWidgetState widget) {
    registry[widget.getName() ] = widget;
  }
  static Future<void> action(String name) async {
    if(registry.containsKey(name)){
      CoreActionWidgetState state = registry[name] as CoreActionWidgetState;
      state.setNumber(0);
    }
    await Future.delayed(Duration(milliseconds: 500));
    for (final entry in registry.entries) {
      if (entry.key != name) {
        final state = entry.value;

        state.setNumber(state.getNumber() + 1);

        await Future.delayed(
          const Duration(milliseconds: 200),
        );
      }
    }
    
  }

}




class CoreActionWidget extends StatefulWidget {
  CoreActionWidget(this.number,this.width,{super.key});

  final double number;
  final double width;
  @override
  State<CoreActionWidget> createState() => CoreActionWidgetState(number,width);
}

class CoreActionWidgetState extends State<CoreActionWidget> {
  CoreActionWidgetState(this.number,this.width);
  double number;
  double width;
  final String name = const Uuid().v4();
  @override
  void initState() {
    super.initState();
    BaseObject.registerWidget(this);
  }

  @override
  void dispose() {
    super.dispose();
  }
  String getName(){
    return name;
  }
  double getNumber(){
    return number;
  }

  void setNumber(double newNumber){
    setState(() {
      number = newNumber;
    });
  }
  @override
  Widget build(BuildContext context) {
    return HexagonWidget.pointy(
      width: width,
      color: Colors.limeAccent,
      child: Stack(
        children: [
          // Background visual layer containing text layout and the dot grid matrix
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the number strictly as text visual (no internal button constraints)
                Text(
                  number.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
                const SizedBox(height: 4), // Small spacing before the grid
                // The remaining for-loop grid layout
                for (int i = 0; i < 10; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int j = 0; j < 10; j++)
                        Container(
                          width: 5,
                          height: 5,
                          color: number > i * 10 + j ? Colors.amber : Colors.limeAccent,
                        ),
                    ],
                  ),
              ],
            ),
          ),
          // Foreground transparent interactive layer covering the entire Hexagon shape
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  BaseObject.action(name);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SixsideWidget extends StatelessWidget {
  SixsideWidget(this.number,{super.key});

  final double number ;
  @override
  Widget build(BuildContext context) {
    return CoreActionWidget(
      number,
      100,
    );
  }
}
class QueensideWidget extends StatelessWidget {
  QueensideWidget(this.number,{super.key});

  final double number ;
  @override
  Widget build(BuildContext context) {
    return HexagonWidget.pointy(
          width: 100,
          //cornerRadius: 40.0,
          color: Colors.grey,
          child: Center(
            child: CoreActionWidget(
              number,
              90,
          ),
          )
        );
  }
}



class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
	    crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SixsideWidget(1.0),
              //SizedBox(height: 20),
              QueensideWidget(50.3),              
              SixsideWidget(80.7),],),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SixsideWidget(2.0),
              //SizedBox(height: 20),
              QueensideWidget(30.3),              
              SixsideWidget(120.7),],)
              
            ],
          ),
        ),
      ),
    );
  }
}
