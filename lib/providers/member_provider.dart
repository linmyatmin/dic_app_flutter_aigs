import 'package:dic_app_flutter/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memberProvider = StateProvider<Member?>((ref) => null);

final authStatusProvider = StateProvider<bool>((ref) => false);



// final fetchMemberProvider = FutureProvider((ref) {
//   const 
// });
