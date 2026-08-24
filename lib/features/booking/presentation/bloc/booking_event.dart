part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object> get props => [];
}

class LoadBookingData extends BookingEvent {}

class BookTicket extends BookingEvent {
  final String from;
  final String to;
  final double fare;
  final String coachClass;

  const BookTicket({
    required this.from,
    required this.to,
    required this.fare,
    required this.coachClass,
  });

  @override
  List<Object> get props => [from, to, fare, coachClass];
}

class TopUpBalance extends BookingEvent {
  final double amount;
  const TopUpBalance(this.amount);
  @override
  List<Object> get props => [amount];
}
