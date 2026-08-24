import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Ticket {
  final String id;
  final String from;
  final String to;
  final DateTime date;
  final double fare;
  final String coachClass;

  Ticket({
    required this.id,
    required this.from,
    required this.to,
    required this.date,
    required this.fare,
    required this.coachClass,
  });
}

class BookingService {
  static const String _balanceKey = 'ncmc_balance';
  
  Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? 1240.50;
  }

  Future<void> updateBalance(double newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, newBalance);
  }

  Future<Ticket> createTicket(String from, String to, double fare, String coachClass) async {
    final id = Uuid().v4();
    final balance = await getBalance();
    if (balance < fare) throw Exception('Insufficient balance');
    
    await updateBalance(balance - fare);
    
    return Ticket(
      id: id,
      from: from,
      to: to,
      date: DateTime.now(),
      fare: fare,
      coachClass: coachClass,
    );
  }
}
