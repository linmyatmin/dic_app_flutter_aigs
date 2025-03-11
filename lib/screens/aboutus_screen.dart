import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  final bool showAppBar;

  const AboutUsScreen({Key? key, this.showAppBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 800 ? screenWidth * 0.2 : 20.0;
    final primaryColor = Theme.of(context).primaryColorLight;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: showAppBar
          ? AppBar(
              title: const Text(
                'About Us',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GEMPEDIA is a compendium of more than 7,300 terms and definitions gathered over decades by Rui Galopim de Carvalho FGA DGA, a renowned professional gemmologist and consultant with over 30 years of experience within the gems and jewellery trade in gem testing, education and science communication.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This compilation has been endorsed by Gem-A—The Gemmological Association of Great Britain, the world\'s longest-established provider of gem and jewellery education, and supported by the Asian Institute of Gemological Sciences (AIGS), one of Asia\'s first international gemmological institutes.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.8,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'This glossary for gemstones and gemology was made for students, professionals, and gem and jewellery aficionados to provide the most comprehensive reference source for understanding and clarifying the wide-ranging terminology used across the fascinating world of gemmology and its associated industries.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.8,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),
              _buildQuoteSection(screenWidth),
              const SizedBox(height: 40),
              _buildLogos(screenWidth),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuote(
          '"This book is a must-have for anyone interested in gemmology"',
          'Guy Lalous',
          'Ambassador FEEG – Federation for European Education in Gemmology',
        ),
        const SizedBox(height: 15),
        _buildQuote(
          '"Not only a \'go to\' guide for gemmology, but one that can be entirely read and browsed to increase your own knowledge"',
          'Alan Hart',
          'CEO – Gem-A, The Gemmological Association of Great Britain',
        ),
        const SizedBox(height: 15),
        _buildQuote(
          '"It\'s really a great reference book for me and should be highly recommended to all gemmologists"',
          'Edward Liu',
          'Chairman – The Gemmological Association of Hong Kong',
        ),
        const SizedBox(height: 15),
        _buildQuote(
          '"This work of Rui Galopim, a renowned friend in gemmology, is highly admirable"',
          'Pornsawat Wathanakul',
          'former Director of GIT – Gem & Jewelry Institute of Thailand',
        ),
      ],
    );
  }

  Widget _buildQuote(String quote, String name, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quote,
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$name, $title',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogos(double screenWidth) {
    final logoSize = screenWidth > 600 ? 200.0 : screenWidth * 0.3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          'assets/images/aigs_logo.png',
          width: logoSize,
          color: Colors.white,
        ),
        Image.asset(
          'assets/images/gema_logo.png',
          width: logoSize,
          color: Colors.white,
        ),
      ],
    );
  }
}
