import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flame/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auto Scroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PDFViewerPage(),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final GlobalKey pdfViewKey = GlobalKey();
  PDFViewController? pdfViewController;
  bool autoScrollEnabled = false;
  double scrollSpeed = 1.0; // Scroll speed in terms of increments
  String? pdfPath;
  PDFScrollGame? pdfScrollGame;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    final ByteData data = await rootBundle.load('assets/pdf/Be_Your_Future_Self_Now.pdf');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/Be_Your_Future_Self_Now.pdf');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    setState(() {
      pdfPath = tempFile.path;
      pdfScrollGame = PDFScrollGame(
        scrollSpeed: scrollSpeed,
        onPageChanged: (page) {
          pdfViewController?.setPage(page);
        },
      );
    });
  }

  void startAutoScroll() {
    setState(() {
      autoScrollEnabled = true;
      pdfScrollGame?.autoScrollEnabled = true;
    });
    pdfScrollGame?.start();
    print("Auto scroll started");
  }

  void stopAutoScroll() {
    setState(() {
      autoScrollEnabled = false;
      pdfScrollGame?.autoScrollEnabled = false;
    });
    pdfScrollGame?.stop();
    print("Auto scroll stopped");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (autoScrollEnabled) {
          stopAutoScroll();
        } else {
          startAutoScroll();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
        ),
        body: Stack(
          children: [
            pdfPath == null
                ? Center(child: CircularProgressIndicator())
                : PDFView(
              key: pdfViewKey,
              filePath: pdfPath!,
              onViewCreated: (controller) {
                pdfViewController = controller;
                if (autoScrollEnabled) {
                  startAutoScroll();
                }
              },
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Slider(
                value: scrollSpeed,
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: scrollSpeed.toString(),
                onChanged: (value) {
                  setState(() {
                    scrollSpeed = value;
                    pdfScrollGame?.scrollSpeed = value;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  if (autoScrollEnabled) {
                    stopAutoScroll();
                  } else {
                    startAutoScroll();
                  }
                },
                child: Text(autoScrollEnabled ? 'Stop Auto Scroll' : 'Start Auto Scroll'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFScrollGame extends FlameGame {
  double scrollSpeed;
  final Function(int page) onPageChanged;
  int currentPage = 0;
  bool autoScrollEnabled = false;
  late Timer _timer;

  PDFScrollGame({
    required this.scrollSpeed,
    required this.onPageChanged,
  });

  void start() {
    _timer = Timer.periodic(Duration(milliseconds: (1000 / scrollSpeed).round()), (timer) {
      if (autoScrollEnabled) {
        currentPage++;
        onPageChanged(currentPage);
      } else {
        timer.cancel();
      }
    });
  }

  void stop() {
    _timer.cancel();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (autoScrollEnabled) {
      // Handle auto scroll in the timer
    }
  }
}
