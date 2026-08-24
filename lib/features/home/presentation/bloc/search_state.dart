part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final String from;
  final String to;
  const SearchSuccess({required this.from, required this.to});
  @override
  List<Object> get props => [from, to];
}
