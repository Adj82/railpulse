part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final double balance;
  final Ticket? lastTicket;

  const BookingLoaded({required this.balance, this.lastTicket});

  @override
  List<Object> get props => [balance, lastTicket ?? ''];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object> get props => [message];
}
