import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



final supabase = Supabase.instance.client;

Future<void> startAssignment(int id) async {
  await supabase
      .from('grn_crates')
      .update({'started_at': DateTime.now().toIso8601String()})
      .eq('id', id);
}

Future<void> finishAssignment(int id) async {
  await supabase
      .from('grn_crates')
      .update({'finished_at': DateTime.now().toIso8601String()})
      .eq('id', id);
}
