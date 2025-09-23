import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(int)? onUnreadCountChanged;
  
  const NotificationsScreen({super.key, this.onUnreadCountChanged});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Nouvelle commande reçue',
      'message': 'Moussa Diallo a accepté votre demande de service plomberie',
      'time': 'Il y a 5 min',
      'type': 'order',
      'isRead': false,
      'icon': Icons.shopping_cart,
      'color': AppTheme.primaryGreen,
    },
    {
      'id': '2',
      'title': 'Prestataire en route',
      'message': 'Fatima Zohra est en route vers votre domicile',
      'time': 'Il y a 15 min',
      'type': 'tracking',
      'isRead': false,
      'icon': Icons.directions_car,
      'color': Colors.orange,
    },
    {
      'id': '3',
      'title': 'Service terminé',
      'message': 'Votre service avec Aliou Diop a été terminé. N\'oubliez pas de le noter !',
      'time': 'Il y a 1h',
      'type': 'completed',
      'isRead': true,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'id': '4',
      'title': 'Paiement confirmé',
      'message': 'Votre paiement de 15 000 FCFA a été confirmé',
      'time': 'Il y a 2h',
      'type': 'payment',
      'isRead': true,
      'icon': Icons.payment,
      'color': Colors.blue,
    },
    {
      'id': '5',
      'title': 'Promotion spéciale',
      'message': 'Réduction de 20% sur tous les services de coiffure ce weekend !',
      'time': 'Il y a 1 jour',
      'type': 'promotion',
      'isRead': true,
      'icon': Icons.local_offer,
      'color': Colors.purple,
    },
    {
      'id': '6',
      'title': 'Mise à jour disponible',
      'message': 'Une nouvelle version de FIBAYA est disponible avec de nouvelles fonctionnalités',
      'time': 'Il y a 2 jours',
      'type': 'system',
      'isRead': true,
      'icon': Icons.system_update,
      'color': Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Tout marquer comme lu',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // En-tête avec statistiques
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Non lues',
                          _notifications.where((n) => !n['isRead']).length.toString(),
                          AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Total',
                          _notifications.length.toString(),
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Liste des notifications
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0x1A065b32), // AppTheme.primaryGreen.withOpacity(0.1)
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 60,
              color: Color(0x80065b32), // AppTheme.primaryGreen.withOpacity(0.5)
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous recevrez des notifications ici\nquand vous aurez de nouvelles activités',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color == AppTheme.primaryGreen 
            ? const Color(0x1A065b32) // AppTheme.primaryGreen.withOpacity(0.1)
            : const Color(0x1A9E9E9E), // Colors.grey.withOpacity(0.1)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color == AppTheme.primaryGreen 
              ? const Color(0x4D065b32) // AppTheme.primaryGreen.withOpacity(0.3)
              : const Color(0x4D9E9E9E), // Colors.grey.withOpacity(0.3)
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] 
            ? Colors.white 
            : const Color(0x0D065b32), // AppTheme.primaryGreen.withOpacity(0.05)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isRead'] 
              ? Colors.grey[200]! 
              : const Color(0x33065b32), // AppTheme.primaryGreen.withOpacity(0.2)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(notification['color']),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  notification['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!notification['isRead']) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey[400],
          ),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          onSelected: (value) => _handleNotificationAction(value, notification),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'mark_read',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      notification['isRead'] ? Icons.mark_email_unread : Icons.mark_email_read,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      notification['isRead'] ? 'Marquer non lu' : 'Marquer lu',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Supprimer',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () => _markAsRead(notification),
      ),
    );
  }

  Color _getIconBackgroundColor(Color iconColor) {
    if (iconColor == AppTheme.primaryGreen) {
      return const Color(0x1A065b32); // AppTheme.primaryGreen.withOpacity(0.1)
    } else if (iconColor == Colors.orange) {
      return const Color(0x1AFF9800); // Colors.orange.withOpacity(0.1)
    } else if (iconColor == Colors.green) {
      return const Color(0x1A4CAF50); // Colors.green.withOpacity(0.1)
    } else if (iconColor == Colors.blue) {
      return const Color(0x1A2196F3); // Colors.blue.withOpacity(0.1)
    } else if (iconColor == Colors.purple) {
      return const Color(0x1A9C27B0); // Colors.purple.withOpacity(0.1)
    } else {
      return const Color(0x1A9E9E9E); // Colors.grey.withOpacity(0.1)
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
    _notifyUnreadCountChanged();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    _notifyUnreadCountChanged();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Toutes les notifications ont été marquées comme lues'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleNotificationAction(String action, Map<String, dynamic> notification) {
    switch (action) {
      case 'mark_read':
        setState(() {
          notification['isRead'] = !notification['isRead'];
        });
        _notifyUnreadCountChanged();
        break;
      case 'delete':
        setState(() {
          _notifications.removeWhere((n) => n['id'] == notification['id']);
        });
        _notifyUnreadCountChanged();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification supprimée'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        break;
    }
  }

  void _notifyUnreadCountChanged() {
    if (widget.onUnreadCountChanged != null) {
      final unreadCount = _notifications.where((n) => !n['isRead']).length;
      widget.onUnreadCountChanged!(unreadCount);
    }
  }
}






