// custom_timer_countdown_state.dart
part of 'custom_timer_countdown_bloc.dart';

abstract class CustomTimerCountdownState extends Equatable {
  final int duration;

  const CustomTimerCountdownState(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends CustomTimerCountdownState {
  const TimerInitial(super.duration);
}

class TimerRunInProgress extends CustomTimerCountdownState {
  const TimerRunInProgress(super.duration);
}

class TimerRunPause extends CustomTimerCountdownState {
  const TimerRunPause(super.duration);
}

class TimerRunComplete extends CustomTimerCountdownState {
  const TimerRunComplete() : super(0);
}