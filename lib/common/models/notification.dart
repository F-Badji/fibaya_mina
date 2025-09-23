class NotificationModel {
  final String id;
  final String serviceType;
  final String providerName;
  final String status;
  final String estimatedArrival;
  final String address;
  final String time;
  final String date;
  final String avatarInitial;
  final bool isActive;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.serviceType,
    required this.providerName,
    required this.status,
    required this.estimatedArrival,
    required this.address,
    required this.time,
    required this.date,
    required this.avatarInitial,
    required this.isActive,
    required this.isRead,
  });
}

class NotificationData {
  static List<NotificationModel> get notifications => [
    const NotificationModel(
      id: '1',
      serviceType: 'Plomberie',
      providerName: 'Jean-Marc Dubois',
      status: 'En route',
      estimatedArrival: 'Arrivée dans 15 min',
      address: '12 Rue de la République, Paris',
      time: '10:38',
      date: '20 sept.',
      avatarInitial: 'J',
      isActive: true,
      isRead: false,
    ),
    const NotificationModel(
      id: '2',
      serviceType: 'Menuiserie',
      providerName: 'Sophie Martin',
      status: 'Arrivé',
      estimatedArrival: '',
      address: '45 Avenue des Champs, Lyon',
      time: '10:23',
      date: '20 sept.',
      avatarInitial: 'S',
      isActive: true,
      isRead: false,
    ),
    const NotificationModel(
      id: '3',
      serviceType: 'Vétérinaire',
      providerName: 'Dr. Marie Lefort',
      status: 'Annulé',
      estimatedArrival: '',
      address: 'Clinique Animalia',
      time: '05:53',
      date: '20 sept.',
      avatarInitial: 'D',
      isActive: false,
      isRead: false,
    ),
    const NotificationModel(
      id: '4',
      serviceType: 'Électricien',
      providerName: 'ElecPro Services',
      status: 'En route',
      estimatedArrival: 'Arrivée dans 20 min',
      address: '8 Boulevard Victor Hugo',
      time: '10:43',
      date: '20 sept.',
      avatarInitial: 'E',
      isActive: true,
      isRead: false,
    ),
    const NotificationModel(
      id: '6',
      serviceType: 'Jardinage',
      providerName: 'GreenThumb Services',
      status: 'En attente',
      estimatedArrival: 'En attente de confirmation',
      address: '22 Rue des Jardins, Nice',
      time: '14:30',
      date: '20 sept.',
      avatarInitial: 'G',
      isActive: true,
      isRead: false,
    ),
    const NotificationModel(
      id: '7',
      serviceType: 'Réparation',
      providerName: 'FixIt Pro',
      status: 'Terminé',
      estimatedArrival: '',
      address: '33 Avenue de la Paix, Toulouse',
      time: '16:45',
      date: '20 sept.',
      avatarInitial: 'F',
      isActive: true,
      isRead: true,
    ),
    const NotificationModel(
      id: '8',
      serviceType: 'Plomberie',
      providerName: 'AquaFix Services',
      status: 'En cours',
      estimatedArrival: 'Travaux en cours',
      address: '55 Rue de la Fontaine, Bordeaux',
      time: '13:20',
      date: '20 sept.',
      avatarInitial: 'A',
      isActive: true,
      isRead: false,
    ),
  ];
}
