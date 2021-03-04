import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff3a5a),
        elevation: 0,
      ),
      backgroundColor: Color(0xffff3a5a),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              CircleAvatar(
                minRadius: 60,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/school.jpeg"),
                  minRadius: 50,

                ),
              ),

            ],
          ),
          SizedBox(height: 20,),
          Text("Kids R Kids", style: TextStyle(fontSize: 24.0, color: Colors.white),),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: InkWell(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.language),
                        SizedBox(width: 30,),
                        Text("Website",style: TextStyle(fontSize: 18),)
                      ],
                    ),
                  )
                ),
                onTap: (){
                  launch("www.kidsrkids.in");
                },
              ),

            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: InkWell(
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.play_circle_filled_outlined),
                          SizedBox(width: 30,),
                          Text("Youtube",style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    ),

                ),
                onTap: (){
    launch("https://www.youtube.com/channel/UCcqKRph6l4ax6pr57vwJ-Ig?sub_confirmation=1");
                },
              ),

            ),
          ),

          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: InkWell(
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.language),
                          SizedBox(width: 30,),
                          Text("Facebook",style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    )
                ),
                onTap: (){
                  launch("https://www.facebook.com/APlayschoolpanipat/");
                },
              ),

            ),
          ),

          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: InkWell(
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.email),
                          SizedBox(width: 30,),
                          Text("Email",style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    )
                ),
                onTap: () async{
                  var email="Kidsrkidselc@gmail.com";
                  if (await canLaunch("mailto:$email")) {
                  await launch("mailto:$email");
                  } else {
                  throw 'Could not launch';
                  }
                },
              ),

            ),
          ),


          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: InkWell(
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.chat_bubble),
                          SizedBox(width: 30,),
                          Text("Whatsapp",style: TextStyle(fontSize: 18),)
                        ],
                      ),
                    )
                ),
                onTap: (){
                  launch("https://wa.link/hz16ej");
                },
              ),

            ),
          ),
        ],
    ),
    );
  }
}
