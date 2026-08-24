part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class PerformSearch extends SearchEvent {
  final String from;
  final String to;
  const PerformSearch({required this.from, required this.to});
  @override
  List<Object> get props => [from, to];
}
