import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class TextSizeScreen extends StatefulWidget {
  const TextSizeScreen({Key? key}) : super(key: key);

  @override
  State<TextSizeScreen> createState() => _TextSizeScreenState();
}

class _TextSizeScreenState extends State<TextSizeScreen> {
  double _currentTextSize = 16.0;
  final double _minTextSize = 12.0;
  final double _maxTextSize = 24.0;

  @override
  void initState() {
    super.initState();
    _loadTextSize();
  }

  Future<void> _loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTextSize = prefs.getDouble('text_size') ?? 16.0;
    });
  }

  Future<void> _saveTextSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('text_size', size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fond gris clair comme la maquette
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Taille du texte',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Première carte - Instructions
                  _buildInstructionCard(),

                  const SizedBox(height: 16),

                  // Deuxième carte - Aperçu
                  _buildPreviewCard(),

                  const SizedBox(height: 16),

                  // Troisième carte - Contrôle de taille
                  _buildControlCard(),

                  const SizedBox(height: 16), // Espace pour le bouton
                ],
              ),
            ),
          ),

          // Bouton Appliquer toujours en bas
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icône avec deux T verts superposés
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: fibayaGreen,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Premier T (plus grand)
                const Text(
                  'T',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Deuxième T (plus petit, décalé)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'T',
                        style: TextStyle(
                          color: fibayaGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Titre principal
          const Text(
            'Ajuster la taille du texte',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            'Utilise le curseur pour prévisualiser et sélectionner une taille de texte confortable pour votre lecture.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section Aperçu
          const Text(
            'Aperçu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          // Titre de prévisualisation en vert
          Text(
            'Bienvenue sur FIBAYA',
            style: TextStyle(
              fontSize: _currentTextSize + 4, // Plus grand que le texte normal
              fontWeight: FontWeight.bold,
              color: fibayaGreen,
            ),
          ),

          const SizedBox(height: 12),

          // Texte de prévisualisation
          Text(
            'Votre plateforme panafricaine de services de proximité. Découvrez des prestataires qualifiés près de chez vous.',
            style: TextStyle(fontSize: _currentTextSize, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Contrôle du curseur
          Row(
            children: [
              // A petit
              Text(
                'A',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              const SizedBox(width: 16),

              // Curseur
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: fibayaGreen,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: fibayaGreen,
                    overlayColor: fibayaGreen.withOpacity(0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _currentTextSize,
                    min: _minTextSize,
                    max: _maxTextSize,
                    divisions: (_maxTextSize - _minTextSize).round(),
                    onChanged: (value) {
                      setState(() {
                        _currentTextSize = value;
                      });
                    },
                    onChangeEnd: (value) {
                      _saveTextSize(value);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // A grand
              Text(
                'A',
                style: TextStyle(fontSize: 24, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Indicateur de taille actuelle
          Text(
            'Taille actuelle: ${_currentTextSize.round()}px',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        24,
      ), // Moins de padding en bas
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              _saveTextSize(_currentTextSize);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Taille du texte appliquée avec succès'),
                  backgroundColor: fibayaGreen,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: fibayaGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Appliquer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
