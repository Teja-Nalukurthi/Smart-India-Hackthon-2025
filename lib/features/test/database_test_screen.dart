import 'package:flutter/material.dart';
import '../../../core/utils/supabase_service.dart';
import '../../../core/models/artisan.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  final _supabaseService = SupabaseService.instance;
  List<Artisan> _artisans = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadArtisans();
  }

  Future<void> _loadArtisans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final artisans = await _supabaseService.getArtisans(limit: 10);
      setState(() {
        _artisans = artisans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading artisans: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Connection Status
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  _supabaseService.currentUser != null
                      ? Icons.check_circle
                      : Icons.error,
                  color: _supabaseService.currentUser != null
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _supabaseService.currentUser != null
                      ? 'Connected to Supabase'
                      : 'Not authenticated',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Refresh Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loadArtisans,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Load Artisans'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Make sure you have:\n'
                          '1. Updated your Supabase credentials\n'
                          '2. Run the database schema\n'
                          '3. Added some sample artisan data',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _artisans.isEmpty && !_isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, size: 48, color: Colors.blue),
                        SizedBox(height: 16),
                        Text(
                          'No artisans found',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Your database is connected but empty.\n'
                          'Add some sample data to see results.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _artisans.length,
                    itemBuilder: (context, index) {
                      final artisan = _artisans[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: artisan.imageUrl != null
                                ? NetworkImage(artisan.imageUrl!)
                                : null,
                            backgroundColor: Colors.orange,
                            child: artisan.imageUrl == null
                                ? Text(artisan.name[0].toUpperCase())
                                : null,
                          ),
                          title: Text(artisan.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(artisan.description),
                              Text(
                                '${artisan.category.toString().split('.').last} • ${artisan.location}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    '${artisan.rating} (${artisan.reviewCount} reviews)',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: artisan.isVerified
                              ? const Icon(Icons.verified, color: Colors.blue)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
