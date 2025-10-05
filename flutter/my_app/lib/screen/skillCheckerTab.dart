import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/skillInfo.dart';
import 'package:my_app/screen/home.dart';

const notSelected = SnackBar(
  content: Text('技および習熟度を選択してください'),
  backgroundColor: Colors.red,
);

class Skillchecker extends StatefulWidget {
  final String e_mail;

  const Skillchecker({Key? key, required this.e_mail}) : super(key: key);

  @override
  SkillcheckerState createState() => SkillcheckerState();
}

class SkillcheckerState extends State<Skillchecker> {
  int _selectedIndex = 0;
  late String state = '';
  late Future<List<Skillinfo>> skillInfo;
  late List<DataRow> skillList;
  String isSelectedBelt = 'YEL';
  String isSelectedSkill = '';
  String updatekey = '';
  String _selectedLevel = '0';

  late List<String> waza = [''];
  Map<String, String> t_cur_progress_id_map = {'': ''};

  @override
  void initState() {
    state = widget.e_mail;

    skillInfo = postSkill(state, isSelectedBelt);

    FutureBuilder<List<Skillinfo>>(
      future: skillInfo,
      builder: (context, snapshot) {
        waza.clear();
        t_cur_progress_id_map.clear();

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              waza.add("${snapshot.data![index].skill_name}");
              t_cur_progress_id_map['${snapshot.data![index].skill_name}'] =
                  '${snapshot.data![index].t_cur_progress_id}';
            },
          );
        } else {
          return Text("");
        }
      },
    );

    super.initState();

    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      //ホームボタン押下時：ホーム画面に遷移
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen(e_mail: state);
            },
          ),
        );

        break;

      //カリキュラムボタン押下時：カリキュラム画面に遷移
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Skillchecker(e_mail: state);
            },
          ),
        );
        break;
    } //end of switch
  }

  Future<List<Skillinfo>> postSkill(String mail, String belt) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/skillcheck'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"mail_address": mail, "belt": belt}),
    );

    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => Skillinfo.fromJSon(data)).toList();
  }

  Future<List<Skillinfo>> _updateSkill(
    String mail,
    String belt,
    String skill_level,
    String t_cur_progress_id,
  ) async {
    int id = int.parse(t_cur_progress_id);

    final response = await http.post(
      Uri.parse('http://localhost:8080/skillcheck/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "mail_address": mail,
        "skill_name": "",
        "skill_type": "",
        "skill_type_name": "",
        "belt": belt,
        "belt_name": "",
        "skill_level": skill_level,
        "t_cur_progress_id": id,
      }),
    );
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => Skillinfo.fromJSon(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Widgetテストの際はエラー回避のためMaterialAppで包むこと
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //ドロップダウン
                    DropdownButton(
                      hint: Text('習熟度を更新したい技を選択してください'),
                      items: waza.map((String list) {
                        return DropdownMenuItem(value: list, child: Text(list));
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          updatekey = t_cur_progress_id_map['$value']!;
                          isSelectedSkill = value!;
                        });
                      },
                      /*TODO:技の種類を初期表示できるように改善する*/
                      //value: isSelectedSkill,
                    ),
                    //ドロップダウン
                    DropdownButton(
                      hint: Text('習熟度を選択してください'),
                      items: const [
                        DropdownMenuItem(child: Text('0'), value: '0'),
                        DropdownMenuItem(child: Text('1'), value: '1'),
                        DropdownMenuItem(child: Text('2'), value: '2'),
                        DropdownMenuItem(child: Text('3'), value: '3'),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedLevel = value!;
                        });
                      },
                      value: _selectedLevel,
                    ),
                    //end of ドロップダウン
                    OutlinedButton(
                      onPressed: isSelectedBelt == '' || isSelectedSkill == ''
                          ? null
                          : () {
                              skillInfo = _updateSkill(
                                state,
                                isSelectedBelt,
                                _selectedLevel,
                                updatekey,
                              );

                              setState(() {});
                            },
                      child: Text('更新'),
                    ),
                    Container(margin: EdgeInsets.only(bottom: 30)),
                  ],
                ),
                Row(
                  children: [
                    Container(child: Text("ベルト：")),
                    //ドロップダウン
                    DropdownButton(
                      hint: Text('選択してください'),
                      items: const [
                        DropdownMenuItem(child: Text('イエローベルト'), value: 'YEL'),
                        DropdownMenuItem(child: Text('オレンジベルト'), value: 'ORA'),
                        DropdownMenuItem(child: Text('グリーンベルト'), value: 'GRE'),
                        DropdownMenuItem(child: Text('ブルーベルト'), value: 'BLU'),
                        DropdownMenuItem(child: Text('ブラウンベルト'), value: 'BLO'),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          isSelectedBelt = value!;
                        });
                        skillInfo = postSkill(state, isSelectedBelt);
                      },
                      value: isSelectedBelt,
                    ),
                    //end of ドロップダウン
                    Container(
                      padding: EdgeInsets.only(left: 230),

                      child: Text(
                        ''
                        '0：未経験\r\n'
                        '1：習得中\r\n'
                        '2：訓練中で使うことができる\r\n'
                        '3：実際の護身で使うことができる',
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          color: Colors.amberAccent,
                          width: 400,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text('技名'),
                        ),
                        Container(
                          color: Colors.amberAccent,
                          width: 300,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text('　　種別'),
                        ),
                        Container(
                          color: Colors.amberAccent,
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text('前回までの習熟度'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.amberAccent,
                          width: 850,
                          height: 450,
                          alignment: Alignment.centerLeft,
                          child: FutureBuilder<List<Skillinfo>>(
                            future: postSkill(state, isSelectedBelt),
                            builder: (context, snapshot) {
                              waza.clear();
                              t_cur_progress_id_map.clear();

                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    waza.add(
                                      "${snapshot.data![index].skill_name}",
                                    );
                                    t_cur_progress_id_map['${snapshot.data![index].skill_name}'] =
                                        '${snapshot.data![index].t_cur_progress_id}';

                                    return Text(
                                      "${snapshot.data![index].skill_name}"
                                      "${snapshot.data![index].skill_type_name}"
                                      "${snapshot.data![index].skill_level}",
                                    );
                                  },
                                );
                              } else {
                                return Text("");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        //end of ボディ
        //フッタータブボタン
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'カリキュラム'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.yellowAccent,
          onTap: _onItemTapped,
        ),
        //end of フッタータブボタン
      ),
    );
  }
}
