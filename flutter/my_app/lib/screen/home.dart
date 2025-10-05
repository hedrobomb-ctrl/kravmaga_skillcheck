import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/reserveInfo.dart';
import 'package:my_app/models/userInfo.dart';
import 'package:my_app/screen/skillCheckerTab.dart';

class HomeScreen extends StatefulWidget {
  final String e_mail;

  const HomeScreen({Key? key, required this.e_mail}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String state = '';
  late Future<UserInfo> user;
  late Future<List<Reserveinfo>> reserve;

  @override
  void initState() {
    super.initState();

    state = widget.e_mail;

    //メールアドレスを./indexへPOST。それをキーにログインユーザーの情報を取得
    user = postIndex(state);

    //メールアドレスを./index/reserveへPOST。それをキーにログインユーザーの予約情報を取得
    reserve = postReserve(state);
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

        user = postIndex(state);
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
  } //end of _onItemTapped

  //ユーザ基本情報を取得する
  Future<UserInfo> postIndex(String mail) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/index'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"mail_address": mail}),
    );

    UserInfo u = UserInfo.fromJSon(jsonDecode(response.body));
    return u;
  }

  //予約データを取得する
  Future<List<Reserveinfo>> postReserve(String mail) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/index/reserve'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"mail_address": mail}),
    );

    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => Reserveinfo.fromJSon(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //ボディ
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 40,
              alignment: Alignment.topLeft,
              child: Text("■会員情報", style: const TextStyle(fontSize: 24)),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 50,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 20),
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        return Text("会員ID：${snapshot.data!.shainkaiin_bango}");
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 50,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 20),
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        return Text("会員種別：${snapshot.data!.m_role_name}");
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: Text("今月参加できるクラス数"),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 30,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20),
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "${snapshot.data!.available_class}",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.blueAccent,
                          ),
                        );
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),

            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: Text("保有しているベルト"),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (!snapshot.data!.isyellow_belt &&
                            !snapshot.data!.isorange_belt &&
                            !snapshot.data!.isgreen_belt &&
                            !snapshot.data!.isblue_belt &&
                            !snapshot.data!.isblue_belt &&
                            !snapshot.data!.isbrown_belt &&
                            !snapshot.data!.isblack_belt) {
                          return Text(
                            "現在保有しているベルトはありません",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isyellow_belt) {
                          return Text(
                            "イエローベルト",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isorange_belt) {
                          return Text(
                            "オレンジベルト",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isgreen_belt) {
                          return Text(
                            "グリーンベルト",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isblue_belt) {
                          return Text(
                            "ブルーベルト",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isbrown_belt) {
                          return Text(
                            "ブラウンベルト",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              color: Colors.amberAccent,
              width: 250,
              height: 25,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: postIndex(state),
                builder:
                    (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isblack_belt) {
                          return Text(
                            "ブラックベルト",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("");
                        }
                      } else {
                        return Text("");
                      }
                    },
              ),
            ),
            Container(
              width: 300,
              height: 40,
              alignment: Alignment.topLeft,
              child: Text("■予約中のクラス", style: const TextStyle(fontSize: 24)),
            ),
            Container(
              color: Colors.amberAccent,
              width: 300,
              height: 24,
              alignment: Alignment.centerLeft,
              child: FutureBuilder<List<Reserveinfo>>(
                future: postReserve(state),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Text(
                          "\t\t\t\t店舗：${snapshot.data![index].m_store_name}\r\n"
                          "\t\t\t\tクラス名：${snapshot.data![index].m_class_name}\r\n"
                          "${index + 1}\t\t日時：${snapshot.data![index].start_date}\r\n"
                          "\t\t\t\t部屋：${snapshot.data![index].room}\r\n"
                          "\t\t\t\t担当者：${snapshot.data![index].teachar}\r\n",
                        );
                      },
                    );
                  } else {
                    return Text("現在予約中のクラスはありません");
                  }
                },
              ),
            ),
            Container(
              color: Colors.yellowAccent,

              child: Row(children: [Container()]),
            ),
          ],
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
