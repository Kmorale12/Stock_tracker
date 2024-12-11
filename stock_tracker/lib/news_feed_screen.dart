import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final String apiKey = "e8de8a1c4f4948c4b0b3b1c9d616cd89"; // Replace with your NewsAPI key
  final String baseUrl = "https://newsapi.org/v2/everything";

  Future<List<Map<String, dynamic>>> fetchNews() async {
    final url =
        '$baseUrl?q=finance&from=2024-12-01&sortBy=popularity&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['articles']);
    } else {
      throw Exception('Failed to load news: ${response.body}');
    }
  }

  void openArticle(String url) async {
    final Uri encodedUrl = Uri.parse(url);
    if (await canLaunchUrl(encodedUrl)) {
      await launchUrl(encodedUrl);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override // Corrected here
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial News'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available.'));
          }

          final news = snapshot.data!;
          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final article = news[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(article['title'] ?? 'No Title'),
                  subtitle: Text(
                      article['description'] ?? 'No description available'),
                  trailing: Icon(Icons.launch),
                  onTap: () => openArticle(article['url']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
