// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:krishi_connect_app/services/api/register_api.dart';
// import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

// class ChatMessage extends StatefulWidget {
//   const ChatMessage({super.key, required this.id, required this.name});

//   final int id;
//   final String name;

//   @override
//   State<ChatMessage> createState() => _ChatMessageState();
// }

// class _ChatMessageState extends State<ChatMessage> {
//   Map<String, dynamic>? info;
//   bool isLoading = true;

//   RegisterService service = RegisterService();

//   @override
//   void initState() {
//     super.initState();
//     loadInfo();
//   }

//   Future<void> loadInfo() async {
//     try {
//       final listing = await service.getBuyerRequestById2(
//         businessId: widget.id.toString(),
//         token: SharedPrefHelper.getToken(),
//       );
//       setState(() {
//         info = listing;
//         isLoading = false;
//       });
//       print('✅ Info loaded: $info');
//     } catch (e) {
//       print('❌ Error loading info: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: info != null
//             ? Text('${widget.name} | Id:#${info!['requestId']}')
//             : const Text('Loading...'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : info == null
//               ? const Center(child: Text("No request info found."))
//               : Padding(
//                   padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
//                   child: Container(
//                     width: width,
//                     height: height * 0.2,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 5,
//                           offset: Offset(0, 2),
//                         )
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Title: ${info!['title']}'),
//                         SizedBox(height: 8),
//                         Text(
//                             'Required QTY: ${info!['requiredQuantity']} ${info!['unit']}'),
//                         SizedBox(height: 8),
//                         Text('Price Offered: ₹${info!['maxPrice']}'),
//                         SizedBox(height: 8),
//                         Text('Location: ${info!['location']}'),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:krishi_connect_app/services/api/register_api.dart';
// import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';

// class ChatMessage extends StatefulWidget {
//   final int requestid;
//   final String name;
//   final int convoId;

//   const ChatMessage(
//       {super.key,
//       required this.requestid,
//       required this.name,
//       required this.convoId});

//   @override
//   State<ChatMessage> createState() => _ChatMessageState();
// }

// class _ChatMessageState extends State<ChatMessage> {
//   RegisterService service = RegisterService();
//   final TextEditingController _messageController = TextEditingController();
//   late StompClient stompClient;

//   List<String> messages = [];
//   bool isLoading = true;
//   Map<String, dynamic>? info;

//   @override
//   void initState() {
//     super.initState();
//     fetchChatHistory();
//     connectWebSocket();
//     loadInfo();
//   }

//   Future<void> fetchChatHistory() async {
//     final token = SharedPrefHelper.getToken();

//     final fetchedMessages = await service.fetchChatMessages(
//       conversationId: widget.convoId,
//       token: token,
//     );

//     print("📜 Loaded ${fetchedMessages.length} messages from DB");
//     print(fetchedMessages);

//     setState(() {
//       messages = fetchedMessages;
//     });
//   }

//   void connectWebSocket() async {
//     final token = SharedPrefHelper.getToken();
//     final conversationId = widget.convoId;

//     stompClient = StompClient(
//       config: StompConfig.sockJS(
//         url: 'https://krishi-connect-app.onrender.com/ws',
//         onConnect: (StompFrame frame) {
//           print('✅ Connected to WebSocket');
//           stompClient.subscribe(
//             destination: '/topic/conversations/$conversationId',
//             callback: (StompFrame frame) {
//               if (frame.body != null) {
//                 print('📩 Message received: ${frame.body}');
//                 setState(() {
//                   messages.add(json.decode(frame.body!)['content']);
//                 });
//               }
//             },
//           );
//         },
//         beforeConnect: () async {
//           print('🔌 Connecting to WebSocket...');
//         },
//         onWebSocketError: (dynamic error) => print('❌ WebSocket error: $error'),
//         stompConnectHeaders: {'Authorization': 'Bearer $token'},
//         webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
//       ),
//     );

//     stompClient.activate();
//   }

//   void sendMessage(String content) {
//     if (content.trim().isEmpty) {
//       print('⚠️ Empty message not sent');
//       return;
//     }

//     final payload = {
//       "senderId": int.parse(SharedPrefHelper.getUserId()),
//       "content": content,
//       "timestamp": DateTime.now().toIso8601String(),
//     };

