import 'package:flutter/material.dart';
import '../../../../core/utils/supabase_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  String _testResult = 'Not tested yet';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testUserProfilesTable,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Test User Profiles Table'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResult,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testUserProfilesTable() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing database connection...';
    });

    try {
      final supabaseService = SupabaseService.instance;

      // Test 1: Check if we can query the table
      _updateResult('Test 1: Checking table access...');
      final response = await supabaseService.client
          .from('user_profiles')
          .select('*')
          .limit(1);

      _updateResult('Test 1: SUCCESS - Table is accessible');
      _updateResult('Sample response: $response');

      // Test 2: Check table structure by trying to insert a test record
      _updateResult('\nTest 2: Checking table structure...');

      final testProfile = {
        'id': 'test-id-${DateTime.now().millisecondsSinceEpoch}',
        'email': 'test@example.com',
        'full_name': 'Test User',
        'role': 'customer',
        'is_verified': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      try {
        await supabaseService.client.from('user_profiles').insert(testProfile);
        _updateResult('Test 2: SUCCESS - Test record inserted');

        // Clean up - delete the test record
        await supabaseService.client
            .from('user_profiles')
            .delete()
            .eq('id', testProfile['id']!);
        _updateResult('Test cleanup: Test record deleted');
      } catch (insertError) {
        _updateResult('Test 2: FAILED - Insert error: $insertError');
      }

      // Test 3: Check existing profiles
      _updateResult('\nTest 3: Checking existing profiles...');
      final allProfiles = await supabaseService.client
          .from('user_profiles')
          .select('id, email, full_name');

      _updateResult('Test 3: Found ${allProfiles.length} existing profiles');
      if (allProfiles.isNotEmpty) {
        _updateResult('Existing profiles:');
        for (final profile in allProfiles) {
          _updateResult('  - ${profile['full_name']} (${profile['email']})');
        }
      }
    } catch (e) {
      _updateResult('ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateResult(String message) {
    setState(() {
      _testResult += '\n$message';
    });
  }
}
