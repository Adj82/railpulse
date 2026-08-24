import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:railpulse/core/services/booking_service.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingService _bookingService;

  BookingBloc(this._bookingService) : super(BookingInitial()) {
    on<LoadBookingData>((event, emit) async {
      emit(BookingLoading());
      try {
        final balance = await _bookingService.getBalance();
        emit(BookingLoaded(balance: balance));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });

    on<BookTicket>((event, emit) async {
      try {
        final ticket = await _bookingService.createTicket(
          event.from, event.to, event.fare, event.coachClass
        );
        final balance = await _bookingService.getBalance();
        emit(BookingLoaded(balance: balance, lastTicket: ticket));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });

    on<TopUpBalance>((event, emit) async {
      try {
        final currentBalance = await _bookingService.getBalance();
        await _bookingService.updateBalance(currentBalance + event.amount);
        emit(BookingLoaded(balance: currentBalance + event.amount));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });
  }
}