//     stompClient.send(
//       destination: '/app/chat/send/${widget.convoId}',
//       body: jsonEncode(payload),
//     );

//     print('✅ Message sent: $content');
//     _messageController.clear();
//   }

//   Future<void> loadInfo() async {
//     try {
//       final listing = await service.getBuyerRequestById2(
//         businessId: widget.requestid.toString(),
//         token: SharedPrefHelper.getToken(),
//       );
//       setState(() {
//         info = listing;
//         isLoading = false;
//       });
//       print('✅ Info loaded: $info');
//     } catch (e) {
//       print('❌ Error loading info: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     print('🔌 Disconnecting WebSocket');
//     stompClient.deactivate();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: info != null
//             ? Text('${widget.name} | Id:#${info!['requestId']}')
//             : Text("Loading..."),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) => Align(
//                       alignment: messages[index].startsWith("Me:")
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         margin:
//                             EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: messages[index].startsWith("Me:")
//                               ? Colors.blue.shade100
//                               : Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(messages[index]),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: InputDecoration(
//                             hintText: 'Type a message...',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: () {
//                           String content = _messageController.text;
//                           sendMessage("Me: $content");
//                         },
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatMessage extends StatefulWidget {
  final int requestid;
  final String name;
  final int convoId;

  const ChatMessage({
    super.key,
    required this.requestid,
    required this.name,
    required this.convoId,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  RegisterService service = RegisterService();
  final TextEditingController _messageController = TextEditingController();
  late StompClient stompClient;

  List<Map<String, dynamic>> messages = [];

  bool isLoading = true;
  Map<String, dynamic>? info;

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
    connectWebSocket();
    loadInfo();
  }

  Future<void> fetchChatHistory() async {
    final token = SharedPrefHelper.getToken();
    print("Fetching messages for conversation ID: ${widget.convoId}");

    final fetchedMessages = await service.fetchChatMessages(
      conversationId: widget.convoId,
      token: token,
    );

    print("📜 Loaded ${fetchedMessages.length} messages from DB");
    print(fetchedMessages);

    // Encode each message as string to store in list
    setState(() {
      messages = fetchedMessages;
    });
  }

  void connectWebSocket() async {
    final token = SharedPrefHelper.getToken();
    final conversationId = widget.convoId;

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'https://krishi-connect-app.onrender.com/ws',
        onConnect: (StompFrame frame) {
          print('✅ Connected to WebSocket');
          stompClient.subscribe(
            destination: '/topic/conversations/$conversationId',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final decoded = jsonDecode(frame.body!);
                print('📩 Message received: ${decoded}');
                setState(() {
                  messages.add(decoded);
                });
              }
            },
          );
        },
        beforeConnect: () async {
          print('🔌 Connecting to WebSocket...');
        },
        onWebSocketError: (dynamic error) => print('❌ WebSocket error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    stompClient.activate();
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) {
      print('⚠️ Empty message not sent');
      return;
    }

    final senderId = int.parse(SharedPrefHelper.getUserId());
    final payload = {
      "conversationId": widget.convoId,
      "senderId": senderId,
      "content": content.trim(),
    };

    stompClient.send(
      destination: '/app/chat/send/${widget.convoId}',
      body: jsonEncode(payload),
    );

    print('✅ Message sent: $payload');
    _messageController.clear();
  }

  Future<void> loadInfo() async {
    try {
      final listing = await service.getBuyerRequestById2(
        businessId: widget.requestid.toString(),
        token: SharedPrefHelper.getToken(),
      );
      setState(() {
        info = listing;
        isLoading = false;
      });
      print('✅ Info loaded: $info');
    } catch (e) {
      print('❌ Error loading info: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    print('🔌 Disconnecting WebSocket');
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = SharedPrefHelper.getUserId();

    return Scaffold(
      appBar: AppBar(
        title: info != null
            ? Text('${widget.name} | Id:#${info!['requestId'].toString()}')
            : const Text("Loading..."),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // final Map<String, dynamic> msg =
                      //     jsonDecode(messages[index]);
                      final msg = messages[index];
                      final isMe = msg['senderId'].toString() ==
                          currentUserId.toString();

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg['content'].toString()),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => sendMessage(_messageController.text),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
