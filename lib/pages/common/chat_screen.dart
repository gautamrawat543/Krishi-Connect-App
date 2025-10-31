import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/pages/common/chat_message.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ApiService service = ApiService();
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

  String _formatDateTime(String rawDate) {
    try {
      DateTime parsed = DateTime.parse(rawDate);
      String formatted = DateFormat("MMM d, hh:mm a").format(parsed);
      return formatted;
    } catch (e) {
      return rawDate; // fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.conversations),
      ),
      body: SizedBox(
        height: height * 0.9,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.green,
              ))
            : conversations.isEmpty
                ? const Center(
                    child: Text('No conversations found'),
                  )
                : ListView.builder(
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
                                        buyerRequestid:
                                            convo['buyerRequestId'].toString(),
                                        listingid:
                                            convo['listingId'].toString(),
                                        name: convo['otherUserName'],
                                        convoId: convo['conversationId'],
                                      )));
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              convo['otherUserProfilePicUrl'],
                              errorBuilder: (context, error, stackTrace) {
                                String name = convo['otherUserName'] ?? '';
                                String initial = name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : '?';
                                return Container(
                                  color: Colors.transparent,
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.primaryGreenDark,
                                    child: Text(
                                      initial,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          title: Text(convo['otherUserName']),
                          subtitle:
                              Text(_formatDateTime(convo['lastMessageTime'])),
                        ),
                      );
                    }),
      ),
    );
  }
}
