import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:railpulse/core/services/train_service.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrainService _trainService;
  StreamSubscription? _telemetrySubscription;

  TrackingBloc(this._trainService) : super(TrackingInitial()) {
    on<StartTracking>((event, emit) {
      _telemetrySubscription?.cancel();
      _telemetrySubscription = _trainService.getLiveTelemetry(event.trainNumber).listen(
        (telemetry) => add(_UpdateTelemetry(telemetry)),
      );
    });

    on<_UpdateTelemetry>((event, emit) {
      emit(TrackingLoaded(event.telemetry));
    });
  }

  @override
  Future<void> close() {
    _telemetrySubscription?.cancel();
    return super.close();
  }
}
