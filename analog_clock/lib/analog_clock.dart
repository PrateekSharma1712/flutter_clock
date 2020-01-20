// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/hand.dart';
import 'package:analog_clock/watch_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _condition = '';
  var _time = '';
  var _location = '';
  final double faceRadius = 240;
  final double hourHandRadius = 180;
  final double minuteHandRadius = 140;
  final double secondHandRadius = 90;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _time = DateFormat.Hms().format(_now);
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFFDEE0B5),
            //Hour Hand
            highlightColor: Color(0xFF666553),
            // Minute hand
            accentColor: Color(0xFF523911),
            // Second hand.
            canvasColor: Color(0xFFFFFFFF),
            backgroundColor: Color(0xFF0C0B0A), //Dial Color & Font Color
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFDDB5B5),
            highlightColor: Color(0xFFC4D4CC),
            accentColor: Color(0xFF96A8BA),
            canvasColor: Color(0xFF0C0B0A),
            backgroundColor: Color(0xFFFFFFFF),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.backgroundColor, fontWeight: FontWeight.w500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_condition),
          Text(_time),
          Spacer(),
          Text(_location),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.canvasColor,
        child: Stack(
          children: [
            WatchDial(
              radius: faceRadius,
              color: customTheme.backgroundColor,
              textColor: customTheme.canvasColor,
            ),
            //Hour Hand
            Hand(
              color: customTheme.primaryColor,
              timeComponent: _now.hour,
              radiansPerChange: radiansPerHour,
              radius: hourHandRadius,
            ),
            //Minute Hand
            Hand(
              color: customTheme.highlightColor,
              timeComponent: _now.minute,
              radiansPerChange: radiansPerTick,
              radius: minuteHandRadius,
            ),
            //Second Hand
            Hand(
              color: customTheme.accentColor,
              timeComponent: _now.second,
              radiansPerChange: radiansPerTick,
              radius: secondHandRadius,
            ),
            Positioned(
              left: 0,
              bottom: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: weatherInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
