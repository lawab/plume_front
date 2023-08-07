import 'package:flutter/material.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdf extends StatefulWidget {
  final String lien;
  const Pdf({Key? key, required this.lien}) : super(key: key);

  @override
  PdfState createState() => PdfState();
}

class PdfState extends State<Pdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  double? zoom = 1.6;
  int? updown = 0;
  static bool show = false;
  double? df(val) {
    return zoom = val + 0.1;
  }

  double? dfmoins(val) {
    return zoom = val - 0.1;
  }

  double? dfup(val) {
    return updown = val - 30;
  }

  double? dfdow(val) {
    return updown = val + 30;
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  /// Displays the error message.
  void showErrorDialog(BuildContext context, String error, String description) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('http://13.39.81.126:7002${widget.lien}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.violetColor,
        //title: const Text('PDF Viewer'),
        toolbarHeight: 40,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.nextPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_drop_down_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              dfdow(updown);
              _pdfViewerController.jumpTo(yOffset: updown! - 10);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_drop_up_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              dfup(updown);
              _pdfViewerController.jumpTo(yOffset: updown! + 10);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.first_page,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.firstPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.last_page,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.lastPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.zoom_in,
              color: Colors.white,
            ),
            onPressed: () {
              df(zoom);
              _pdfViewerController.zoomLevel = zoom!;
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.zoom_out,
              color: Colors.white,
            ),
            onPressed: () {
              dfmoins(zoom);
              _pdfViewerController.zoomLevel = zoom!;
            },
          ),
          IconButton(
              icon: const Icon(
                Icons.fullscreen_exit,
                color: Colors.white,
              ),
              onPressed: () {
                /*if (show == true) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ShowModuleAll()),
                      (Route<dynamic> route) => false);
                  show = false;
                }*/
              }),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //http://13.39.81.126:7002${widget.lien}
        //http://13.39.81.126:7002/datas/1684943079307_restaurant-diagram.pdf
        child: SfPdfViewer.network(
          'http://13.39.81.126:7002${widget.lien}',
          initialScrollOffset: Offset(0, 1),
          initialZoomLevel: 1.6,
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            print(details.error);
            showErrorDialog(context, details.error, details.description);
          },
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            print(details.document.pages.count);
          },
          canShowScrollHead: false,
          canShowScrollStatus: false,
          canShowPaginationDialog: false,
          enableDoubleTapZooming: false,
          controller: _pdfViewerController,
          key: _pdfViewerKey,
        ),
      ),
    );
  }
}
