import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:skripsi_rinaldo/providers/history.dart';
import 'package:skripsi_rinaldo/providers/kelas.dart';
import 'package:skripsi_rinaldo/providers/materi.dart';

class PDFViewer extends StatefulWidget {
  final String path;
  final String fileName;
  final String token;
  final String quizId;
  final String classId;
  final String materiId;
  final String userId;
  final String historyId;
  final bool updateHistory;
  final bool timer;

  PDFViewer({
    @required this.path,
    @required this.fileName,
    @required this.token,
    @required this.classId,
    @required this.materiId,
    @required this.userId,
    this.updateHistory = true,
    this.timer = true,
    this.historyId,
    this.quizId,
  });

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  HistoryProvider historyProvider;
  KelasProvider kelasProvider;
  MateriProvider materiProvider;
  int secondsCounter = 0;
  int pages = 0;
  int currPage = 0;
  bool isReady = false;
  bool flag = true;
  String errorMessage = '';
  String pathPDF = '';
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        isReady = true;
        historyProvider = Provider.of<HistoryProvider>(context, listen: false);
        kelasProvider = Provider.of<KelasProvider>(context, listen: false);
        materiProvider = Provider.of<MateriProvider>(context, listen: false);
      });
      timerStream = stopWatchStream();
      timerSubscription = timerStream.listen((int newTick) {
        setState(() {
          hoursStr = ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
          secondsCounter = newTick;
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    timerSubscription.cancel();
    timerStream = null;

    if (widget.updateHistory) {
      historyProvider
          .updateHistory(
        token: widget.token,
        classId: widget.classId,
        classMateriId: widget.materiId,
        classQuizId: widget.quizId,
        durasi: secondsCounter.toString(),
        userId: widget.userId,
        historyId: widget.historyId,
      )
          .then((_) {
        kelasProvider.getList(token: widget.token, userId: int.parse(widget.userId)).then((_) {
          final data = kelasProvider.list;

          if (data.length > 0) {
            materiProvider.getList(
              token: widget.token,
              userId: widget.userId,
              classId: widget.materiId,
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.fileName}")),
      body: !isReady
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 5),
                  Text('Loading...'),
                ],
              ),
            )
          : Stack(
              children: <Widget>[
                PDFView(
                  filePath: pathPDF,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                  pageSnap: true,
                  defaultPage: currPage,
                  fitPolicy: FitPolicy.BOTH,
                  preventLinkNavigation: false,
                  onRender: (_pages) {
                    setState(() {
                      pages = _pages;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    setState(() => errorMessage = error.toString());
                  },
                  onPageError: (page, error) {
                    setState(() => errorMessage = '$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller.complete(pdfViewController);
                  },
                  onLinkHandler: (String uri) {
                    print('goto uri: $uri');
                  },
                  onPageChanged: (int page, int total) {
                    setState(() => currPage = page);
                  },
                ),
                errorMessage.isEmpty
                    ? !isReady
                        ? Center(child: CircularProgressIndicator())
                        : Container()
                    : Center(child: Text(errorMessage)),
                widget.timer
                    ? Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 5, left: 5),
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 1.0),
                              spreadRadius: 0.3,
                              blurRadius: 3.0,
                            )
                          ],
                        ),
                        height: 34,
                        width: 70,
                        child: Text(
                          "$hoursStr:$minutesStr:$secondsStr",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                label: Text('Page ${currPage + 1} of $pages'),
                splashColor: Colors.transparent,
                onPressed: () {},
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      print(e);
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = widget.path;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }
}
