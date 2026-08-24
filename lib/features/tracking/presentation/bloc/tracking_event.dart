part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();
  @override
  List<Object> get props => [];
}

class StartTracking extends TrackingEvent {
  final String trainNumber;
  const StartTracking(this.trainNumber);
  @override
  List<Object> get props => [trainNumber];
}

class _UpdateTelemetry extends TrackingEvent {
  final TrainTelemetry telemetry;
  const _UpdateTelemetry(this.telemetry);
  @override
  List<Object> get props => [telemetry];
}
