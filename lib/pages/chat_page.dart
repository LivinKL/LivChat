import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dochat/pages/group_info.dart';
import 'package:dochat/service/database_service.dart';
import 'package:dochat/widgets/message_tile.dart';
import 'package:dochat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({super.key, required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messagecontroller = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getChat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, GroupInfo(
                groupId: widget.groupId,
                groupName: widget.groupName,
                adminName: admin,
                userName: widget.userName
              ));
            }, 
            icon: const Icon(Icons.info)
            )
        ],
      ),
      body: Column(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: messagecontroller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none
                    ),
                  )),
                  const SizedBox(width: 12,),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chatMessages () {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
        ? Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
            return MessageTile(message: snapshot.data.docs[index]['message'], sender: snapshot.data.docs[index]['sender'], sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
            }),
        )
        : Container(color: Colors.black,);
      }
      );
  }
  sendMessage () async {
    if(messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messagecontroller.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).sendMessage(widget.groupId, chatMessageMap);
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() async {
        messagecontroller.clear();
      });
    }
  }
}