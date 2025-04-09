import 'package:flutter/material.dart';
import 'package:projectphrase2/widgets/profilecard.dart';
import 'package:projectphrase2/models/user_models.dart';

// void main(){
//   runApp(app)
// }
class UsermanagePage extends StatelessWidget{
  const UsermanagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back_ios),
      ),
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
                      right:0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30)
                          )
                        ),
                        padding: const EdgeInsets.only(top: 100, left: 30, right:30,),
                        child: Column(
                          children: [
                            Profilecard(user: demoUser),
                            SizedBox(height: 20,),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              color: Colors.white,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.favorite_border,
                                        color: Color(0xFF007F55),
                                        ),
                                        Text("  Faorite Item                     ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),),
                                        Icon(Icons.arrow_forward_ios,
                                        color: Color(0xFF007F55),)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                                
                            )
                          ],
                        ),
                      )
                    ),
                    
                    Positioned(
                      top: 120,
                      left: 0,
                      right: 0,
                      child: 
                    CircleAvatar(
                      radius: 90,
                      backgroundColor: Color(0xFFD9D9D9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.photo,
                            color: Colors.white,
                            )
                        ],
                      ),
                    ))

                  ],

                ),
              )
            ],
          ),
        )
      )
    );
  }
}