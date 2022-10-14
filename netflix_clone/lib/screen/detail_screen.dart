import 'package:flutter/material.dart';
import '../model/model_movie.dart';
import 'dart:ui';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  DetailScreen({required this.movie, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool like = false;

  @override
  void initState() {
    super.initState();
    like = widget.movie.like;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/' + widget.movie.poster),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0.1),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  child: Image.asset(
                                      'images/' + widget.movie.poster),
                                  // height: 400, // Container 위젯은 width, height를 넣지 않으면, 최대 크기로 확장해준다.
                                ),
                                Container(
                                  padding: EdgeInsets.all(7),
                                  child: Text(
                                    '99% 일치 2017 15+ 시즌 1개',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(7),
                                  child: Text(
                                    widget.movie.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox( // 재생버튼 위에 여백 넣기 방법1
                                  height: 100,
                                ),
                                Container(
                                  // 재생버튼 위에 여백 넣기 방법2
                                  // margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                  padding: EdgeInsets.all(3),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.play_arrow),
                                        Text('재생'),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(widget.movie.toString()),
                                ),
                                // Container(
                                //   padding: EdgeInsets.all(5),
                                //   alignment: Alignment.centerLeft,
                                //   // child: Text(
                                //   //   '출연: 라이언 고슬링\n제작자: 누구누구',
                                //   //   style: TextStyle(
                                //   //       color: Colors.white60, fontSize: 12),
                                //   // ),
                                // ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black26,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    like ? Icon(Icons.check) : Icon(Icons.add),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      '내가 찜한 콘텐츠',
                      style: TextStyle(fontSize: 11, color: Colors.white60),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.thumb_up),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      '평가',
                      style: TextStyle(fontSize: 11, color: Colors.white60),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      '공유',
                      style: TextStyle(fontSize: 11, color: Colors.white60),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
