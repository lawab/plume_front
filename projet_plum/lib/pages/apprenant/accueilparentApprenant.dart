import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/apprenant/accueilApprenant.dart';
import 'package:projet_plum/pages/services/getUserOne.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentApprenant extends ConsumerStatefulWidget {
  const ParentApprenant({Key? key}) : super(key: key);

  @override
  ParentApprenantState createState() => ParentApprenantState();
}

class ParentApprenantState extends ConsumerState<ParentApprenant> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserbyOneFuture);
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //color: Colors.black,
          decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  opacity: 100,
                  image: AssetImage(
                    'assets/hiww.png',
                  ),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.logout_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.all(50),
                color: Colors.white,
                child: viewModel.listStudent.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun elève',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.listStudent.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Card(
                              elevation: 10,
                              child: Container(
                                color: Palette.violetColor,
                                height: 100,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      child: Image.asset(
                                        'depo.jpg',
                                        //height: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: Text(
                                        viewModel.listStudent[index].firstName!,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              prefs.setString('IdStudent',
                                  viewModel.listStudent[index].sId!);
                              prefs.setInt('index', 1);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccueilApprenant()));
                            },
                          );
                        }),
              ),
            ],
          )),
    );
  }
}
