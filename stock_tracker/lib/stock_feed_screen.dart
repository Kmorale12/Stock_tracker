import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StockFeedScreen extends StatefulWidget {
  @override
  _StockFeedScreenState createState() => _StockFeedScreenState();
}

class _StockFeedScreenState extends State<StockFeedScreen> {
  final String apiKey = "ctacij9r01qrt5hhctv0ctacij9r01qrt5hhctvg"; // Replace with your API key
  final List<String> symbols = ['AAPL', 'GOOGL', 'AMZN', 'MSFT', 'TSLA'];
  List<String> filteredSymbols = [];
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    filteredSymbols = symbols; // Initialize the filtered symbols with all symbols
  }

  Future<List<Map<String, dynamic>>> fetchStockData(List<String> symbols) async {
    List<Map<String, dynamic>> stocks = [];

    for (String symbol in symbols) {
      final url =
          'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        stocks.add({
          'symbol': symbol,
          'currentPrice': data['c'],
          'highPrice': data['h'],
          'lowPrice': data['l'],
        });
      } else {
        throw Exception('Failed to load stock data');
      }
    }
    return stocks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favorites: favorites,
                    fetchStockData: fetchStockData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Stocks',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  filteredSymbols = symbols
                      .where((symbol) =>
                          symbol.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchStockData(filteredSymbols),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No stock data available.'));
                }

                final stocks = snapshot.data!;
                return ListView.builder(
                  itemCount: stocks.length,
                  itemBuilder: (context, index) {
                    final stock = stocks[index];
                    final isFavorite = favorites.contains(stock['symbol']);
                    return ListTile(
                      title: Text('${stock['symbol']}'),
                      subtitle: Text(
                          'Current: \$${stock['currentPrice']} | High: \$${stock['highPrice']} | Low: \$${stock['lowPrice']}'),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favorites.remove(stock['symbol']);
                            } else {
                              favorites.add(stock['symbol']);
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final Set<String> favorites;
  final Future<List<Map<String, dynamic>>> Function(List<String>) fetchStockData;

  FavoritesScreen({required this.favorites, required this.fetchStockData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStockData(favorites.toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites added.'));
          }

          final stocks = snapshot.data!;
          return ListView.builder(
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              final stock = stocks[index];
              return ListTile(
                title: Text('${stock['symbol']}'),
                subtitle: Text(
                    'Current: \$${stock['currentPrice']} | High: \$${stock['highPrice']} | Low: \$${stock['lowPrice']}'),
                trailing: Icon(Icons.favorite, color: Colors.red),
              );
            },
          );
        },
      ),
    );
  }
}
