import 'package:flutter/material.dart';

class UsermanagePage extends StatelessWidget {
  const UsermanagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            color: Color(0xFF389B72),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 1500,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 200,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30))),
                              padding:
                                  const EdgeInsets.only(top: 40, bottom: 40),
                              child: Column(
                                  children: List.generate(20, (index) {
                                return ListTile(
                                  title: Text('item $index'),
                                );
                              })),
                            )),
                        Positioned(
                            top: 120,
                            left: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 90,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
