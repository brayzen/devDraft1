
process.stdin.resume();
process.stdin.setEncoding('utf8');

fullInput = ''

process.stdin.on('data', function(chunk) {
  if (chunk !== null)
  {
    fullInput += chunk;
  }
  if (chunk === '\n'){
    process.exit;
    solveProblem(fullInput);
  }
});

// process.stdin.on('\n', function() {
//   puts
//   solveProblem(fullInput);
// });

var MINUTES_IN_DAY = 24 * 60;

function solveProblem(input) {

  /**
   * Converts a string in the format hh:mm (of a 24-hour clock)
   * to minutes past midnight.  For example, 01:30 becomes 90.
   * @param hhmm a string in the format hh:mm such as 23:41
   * @return how many minutes past midnight have elapsed
   */
  function toMinutes(hhmm) {
    var parts = hhmm.split(":");
    return parseInt(parts[0]) * 60 + parseInt(parts[1]);
  }

  /**
   * Converts a number of minutes past midnight into a String representation
   * in the format hh:mm of a 24-hour clock.  For example, 90 becomes 01:30.
   * @param minutes time past midnight
   * @return the time in format h:mm or hh:mm, such as 23:41
   */
  function formatMinutes(minutes) {
    var hours = Math.floor(minutes / 60);
    var mins = minutes % 60;
    return ((hours < 10) ? '0' + hours : hours) + ':' + ((mins < 10) ? '0' + mins : mins);
  }

  /**
   * @param travelTimes
   *      How long it takes (in minutes) to go between stops i and i +
   *      1, either northbound or southbound.
   * @param intervalStarts
   *      The starts of time intervals that describe the frequency of
   *      trains leaving from the northernmost and southernmost
   *      stations. An interval starts at the ith entry and ends 1
   *      minute earlier than the (i + 1)th entry. The starts should
   *      be ordered chronologically.
   * @param intervalPeriods
   *      How frequently (in minutes) trains leave from the northernmost
   *      and southernmost stations during a time interval described by
   *      intervalStarts. That is, between the times intervalStarts[i]
   *      and intervalStarts[i + 1] - 1, trains leave every
   *      intervalPeriods[i] minutes. The last element describes the
   *      frequency until the last train leaves.
   * @param northFirst
   *      When the first northbound train leaves the southernmost
   *      station, as minutes past midnight.
   * @param northLast
   *      The latest a northbound train may leave the southernmost
   *      station. This does not guarantee a train leaves then--it just
   *      means a train won't leave the southernmost station if it's
   *      past this time.  Expressed as minutes past midnight.
   * @param southFirst
   *      When the first southbound train leaves the northernmost
   *      station, as minutes past midnight.
   * @param southLast
   *      The latest a southbound train may leave the northernmost
   *      station. This does not guarantee a train leaves then--it just
   *      means a train won't leave the northernmost station if it's
   *      past this time.  Expressed as minutes past midnight.
   */
  function LightRailApp(travelTimes, intervalStarts, intervalPeriods,
      northFirst, northLast, southFirst, southLast) {
    this.travelTimes = travelTimes;
    this.intervalStarts = intervalStarts;
    this.intervalPeriods = intervalPeriods;
    this.northFirst = northFirst;
    this.northLast = northLast;
    this.southFirst = southFirst;
    this.southLast = southLast;

    this.nextTrain = nextLightRailAppNextTrain;
  }


  /**
   * Returns the earliest time at or after the given time when a train
   * will arrive at the stop.
   * @param leave the time at or after the train may leave.
   * @param stop which stop to leave from (0 being southernmost)
   * @param north whether the train is northbound (otherwise southbound)
   * @return the earliest time a train will leave at or after the time given.
   */
  function nextLightRailAppNextTrain(leave, stop, north) {
    // how many minutes ahead this stop is from the first station
    // (the "first" station is the southernmost station if northbound,
    // and northernomst station if southbound).
    var offset = 0;

    // the earliest departure time of a train at the first station
    var first;

    // the latest possible departure time of a train at the first stop
    var last;
    if (north) {
      first = this.northFirst;
      last = this.northLast;
        // console.log(this.travelTimes.length);
      if (stop == 0){
        offset = 0;
      } else {
        for (var i = 0; i < stop ; i++) {
        // console.log(i);
          offset += this.travelTimes[i];
        // console.log(offset)
        }
      }
    } else {
      first = this.southFirst;
      last = this.southLast;
      if (stop == 0){
        offset = 0;
      } else {
        for (var i = this.travelTimes.length - 1; i > stop; i--) {
          offset += this.travelTimes[i];
        }
      }
    }

    // normalized leave time--when the rider would want to leave, if they were
    // at the first station
    var normLeave = leave - offset;
    // console.log(offset + '    %%%%%%%%%%%%%%%%%%%%%%%');
    // console.log(normLeave);
    // console.log(leave);
    // if outside train operating hours, just return the first train.
    if (normLeave < first && last + (24 * 60) > normLeave) {
      console.log('TRUE its too late or early');
      return first + offset

    }


    // when the desired train leaves the first station
    var trainLeave = first;
    var i = 0;
    while (trainLeave < normLeave) {
      // console.log('****************      *****************');
    // console.log(' > ' + last );
    // console.log(normLeave);
    // console.log(' < ' + first);

    // console.log(trainLeave);
      trainLeave += intervalPeriods[i];
      if (i + 1 < intervalStarts.length && trainLeave >= intervalStarts[i + 1]) {
        i++;
      }
    }
    console.log(formatMinutes(trainLeave));
    // console.log(formatMinutes(trainLeave));
    return trainLeave + offset;
  }

  // parse the input
  var lines = input.split('\n');
  var index = 0;
  // console.log(lines);

  // read stop count
  var stopCount = parseInt(lines[index++]);
  // console.log(stopCount);
  var stops = [];

  // read stops
  var parts = lines[index++].split(" ");
  for (var i = 0; i < parts.length; i++) {
    stops[i] = parseInt(parts[i]);
  }

  // read first and latest departure times, for northbound and southbound
  parts = lines[index++].split(" ");
  var northFirst = toMinutes(parts[0]);
  var northLast = toMinutes(parts[1]);

  parts = lines[index++].split(" ");
  var southFirst = toMinutes(parts[0]);
  var southLast = toMinutes(parts[1]);

  // read intervals and periods
  var intervalCount = parseInt(lines[index++]);
  var intervalStarts = [];
  var intervalPeriods = [];
  for (var i = 0; i < intervalCount; i++) {
    parts = lines[index++].split(" ");
    intervalStarts[i] = toMinutes(parts[0]);
    intervalPeriods[i] = parseInt(parts[1]);
  }

  // read query count
  var queryCount = parseInt(lines[index++]);

  // read and process queries
  var app = new LightRailApp(stops, intervalStarts, intervalPeriods,
      northFirst, northLast, southFirst, southLast);

  for (var i = 0; i < queryCount; i++) {
    parts = lines[index++].split(" ");
    if (i > 0) process.stdout.write('\n');
    // console.log(parts[0], parts[1]);
    // // console.log(parts[1]);
    // // console.log(parts[2]);
    // console.log(toMinutes(parts[0]));
    process.stdout.write(formatMinutes(app.nextTrain(toMinutes(parts[0]), parseInt(parts[1]), parts[2][0] == 'N')));
    // console.log('\n###################################################');
  }
}
