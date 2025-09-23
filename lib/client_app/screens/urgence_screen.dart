import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UrgenceScreen extends StatefulWidget {
  const UrgenceScreen({Key? key}) : super(key: key);

  @override
  State<UrgenceScreen> createState() => _UrgenceScreenState();
}

class _UrgenceScreenState extends State<UrgenceScreen> {
  bool _isLocationSharingEnabled = false;
  List<EmergencyContact> _trustedContacts = [
    EmergencyContact(name: 'bj', phoneNumber: '+221 77 123 4567'),
    EmergencyContact(name: 'Saliou', phoneNumber: '+221 77 234 5678'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Urgence',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Bouton Appeler Ambulance
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        _callAmbulance();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E), // Rouge
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Appeler Ambulance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bouton Appeler Police
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        _callPolice();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2), // Bleu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_police,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Appeler Police',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Section Partage de Localisation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5), // Gris clair
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre avec icône
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF4CAF50), // Vert
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Partage de Localisation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Toggle pour partage en temps réel
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Partager ma position en temps réel',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Switch(
                              value: _isLocationSharingEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isLocationSharingEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFF4CAF50),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          'Activez cette option pour partager automatiquement votre position avec vos contacts de confiance en cas d\'urgence.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section Contacts de confiance
                        const Text(
                          'Contacts de confiance:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Liste des contacts: toujours 3 emplacements
                        Row(
                          children: [
                            ...List.generate(3, (index) {
                              final bool hasContact =
                                  index < _trustedContacts.length;
                              Widget child = hasContact
                                  ? _buildContactItem(_trustedContacts[index])
                                  : _buildAddSlot();
                              return Expanded(child: child);
                            }).expand((w) sync* {
                              // Inserer des espacements egaux entre les 3 slots
                              yield w;
                              if (w !=
                                  List.generate(
                                    3,
                                    (_) => const SizedBox(),
                                  ).last) {
                                // Ce hack n'est pas ideal; on gere l'espacement apres la generation reelle ci-dessous.
                              }
                            }).toList(),
                          ].separated(const SizedBox(width: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Message d'avertissement en bas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Color(0xFFFF9800), // Orange
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'En cas d\'urgence, restez calme et suivez les instructions des services de secours.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(EmergencyContact contact) {
    return GestureDetector(
      onTap: () {
        _showContactOptions(contact);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFFB0B0B0), // Gris plus clair
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contact.name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black, // Noir au lieu de gris
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _callAmbulance() {
    // Simuler l'appel d'ambulance
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fond blanc explicite
        title: const Text('Appel d\'urgence'),
        content: const Text('Appel de l\'ambulance en cours...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _callPolice() {
    // Simuler l'appel de la police
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fond blanc explicite
        title: const Text('Appel d\'urgence'),
        content: const Text('Appel de la police en cours...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fond blanc explicite
        title: const Text(
          'Ajouter un contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du contact',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ajouter une photo (simulation)
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  'Ajouter une photo',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                setState(() {
                  _trustedContacts.add(
                    EmergencyContact(
                    name: nameController.text,
                    phoneNumber: phoneController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Ajouter',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(EmergencyContact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Fond blanc explicite
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contact.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              icon: Icons.edit,
              text: 'Modifier',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                _showEditContactDialog(contact);
              },
            ),
            // Séparateur
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey.withOpacity(0.3),
            ),
            _buildOptionButton(
              icon: Icons.phone,
              text: 'Appeler',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                _callContact(contact);
              },
            ),
            // Séparateur
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey.withOpacity(0.3),
            ),
            _buildOptionButton(
              icon: Icons.delete,
              text: 'Supprimer',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _deleteContact(contact);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color),
        label: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent, // Pas de fond coloré
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _showEditContactDialog(EmergencyContact contact) {
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fond blanc explicite
        title: const Text(
          'Modifier le contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du contact',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                setState(() {
                  final index = _trustedContacts.indexOf(contact);
                  _trustedContacts[index] = EmergencyContact(
                    name: nameController.text,
                    phoneNumber: phoneController.text,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Modifier',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }

  void _callContact(EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fond blanc explicite
        title: const Text('Appel'),
        content: Text('Appel de ${contact.name} en cours...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fond blanc explicite
        title: const Text('Supprimer le contact'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${contact.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _trustedContacts.remove(contact);
              });
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSlot() {
    return GestureDetector(
      onTap: () {
        if (_trustedContacts.length < 3) {
          _showAddContactDialog();
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFFB0B0B0), size: 30),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ajouter',
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

extension _SeparatedChildren on List<Widget> {
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this;
    final List<Widget> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

class EmergencyContact {
  final String name;
  final String phoneNumber;

  EmergencyContact({required this.name, required this.phoneNumber});
}
