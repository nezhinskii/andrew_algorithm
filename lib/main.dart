import 'package:andrew_algorithm/app_painter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> points = [];
  bool drawHull = false;

  void _panDownProcess(Offset tapPosition) {
    for (var point in points){
      if ((point - tapPosition).distance < 8){
        setState(() {
          points.remove(point);
        });
        return;
      }
    }
    setState(() {
      points.add(tapPosition);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: GestureDetector(
            onPanDown: (details) {
              _panDownProcess(details.localPosition);
            },
            child: CustomPaint(
              foregroundPainter: AppPainter(points: points, drawHull: drawHull),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      points.clear();
                    });
                  },
                  icon: const Icon(Icons.clear)
                ),
                const SizedBox(width: 10,),
                IconButton(
                  onPressed: () {
                    setState(() {
                      drawHull = !drawHull;
                    });
                  },
                  icon: drawHull ? const Icon(
                    Icons.adjust
                  ) : const Icon(
                    Icons.circle,
                    size: 8,
                  )
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
