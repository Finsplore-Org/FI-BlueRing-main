import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/account_provider.dart';
import '../providers/chart_data_provider.dart';
import '../services/chat_service.dart';

class FinChatScreen extends StatefulWidget {
  const FinChatScreen({super.key});

  @override
  State<FinChatScreen> createState() => _FinChatScreenState();
}

class _FinChatScreenState extends State<FinChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 添加初始欢迎消息
    setState(() {
      _messages.add(ChatMessage(
        text: 'Hi! I can help you manage your finances! 😊\n\nTry asking me questions like:\n"What were my food expenses last month?"\n"Show me my bills"\n"What are my goals?"\n"Show my money plan"\n\nWhat would you like to know? 💬',
        isUser: false,
      ));
    });
  }

  bool _isFirstMessage = true;

  // 滚动到底部函数
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmitted(String text) {
    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    // 发送消息后立即滚动
    _scrollToBottom();

    void sendAndHandleMessage(String firstMessage) async {
      final chatService = ChatService();
      // 添加一个加载中的消息
      final int loadingIndex = _messages.length;
      setState(() {
        _messages.add(ChatMessage(text: '', isUser: false, isLoading: true));
      });
      // 添加加载消息后滚动
      _scrollToBottom();
      
      try {
        final response = await chatService.sendMessage(firstMessage);
        // 更新消息内容，移除加载状态
        setState(() {
          _messages[loadingIndex] = ChatMessage(text: response, isUser: false, isLoading: false);
        });
        // 消息更新后滚动到底部
        _scrollToBottom();
      } catch (e) {
        // 更新消息为错误信息，移除加载状态
        setState(() {
          _messages[loadingIndex] = ChatMessage(text: '❌ Network Error: $e', isUser: false, isLoading: false);
        });
        // 错误消息更新后滚动到底部
        _scrollToBottom();
      }
    }

    // 仅在第一次发送消息时收集所有数据
    if (_isFirstMessage) {
      final accountProvider = context.read<AccountProvider>();
      final chartDataProvider = context.read<ChartDataProvider>();
      // 获取所有需要的数据
      final weekData = jsonEncode(chartDataProvider.weekData);
      final categoryData = jsonEncode(chartDataProvider.categoryData);
      final firstMessage =
          "weekData: $weekData\ncategoryData: $categoryData\nuserMessage: $text";

      sendAndHandleMessage(firstMessage);
      _isFirstMessage = false;
    }else{
      sendAndHandleMessage(text);
    }
  }

  // 不再需要单独的_addBotMessage方法，因为现在在_handleSubmitted中直接处理了消息的添加和更新

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask FinChat...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _handleSubmitted(_controller.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool isLoading;

  const ChatMessage({
    super.key, 
    required this.text, 
    required this.isUser, 
    this.isLoading = false,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUser)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF004D40),
                child: Icon(Icons.smart_toy, color: Colors.white),
              ),
            ),
          // 使用Stack来包装消息气泡和对号图标，以便固定对号位置
          Flexible(
            child: Stack(
              clipBehavior: Clip.none, // 允许子部件超出Stack边界
              children: [
                // 消息气泡
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color:
                        widget.isUser
                            ? const Color(0xFF004D40)
                            : const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16.0),
                      topRight: const Radius.circular(16.0),
                      bottomLeft: Radius.circular(widget.isUser ? 16.0 : 4.0),
                      bottomRight: Radius.circular(widget.isUser ? 4.0 : 16.0),
                    ),
                  ),
                  child:
                      widget.isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isUser
                                    ? Colors.white
                                    : const Color(0xFF004D40),
                              ),
                            ),
                          )
                          : Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                ),
                // 对号图标，固定在左下角
                if (widget.isUser)
                  Positioned(
                    left: -16, // 向左偏移，使图标位于气泡外部
                    bottom: 0, // 固定在底部
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Color(0xFF004D40),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isUser)
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
