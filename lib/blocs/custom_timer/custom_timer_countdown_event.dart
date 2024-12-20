// custom_timer_countdown_event.dart
part of 'custom_timer_countdown_bloc.dart';

abstract class CustomTimerCountdownEvent extends Equatable {
  const CustomTimerCountdownEvent();

  @override
  List<Object> get props => [];
}

class TimerCountdownStarted extends CustomTimerCountdownEvent {
  final int duration;

  const TimerCountdownStarted({required this.duration});

  @override
  List<Object> get props => [duration];
}

class TimerCountdownPaused extends CustomTimerCountdownEvent {
  const TimerCountdownPaused();
}

class TimerCountdownResumed extends CustomTimerCountdownEvent {
  const TimerCountdownResumed();
}

class TimerCountdownReset extends CustomTimerCountdownEvent {
  final int duration; // Allow resetting with a custom duration

  const TimerCountdownReset({required this.duration});

  @override
  List<Object> get props => [duration];
}

class TimerCountdownStopped extends CustomTimerCountdownEvent {
  const TimerCountdownStopped();
}

class _TimerCountdownTicked extends CustomTimerCountdownEvent {
  final int duration;

  const _TimerCountdownTicked({required this.duration});

  @override
  List<Object> get props => [duration];
}