import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_models.dart';

class SettingsService {
  static const String _userSettingsKey = 'user_settings';
  static const String _notificationSettingsKey = 'notification_settings';
  static const String _trustedContactsKey = 'trusted_contacts';

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final userSettingsJson = prefs.getString(_userSettingsKey);
    final notificationSettingsJson = prefs.getString(_notificationSettingsKey);

    return AppSettings(
      userSettings: userSettingsJson != null
          ? UserSettings.fromJson(_parseJson(userSettingsJson))
          : UserSettings(),
      notificationSettings: notificationSettingsJson != null
          ? NotificationSettings.fromJson(_parseJson(notificationSettingsJson))
          : NotificationSettings(),
    );
  }

  Future<void> saveUserSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await loadSettings();

    switch (key) {
      case 'theme_mode':
        settings.userSettings.themeMode = value;
        break;
      case 'language':
        settings.userSettings.language = value;
        break;
      case 'profile_image':
        settings.userSettings.profileImage = value;
        break;
    }

    await prefs.setString(
      _userSettingsKey,
      settings.userSettings.toJson().toString(),
    );
  }

  Future<void> saveNotificationSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = await loadSettings();

    switch (key) {
      case 'all_notifications':
        settings.notificationSettings.allNotifications = value;
        break;
      case 'email_notifications':
        settings.notificationSettings.emailNotifications = value;
        break;
      case 'sms_notifications':
        settings.notificationSettings.smsNotifications = value;
        break;
      case 'push_notifications':
        settings.notificationSettings.pushNotifications = value;
        break;
    }

    await prefs.setString(
      _notificationSettingsKey,
      settings.notificationSettings.toJson().toString(),
    );
  }

  Future<List<TrustedContact>> loadTrustedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList(_trustedContactsKey) ?? [];

    return contactsJson
        .map((json) => TrustedContact.fromJson(_parseJson(json)))
        .toList();
  }

  Future<void> saveTrustedContacts(List<TrustedContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = contacts
        .map((contact) => contact.toJson().toString())
        .toList();
    await prefs.setStringList(_trustedContactsKey, contactsJson);
  }

  Future<void> addTrustedContact(TrustedContact contact) async {
    final contacts = await loadTrustedContacts();
    contacts.add(contact);
    await saveTrustedContacts(contacts);
  }

  Future<void> updateTrustedContact(int index, TrustedContact contact) async {
    final contacts = await loadTrustedContacts();
    if (index >= 0 && index < contacts.length) {
      contacts[index] = contact;
      await saveTrustedContacts(contacts);
    }
  }

  Future<void> deleteTrustedContact(int index) async {
    final contacts = await loadTrustedContacts();
    if (index >= 0 && index < contacts.length) {
      contacts.removeAt(index);
      await saveTrustedContacts(contacts);
    }
  }

  Future<void> clearAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userSettingsKey);
    await prefs.remove(_notificationSettingsKey);
    await prefs.remove(_trustedContactsKey);
  }

  Map<String, dynamic> _parseJson(String jsonString) {
    // Simple JSON parsing - in a real app, you'd use dart:convert
    // This is a simplified version for demonstration
    try {
      // For now, return empty map - implement proper JSON parsing as needed
      return {};
    } catch (e) {
      return {};
    }
  }
}
