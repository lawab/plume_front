import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/moduleAffiche/audio.dart';
import 'package:projet_plum/pages/moduleAffiche/document.dart';
import 'package:projet_plum/pages/moduleAffiche/pdf.dart';
import 'package:projet_plum/pages/moduleAffiche/video.dart';
import 'package:projet_plum/pages/sections/sectionAffiche.dart';

import 'package:projet_plum/pages/services/getModule.dart' as p;
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

import '../services/getCourss.dart';

class ModuleAffiche extends ConsumerStatefulWidget {
  final Modules module;
  final String titleCours;
  final String descripCours;
  final List<Sections> listSection;
  final String image;

  const ModuleAffiche(
      {Key? key,
      required this.module,
      required this.titleCours,
      required this.descripCours,
      required this.listSection,
      required this.image})
      : super(key: key);

  @override
  ConsumerState<ModuleAffiche> createState() => ModuleAfficheState();
}

class ModuleAfficheState extends ConsumerState<ModuleAffiche> {
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

  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(getDataCoursFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
    double height,
    double width,
    contextt,
  ) {
    print('**************************************************************');
    print(widget.module.content);
    return AppLayout(
      content: Container(
        child: Row(children: [
          Expanded(
            flex: 7,
            child: Stack(
              children: [
                Card(
                  elevation: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Palette.backgroundColor,
                        border:
                            Border.all(color: Palette.violetColor, width: 10),
                        boxShadow: const [
                          BoxShadow(
                            color: Palette.violetColor,
                            blurRadius: 7,
                            spreadRadius: 5,
                            offset: Offset(4, 4),
                          ),
                        ]),
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      onGenerateRoute: (context) {
                        switch (widget.module.typeModule) {
                          case 'video':
                            {
                              return MaterialPageRoute(
                                  builder: (context) => Video(
                                        lien: widget.module.file!,
                                      ));
                            }

                          case 'pdf':
                            /* return other page route with your wrapper*/
                            {
                              return MaterialPageRoute(
                                  builder: (context) => Pdf(
                                        lien: widget.module.file!,
                                      ));
                            }

                          case 'audio':
                            /* return other page route with your wrapper*/
                            {
                              return MaterialPageRoute(
                                  builder: (context) => Audio(
                                        lien: widget.module.file!,
                                      ));
                            }
                          case 'document':
                            /* return other page route with your wrapper*/
                            {
                              return MaterialPageRoute(
                                  builder: (context) => PageDocument(
                                        doc: widget.module.content!,
                                      ));
                            }
                          /*case 'lien':
                      /* return other page route with your wrapper*/
                      {
                       
                        return MaterialPageRoute(
                            builder: (context) => Lien(
                                  lien: lien!,
                                ));
                      }
                    case 'document':
                      /* return other page route with your wrapper*/
                      {
                        check_pdf = true;
                        return MaterialPageRoute(
                            builder: (context) =>
                                ReadOnlyPage(document: article!));
                      }*/
                          default:
                            {
                              return MaterialPageRoute(
                                  builder: (context) => ALLVIDE());
                            }
                        }
                      },
                    ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AfficheSection(
                                      titleCours: widget.titleCours,
                                      listSection: widget.listSection,
                                      descripCours: widget.descripCours,
                                      image: widget.image,
                                    )));
                      },
                    )),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              //color: Colors.black,
              child: Consumer(builder: ((context, ref, child) {
                final viewModel = ref.watch(p.getDataModulesFuture);
                return ListView.builder(
                    itemCount: viewModel.listModules.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        leading: Image.asset(
                          'module.png',
                          height: 40,
                          width: 40,
                        ),
                        title: Text(viewModel.listModules[index].title!),
                        onTap: () {
                          var ee = Modules(
                            sId: viewModel.listModules[index].sId,
                            title: viewModel.listModules[index].title,
                            description:
                                viewModel.listModules[index].description,
                            file: viewModel.listModules[index].file,
                            typeModule: viewModel.listModules[index].typeModule,
                            section: viewModel.listModules[index].section,
                            content: viewModel.listModules[index].content,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModuleAffiche(
                                titleCours: widget.titleCours,
                                listSection: widget.listSection,
                                descripCours: widget.descripCours,
                                module: ee,
                                image: widget.image,
                              ),
                            ),
                          );
                        },
                      );
                    }));
              })),
            ),
          ),
        ]),
      ),
    );
  }

  Widget verticalView(
    double height,
    double width,
    context,
  ) {
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
