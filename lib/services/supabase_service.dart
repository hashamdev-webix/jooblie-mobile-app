import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService() : _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  // You can add global configurations or helpers related to the client here.
}
