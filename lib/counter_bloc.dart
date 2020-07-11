import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'counter_bloc.g.dart';

/**
 * The bloc can be easily accessed anywhere.
 */
final counterBlock = CounterBloc();

/**
 * Note that it is automatically serialized.
 * Makes it easy to add new fields.
 */
@JsonSerializable(nullable: false)
class CounterState {
  final int total;

  CounterState({this.total = 0});

  copy({int total}) {
    total = total ?? this.total;
  }
}

class CounterBloc extends HydratedBloc<dynamic, CounterState> {
  CounterBloc() : super(CounterState(total: 0));

  @override
  Stream<CounterState> mapEventToState(dynamic event) async* {
    if (event is IncreaseCount) {
      final currentTotal = counterBlock.state.total;
      yield counterBlock.state.copy(total: currentTotal + event.add);
      return;
    }
  }

  @override
  CounterState fromJson(Map<String, dynamic> json) => _$CounterStateFromJson(json);

  @override
  Map<String, dynamic> toJson(CounterState state) => _$CounterStateToJson(state);
}

class IncreaseCount {
  final int add;
  IncreaseCount(this.add);
}
