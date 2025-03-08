import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'api_service.dart';

class ECGMonitorScreen extends StatefulWidget {
  @override
  _ECGMonitorScreenState createState() => _ECGMonitorScreenState();
}

class _ECGMonitorScreenState extends State<ECGMonitorScreen> {
  final List<FlSpot> _ecgData = [];
  final int _maxDataPoints = 500;
  Timer? _dataTimer;
  StreamController<List<FlSpot>>? _dataStreamController;
  double _currentBpm = 0.0;
  bool _isConnected = false;
  String _errorMessage = '';
  DateTime? _lastUpdateTime;

  @override
  void initState() {
    super.initState();
    _initializeDataStream();
  }

  void _initializeDataStream() {
    _dataStreamController = StreamController();
    _startDataFetching();
  }

  void _startDataFetching() {
    const fetchInterval = Duration(milliseconds: 200);
    _dataTimer = Timer.periodic(fetchInterval, (timer) async {
      if (!mounted) return;

      try {
        final newData = await ApiService.fetchECGData();
        if (newData.isEmpty) return;

        _processNewData(newData);
        _calculateHeartRate(newData);

        setState(() {
          _isConnected = true;
          _errorMessage = '';
          _lastUpdateTime = DateTime.now();
        });
      } catch (e) {
        _handleError(e);
      }
    });
  }

  void _processNewData(List<Map<String, double>> newData) {
    final updatedData = [..._ecgData];

    for (final point in newData) {
      updatedData.add(FlSpot(point["timestamp"]!, point["value"]!));
      if (updatedData.length > _maxDataPoints) {
        updatedData.removeAt(0);
      }
    }

    _dataStreamController?.add(updatedData);
  }

  void _calculateHeartRate(List<Map<String, double>> data) {
    if (data.length < 2) return;

    List<double> peaks = [];
    for (int i = 1; i < data.length - 1; i++) {
      if (data[i]["value"]! > data[i - 1]["value"]! &&
          data[i]["value"]! > data[i + 1]["value"]!) {
        peaks.add(data[i]["timestamp"]!);
      }
    }

    if (peaks.length < 2) return;

    List<double> intervals = [];
    for (int i = 1; i < peaks.length; i++) {
      intervals.add(peaks[i] - peaks[i - 1]);
    }

    if (intervals.isEmpty) return;

    double avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
    double bpm = 60 / avgInterval;

    setState(() {
      _currentBpm = bpm;
    });
  }

  void _handleError(dynamic error) {
    setState(() {
      _isConnected = false;
      _errorMessage = 'Connection Error: ${error.toString()}';
    });
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && !_isConnected) _startDataFetching();
    });
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    _dataStreamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical ECG Monitor'),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: _showSettings),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [_buildECGChart(), _buildVitalStats()],
        ),
      ),
      floatingActionButton: _buildConnectionStatus(),
    );
  }

  Widget _buildECGChart() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<FlSpot>>(
            stream: _dataStreamController?.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return _buildErrorDisplay();
              if (!snapshot.hasData) return _buildLoadingIndicator();

              double minX = snapshot.data!.isEmpty ? 0 : snapshot.data!.first.x;
              double maxX = snapshot.data!.isEmpty ? 10 : snapshot.data!.last.x;

              return LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: -1.5,
                  maxY: 2.5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: snapshot.data!,
                      isCurved: true,
                      color: Colors.lightGreenAccent,
                      barWidth: 1.5,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightGreenAccent.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVitalStats() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildVitalStatItem('Heart Rate', '${_currentBpm.toStringAsFixed(0)} BPM'),
          _buildVitalStatItem('Last Update', _lastUpdateTime?.toString().split('.').first ?? '--:--'),
        ],
      ),
    );
  }

  Widget _buildVitalStatItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(color: Colors.lightGreenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return FloatingActionButton(
      backgroundColor: _isConnected ? Colors.green : Colors.red,
      onPressed: _isConnected ? null : _startDataFetching,
      child: Icon(_isConnected ? Icons.link : Icons.link_off),
    );
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator(color: Colors.lightGreenAccent));
  Widget _buildErrorDisplay() => Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)));
  void _showSettings() {}
}
