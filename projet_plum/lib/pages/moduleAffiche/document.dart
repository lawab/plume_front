import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:projet_plum/pages/moduleAffiche/docScalfold.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class PageDocument extends StatefulWidget {
  final String doc;
  const PageDocument({Key? key, required this.doc}) : super(key: key);

  @override
  PageDocumentState createState() => PageDocumentState();
}

class PageDocumentState extends State<PageDocument> {
  final FocusNode _focusNode = FocusNode();

  bool _edit = false;
  @override
  Widget build(BuildContext context) {
    return ReadScaffold(
      documentFilename: widget.doc,
      //'sample_data.json',
      builder: _buildContent,
      showToolbar: _edit == true,
    );
  }

  Widget _buildContent(BuildContext context, QuillController? controller) {
    var quillEditor = QuillEditor(
      showCursor: false,
      controller: controller!,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: true,
      expands: false,
      padding: EdgeInsets.zero,
    );
    if (kIsWeb) {
      quillEditor = QuillEditor(
        showCursor: false,
        controller: controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: true,
        readOnly: true,
        expands: false,
        padding: EdgeInsets.zero,
        //embedBuilder: defaultEmbedBuilderWeb
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: quillEditor,
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _edit = !_edit;
    });
  }
}
