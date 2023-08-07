import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/gestionEleveAdmin/ecartgenerale.dart';
import 'package:projet_plum/pages/validation/rapporteleve.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class MenuValidation extends ConsumerStatefulWidget {
  const MenuValidation({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MenuValidation> createState() => MenuValidationState();
}

class MenuValidationState extends ConsumerState<MenuValidation> {
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
    // final viewModel = ref.watch(getDataClasseFuture);
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
    context,
  ) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
        child: Container(
          height: 100,
          child: Center(
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Container(
                    height: 100,
                    color: Palette.violetColor,
                    child: const Center(
                      child: Text(
                        "Validation d'écart de comportement",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const EcartGenerale(),
                      ),
                    );
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  child: Container(
                    height: 100,
                    color: Palette.violetColor,
                    child: const Center(
                      child: Text(
                        'Validation de rapport',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const RapportList(),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalView(
    double height,
    double width,
    context,
  ) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
        child: Container(
          height: 100,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Palette.violetColor,
                    child: Center(
                      child: Text("Validation d'écart de comportement"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Palette.violetColor,
                    child: Center(
                      child: Text('Validation de rapport'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
