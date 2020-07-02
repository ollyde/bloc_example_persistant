import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'counter_bloc.g.dart';

final counterBlock = CounterBloc();

@JsonSerializable(nullable: false)
class CounterState {
  final int total;

  CounterState({this.total = 0});
}

class CounterBloc extends HydratedBloc<dynamic, CounterState> {
  CounterBloc() : super(CounterState(total: 0));

  @override
  Stream<CounterState> mapEventToState(dynamic event) async* {
    if (event is IncreaseCount) {
      print('CounterEvent.increment');
      yield CounterState(total: state.total + event.total);
      return;
    }
  }

  @override
  CounterState fromJson(Map<String, dynamic> json) => _$CounterStateFromJson(json);

  @override
  Map<String, dynamic> toJson(CounterState state) => _$CounterStateToJson(state);
}

class IncreaseCount {
  final int total;
  IncreaseCount(this.total);
}
