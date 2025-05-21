import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'team_member.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omah Kunci',
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentMemberIndex = 0;
  bool _isPrevHovered = false;
  bool _isNextHovered = false;
  bool _isMemberPressed = false;
  bool _isPrevClicked = false;
  bool _isNextClicked = false;

  final List<TeamMember> _teamMembers = [
    TeamMember(
      name: "Ken Bima Satria Gandasasmita",
      image: "assets/team/ken.png",
      whatsappUrl: "6282114198478",
    ),
    TeamMember(
      name: "Satya Wira Pramudita",
      image: "assets/team/satya.png",
      whatsappUrl: "6281216760668",
    ),
    TeamMember(
      name: "Iffa Hesti Adlik Putri",
      image: "assets/team/iffa.png",
      whatsappUrl: "6282134623295",
    ),
    TeamMember(
      name: "Kenji Ratanaputra",
      image: "assets/team/kenji.png",
      whatsappUrl: "6281371089032",
    ),
    TeamMember(
      name: "Geraldine",
      image: "assets/team/geraldine.png",
      whatsappUrl: "6282132031290",
    ),
    TeamMember(
      name: "Andre",
      image: "assets/team/andre.png",
      whatsappUrl: "62852574900"
    ),
  ];

  Future<void> _openWhatsApp(String phone, String name) async {
    try {
      final prefix = (name == "Satya" || name == "Kenji") ? "" : "ka ";
      final message = "Halo ${prefix}${name}, aku mau pinjam kunci Basecamp";
      final url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
    }
  }

  Future<void> _openMaps() async {
    try {
      const url = 'https://maps.app.goo.gl/HPQsNj6NYDakmNAY8';
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error opening Maps: $e');
    }
  }

  Widget _buildLocationSection(double height, double width, double textScale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Row(
        children: [
          GestureDetector(
            onTap: _openMaps,
            child: Container(
              width: width * 0.4,
              height: height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/maps.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: width * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: height * 0.06 * textScale,
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: 'SEE OUR ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'LOCATION',
                          style: TextStyle(color: Color(0xFFF0861A)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Wisma FMIPA UGM\n69FG+QRP, Sagan, Caturtunggal, Depok, Sleman Regency, Special Region of Yogyakarta 55281',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.02 * textScale,
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(double height, double width, double textScale) {
    return Column(
      children: [
        SizedBox(height: height * 0.15),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isPrevClicked = true),
                  onTapUp: (_) => setState(() {
                    _isPrevClicked = false;
                    if (_currentMemberIndex > 0) {
                      _currentMemberIndex--;
                    } else {
                      _currentMemberIndex = _teamMembers.length - 1;
                    }
                  }),
                  onTapCancel: () => setState(() => _isPrevClicked = false),
                  child: Container(
                    width: width * 0.5,
                    height: width * 0.5,
                    child: Image.asset(
                      _isPrevClicked || _isPrevHovered ? 'assets/prev_clicked.png' : 'assets/prev.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isMemberPressed = true),
                  onTapUp: (_) async {
                    setState(() => _isMemberPressed = false);
                    final member = _teamMembers[_currentMemberIndex];
                    await _openWhatsApp(
                      member.whatsappUrl,
                      member.name.split(' ')[0]
                    );
                  },
                  onTapCancel: () => setState(() => _isMemberPressed = false),
                  child: Container(
                    width: width * 0.3,
                    height: width * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(_teamMembers[_currentMemberIndex].image),
                        fit: BoxFit.cover,
                        colorFilter: _isMemberPressed
                            ? ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isNextClicked = true),
                  onTapUp: (_) => setState(() {
                    _isNextClicked = false;
                    if (_currentMemberIndex < _teamMembers.length - 1) {
                      _currentMemberIndex++;
                    } else {
                      _currentMemberIndex = 0;
                    }
                  }),
                  onTapCancel: () => setState(() => _isNextClicked = false),
                  child: Container(
                    width: width * 0.5,
                    height: width * 0.5,
                    child: Image.asset(
                      _isNextClicked || _isNextHovered ? 'assets/next_clicked.png' : 'assets/next.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.02),
        Text(
          _teamMembers[_currentMemberIndex].name,
          style: TextStyle(
            color: Colors.white,
            fontSize: height * 0.025 * textScale,
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: height * 0.15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Image.asset(
            'assets/full_logo.png',
            height: 80,
            width: 128,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;
          final textScale = MediaQuery.of(context).textScaleFactor;
          
          return ListView(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/main_1.png",
                    width: double.infinity,
                    height: height * 0.9,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: height * 0.9,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.05
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: height * 0.06 * textScale,
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w800,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'We Are Omah ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    TextSpan(
                                      text: 'Kunci',
                                      style: TextStyle(color: Color(0xFFF0861A)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Find contact details of those entrusted\nwith access to the OmahTI basecamp',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.02 * textScale,
                                  fontFamily: 'PlusJakartaSans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.001),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: height * 0.06 * textScale,
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Get Access To ',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Basecamp',
                                style: TextStyle(color: Color(0xFFF0861A)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: height * 0.06 * textScale,
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              TextSpan(
                                text: 'Through ',
                                style: TextStyle(color: Color(0xFFF0861A)),
                              ),
                              const TextSpan(
                                text: 'Us!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.001),
              _buildTeamSection(height, width, textScale),
              _buildLocationSection(height, width, textScale),
              SizedBox(height: height * 0.15),
            ],
          );
        },
      ),
    );
  }
}
