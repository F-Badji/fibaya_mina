class UserSettings {
  bool themeMode;
  String language;
  String? profileImage;

  UserSettings({
    this.themeMode = false,
    this.language = 'Français',
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'theme_mode': themeMode,
      'language': language,
      'profile_image': profileImage,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      themeMode: json['theme_mode'] ?? false,
      language: json['language'] ?? 'Français',
      profileImage: json['profile_image'],
    );
  }
}

class NotificationSettings {
  bool allNotifications;
  bool emailNotifications;
  bool smsNotifications;
  bool pushNotifications;

  NotificationSettings({
    this.allNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.pushNotifications = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'all_notifications': allNotifications,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'push_notifications': pushNotifications,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      allNotifications: json['all_notifications'] ?? true,
      emailNotifications: json['email_notifications'] ?? true,
      smsNotifications: json['sms_notifications'] ?? false,
      pushNotifications: json['push_notifications'] ?? true,
    );
  }
}

class AppSettings {
  final UserSettings userSettings;
  final NotificationSettings notificationSettings;

  AppSettings({required this.userSettings, required this.notificationSettings});

  Map<String, dynamic> toJson() {
    return {
      'user_settings': userSettings.toJson(),
      'notification_settings': notificationSettings.toJson(),
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      userSettings: UserSettings.fromJson(json['user_settings'] ?? {}),
      notificationSettings: NotificationSettings.fromJson(
        json['notification_settings'] ?? {},
      ),
    );
  }
}

class TrustedContact {
  final String name;
  final String phone;
  final String avatar;
  final int color;

  TrustedContact({
    required this.name,
    required this.phone,
    required this.avatar,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'avatar': avatar, 'color': color};
  }

  factory TrustedContact.fromJson(Map<String, dynamic> json) {
    return TrustedContact(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '?',
      color: json['color'] ?? 0xFF000000,
    );
  }
}
