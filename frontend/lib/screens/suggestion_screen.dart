import 'package:flutter/material.dart';
import '../services/suggestion_service.dart';
import '../services/chat_service.dart';
import '../services/category_service.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final SuggestionService _suggestionService = SuggestionService();
  final ChatService _chatService = ChatService();
  final CategoryService _categoryService = CategoryService();
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = true;
  bool _isGenerating = false;
  String? _generatedSuggestion;
  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      final suggestions = await _suggestionService.getSuggestions();
      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed Loading Suggestion: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Suggestion'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _generatedSuggestion = null;
            _response = null;
            _isGenerating = false;
          });
          final categories = await _categoryService.getTopCategories();
          if (!mounted) return;
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Need Financial Advice?'),
                    content: _isGenerating
                      ? const Center(child: CircularProgressIndicator())
                      : _generatedSuggestion != null
                        ? Text(_generatedSuggestion!)
                        : const Text('Would you like a money-saving suggestion based on your spending patterns?'),
                    actions: [
                      if (!_isGenerating && _generatedSuggestion == null) ...[                        
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              _isGenerating = true;
                            });
                            try {
                              final message = categories.take(10).map((cat) => cat['category']).join(', ');
                              final response = await _chatService.generateSuggestion(message);
                              setState(() {
                                _isGenerating = false;
                                _response = response;
                                _generatedSuggestion = 'Category: ${response['suggestion_text']}\nEstimated Monthly Savings: \$${response['saving_amount']}';
                              });
                            } catch (e) {
                              setState(() {
                                _isGenerating = false;
                                _generatedSuggestion = 'Error generating suggestion: $e';
                              });
                            }
                          },
                          child: const Text('Sure'),
                        ),
                      ] else if (!_isGenerating && _generatedSuggestion != null) ...[                        
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await _suggestionService.createSuggestion(
                                _response!['suggestion_text'],
                                double.parse(_response!['saving_amount'].toString()),
                              );
                              if (!mounted) return;
                              Navigator.of(context).pop();
                              _loadSuggestions(); // 刷新建议列表
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Suggestion saved successfully!')),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to save suggestion: $e')),
                              );
                            }
                          },
                          child: const Text('Subscribe'),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          );
        },
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _suggestions.isEmpty
              ? const Center(child: Text('No suggestions available.'))
              : ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              suggestion['suggestionText'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004D40),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.savings, color: Color(0xFF00796B), size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  'Expected Monthly Savings: ¥${suggestion['expectedSaveAmount']}',
                                   style: const TextStyle(
                                     fontSize: 16,
                                     color: Color(0xFF00796B),
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(height: 4),
                             Row(
                               children: [
                                 const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                                 const SizedBox(width: 4),
                                 Text(
                                   'Created: ${DateTime.parse(suggestion['createdAt']).toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}