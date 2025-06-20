import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krishi_connect_app/pages/chat_message.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  RegisterService service = RegisterService();
  List<dynamic> conversations = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    setState(() {
      isLoading = true;
    });
    try {
      final listings = await service.fetchUserConversations(
        userId: int.parse(SharedPrefHelper.getUserId()),
        token: SharedPrefHelper.getToken(),
      );
      setState(() {
        // Ensure the UI updates after data fetch
        conversations = listings;
        isLoading = false;
        print(conversations);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Conversations')),
      body: SizedBox(
        height: height * 0.9,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final convo = conversations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatMessage(
                                requestid: convo['buyerRequestId'],
                                name: convo['otherUserName'],
                                convoId: convo['conversationId'],
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/app_icon.png',
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        // child: Image.network(
                        //   convo['otherUserProfilePicUrl'],
                        //   errorBuilder: (context, error, stackTrace) =>
                        //       Image.asset(
                        //     'assets/app_icon.png',
                        //     height: 50,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(convo['otherUserName']),
                          Text(convo['lastMessageTime'])
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
