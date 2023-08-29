extension NumDurationEx on num {
  Duration get msec => Duration(milliseconds: round());
  Duration get secs => (this * 1000).msec;
  Duration get mins => (this * 60 * 1000).msec;
  Duration get hours => (this * 60 * 60 * 1000).msec;
  Duration get days => (this * 24 * 60 * 60 * 1000).msec;
  Duration get weeks => (this * 7 * 24 * 60 * 60 * 1000).msec;
}
