import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    DashboardContent(),
    ProfileContent(),
    ReportContent(),
    SettingsContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Hospital App',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: GlassContainer(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        blur: 10,
        color: Colors.white.withOpacity(0.2),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.grey[600],
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildGlassCard("Patients", "View patient records", Colors.blue[800]!),
        _buildGlassCard("Appointments", "Check your schedule", Colors.green[600]!),
        _buildGlassCard("Reports", "View medical reports", Colors.orange[800]!),
        _buildGlassCard("Notifications", "3 new alerts", Colors.red[600]!),
      ],
    );
  }

  Widget _buildGlassCard(String title, String subtitle, Color color) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(20),
      blur: 10,
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.medical_services, size: 32, color: color),
            SizedBox(height: 8),
            Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        blur: 10,
        color: Colors.white.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/placeholder.png'),
              ),
              SizedBox(height: 16),
              Text('Dr. John Doe', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('Cardiologist', style: GoogleFonts.poppins(color: Colors.grey[600])),
              Text('john.doe@hospital.com', style: GoogleFonts.poppins(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        blur: 10,
        color: Colors.white.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bar_chart, size: 48, color: Colors.blue[800]),
              SizedBox(height: 16),
              Text('Monthly Report', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Your monthly activity report is ready to view.', style: GoogleFonts.poppins(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        blur: 10,
        color: Colors.white.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, size: 48, color: Colors.blue[800]),
              SizedBox(height: 16),
              Text('Account Settings', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Manage your account preferences and settings.', style: GoogleFonts.poppins(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}