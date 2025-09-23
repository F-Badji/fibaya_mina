import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _activeTab = 'pending';

  final List<Map<String, dynamic>> pendingOrders = [
    {
      'id': '1',
      'clientName': 'Marie Dubois',
      'service': 'Réparation plomberie urgente',
      'location': '15 Rue de la Paix, 75001 Paris',
      'distance': '2.5 km',
      'duration': '12 min',
      'price': 85,
      'status': 'pending',
      'urgent': true,
    },
    {
      'id': '2',
      'clientName': 'Pierre Leclerc',
      'service': 'Installation robinet',
      'location': '22 Avenue Montaigne, 75008 Paris',
      'distance': '4.1 km',
      'duration': '18 min',
      'price': 65,
      'status': 'pending',
    },
    {
      'id': '3',
      'clientName': 'Anne Moreau',
      'service': 'Débouchage canalisation',
      'location': '8 Rue Saint-Honoré, 75001 Paris',
      'distance': '1.8 km',
      'duration': '8 min',
      'price': 75,
      'status': 'pending',
      'urgent': true,
    },
  ];

  final List<Map<String, dynamic>> acceptedOrders = [
    {
      'id': '4',
      'clientName': 'Jean Martin',
      'service': 'Réparation fuite salle de bain',
      'location': '45 Avenue des Champs-Élysées',
      'distance': '1.8 km',
      'duration': '8 min',
      'price': 95,
      'status': 'accepted',
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      'id': '5',
      'clientName': 'Sophie Laurent',
      'service': 'Installation chauffe-eau',
      'location': '12 Boulevard Voltaire, 75011 Paris',
      'distance': '3.2 km',
      'duration': '15 min',
      'price': 120,
      'status': 'completed',
    },
    {
      'id': '6',
      'clientName': 'Michel Roux',
      'service': 'Réparation robinet cuisine',
      'location': '67 Rue de Rivoli, 75004 Paris',
      'distance': '2.9 km',
      'duration': '14 min',
      'price': 55,
      'status': 'completed',
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentOrders {
    switch (_activeTab) {
      case 'pending':
        return pendingOrders;
      case 'accepted':
        return acceptedOrders;
      case 'completed':
        return completedOrders;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF065b32),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mes Commandes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gérez vos demandes de service',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildTab(
                              'pending',
                              'En attente',
                              pendingOrders.length,
                            ),
                            _buildTab(
                              'accepted',
                              'Acceptées',
                              acceptedOrders.length,
                            ),
                            _buildTab(
                              'completed',
                              'Terminées',
                              completedOrders.length,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Orders List
                      Expanded(
                        child: _currentOrders.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                itemCount: _currentOrders.length,
                                itemBuilder: (context, index) {
                                  final order = _currentOrders[index];
                                  return _buildOrderCard(order);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String tabId, String label, int count) {
    final isSelected = _activeTab == tabId;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = tabId;
          });
          HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF065b32)
                      : Colors.grey[600],
                ),
              ),
              if (count > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF065b32)
                        : Colors.orange[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = '';
    String subtitle = '';

    switch (_activeTab) {
      case 'pending':
        message = 'Aucune nouvelle commande';
        subtitle = 'Les nouvelles commandes apparaîtront ici';
        break;
      case 'accepted':
        message = 'Aucune commande acceptée';
        subtitle = 'Vos commandes acceptées apparaîtront ici';
        break;
      case 'completed':
        message = 'Aucune commande terminée';
        subtitle = 'Vos commandes terminées apparaîtront ici';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final urgent = order['urgent'] as bool? ?? false;

    Color statusColor = Colors.grey;
    String statusText = 'Inconnu';

    switch (status) {
      case 'pending':
        statusColor = Colors.orange[800]!;
        statusText = 'En attente';
        break;
      case 'accepted':
        statusColor = Colors.blue;
        statusText = 'Accepté';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Terminé';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order['clientName'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (urgent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Urgent',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['service'] as String,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusText == 'En attente'
                      ? Colors.orange[800]!
                      : statusText == 'Accepté'
                      ? const Color(0xFF27AE60)
                      : statusText == 'Terminé'
                      ? const Color(0xFF065B32)
                      : statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusText == 'En attente'
                        ? Colors.white
                        : statusText == 'Accepté'
                        ? Colors.white
                        : statusText == 'Terminé'
                        ? Colors.white
                        : statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Details
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${order['location']} • ${order['distance']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                order['duration'] as String,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Spacer(),
              Text(
                '${order['price']} F CFA',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF065b32),
                ),
              ),
            ],
          ),

          // Actions
          if (status == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showActionDialog(order, 'Refuser');
                    },
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Refuser'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showActionDialog(order, 'Accepter');
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Accepter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF065b32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showSnackBar(
                        'Appel vers ${order['clientName']}',
                        Colors.blue,
                      );
                    },
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Appeler'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showSnackBar(
                        'Message à ${order['clientName']}',
                        Colors.blue,
                      );
                    },
                    icon: const Icon(Icons.message, size: 16),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (status == 'accepted') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSnackBar(
                    'Navigation vers ${order['clientName']}',
                    Colors.green,
                  );
                },
                icon: const Icon(Icons.navigation, size: 16),
                label: const Text('Aller vers le client'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF065b32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showActionDialog(Map<String, dynamic> order, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$action la commande'),
        content: Text(
          'Voulez-vous $action.toLowerCase() cette commande de ${order['clientName']} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar(
                'Commande ${action.toLowerCase()}ée avec succès',
                Colors.green,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'Accepter'
                  ? const Color(0xFF065b32)
                  : Colors.red,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
