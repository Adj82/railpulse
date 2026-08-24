import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<PerformSearch>((event, emit) async {
      emit(SearchLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(SearchSuccess(from: event.from, to: event.to));
    });
  }
}
