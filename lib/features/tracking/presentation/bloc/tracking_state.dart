part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();
  @override
  List<Object> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final TrainTelemetry telemetry;
  const TrackingLoaded(this.telemetry);
  @override
  List<Object> get props => [telemetry];
}
