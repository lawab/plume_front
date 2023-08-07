import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/apprenant/quiz/welcome.dart';
import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:projet_plum/pages/moduleAffiche/document.dart';
import 'package:projet_plum/pages/moduleAffiche/pdf.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class DevoiDetails extends ConsumerStatefulWidget {
  final Homework devoir;
  const DevoiDetails({
    Key? key,
    required this.devoir,
  }) : super(key: key);

  @override
  ConsumerState<DevoiDetails> createState() => DevoiDetailsState();
}

class DevoiDetailsState extends ConsumerState<DevoiDetails> {
  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext buildContext) {
    return mediaQueryData(buildContext).size;
  }

  double width(BuildContext buildContext) {
    return size(buildContext).width;
  }

  double height(BuildContext buildContext) {
    return size(buildContext).height;
  }

  bool annuel = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCoursByAppFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listDevoir);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listDevoir);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, contextT, List<Homework> listDevoir) {
    QuizTotal? listContent;
    if (widget.devoir.typeHomework == 'quiz') {
      print(jsonEncode(widget.devoir));
      var data = jsonDecode(widget.devoir.content!);
      listContent = QuizTotal.fromJson(data);
    }

    return AppLayout(
        content: Container(
      height: height,
      width: width,
      color: Palette.backgroundColor,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(70),
            color: Palette.backgroundColor,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              onGenerateRoute: (contextT) {
                switch (widget.devoir.typeHomework) {
                  case 'quiz':
                    {
                      return MaterialPageRoute(
                          builder: (context) => WelcomeQuiz(
                                module: listContent!,
                              ));
                    }

                  case 'file':
                    /* return other page route with your wrapper*/
                    {
                      return MaterialPageRoute(
                          builder: (context) => Pdf(
                                lien: widget.devoir.file!,
                              ));
                    }

                  case 'document':
                    /* return other page route with your wrapper*/
                    {
                      return MaterialPageRoute(
                          builder: (context) => PageDocument(
                                doc: widget.devoir.content!,
                              ));
                    }

                  default:
                    {
                      return MaterialPageRoute(builder: (context) => ALLVIDE());
                    }
                }
              },
            ),
          ),
          Positioned(
            top: 60,
            left: 30,
            width: 50,
            height: 30,
            child: IconButton(
              icon: Icon(
                Icons.backspace,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget verticalView(
      double height, double width, context, List<Homework> listDevoir) {
    return AppLayout(content: Container());
  }
}

class ALLVIDE extends StatefulWidget {
  const ALLVIDE({Key? key}) : super(key: key);

  @override
  ALLVIDEState createState() => ALLVIDEState();
}

class ALLVIDEState extends State<ALLVIDE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
    );
  }
}
