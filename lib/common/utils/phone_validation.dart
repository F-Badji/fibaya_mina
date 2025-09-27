// Validation des numéros de téléphone par pays
class PhoneValidation {
  // Base de données des formats de numéros mobiles par pays
  static const Map<String, PhoneFormat> phoneFormats = {
    'Sénégal': PhoneFormat(
      countryCode: '+221',
      totalDigits: 9,
      mobilePrefixes: ['70', '75', '76', '77', '78'],
      example: '781234567',
    ),
    'France': PhoneFormat(
      countryCode: '+33',
      totalDigits: 10,
      mobilePrefixes: ['06', '07'],
      example: '0612345678',
    ),
    'Mali': PhoneFormat(
      countryCode: '+223',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'Burkina Faso': PhoneFormat(
      countryCode: '+226',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79'],
      example: '60123456',
    ),
    'Côte d\'Ivoire': PhoneFormat(
      countryCode: '+225',
      totalDigits: 10,
      mobilePrefixes: ['07', '05', '01'],
      example: '0712345678',
    ),
    'Guinée': PhoneFormat(
      countryCode: '+224',
      totalDigits: 9,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69'],
      example: '601234567',
    ),
    'Gambie': PhoneFormat(
      countryCode: '+220',
      totalDigits: 7,
      mobilePrefixes: ['30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '3012345',
    ),
    'Guinée-Bissau': PhoneFormat(
      countryCode: '+245',
      totalDigits: 7,
      mobilePrefixes: ['50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '5012345',
    ),
    'Cap-Vert': PhoneFormat(
      countryCode: '+238',
      totalDigits: 7,
      mobilePrefixes: ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '9012345',
    ),
    'Mauritanie': PhoneFormat(
      countryCode: '+222',
      totalDigits: 8,
      mobilePrefixes: ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '20123456',
    ),
    'Niger': PhoneFormat(
      countryCode: '+227',
      totalDigits: 8,
      mobilePrefixes: ['80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '80123456',
    ),
    'Tchad': PhoneFormat(
      countryCode: '+235',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'Cameroun': PhoneFormat(
      countryCode: '+237',
      totalDigits: 9,
      mobilePrefixes: ['65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '651234567',
    ),
    'Gabon': PhoneFormat(
      countryCode: '+241',
      totalDigits: 8,
      mobilePrefixes: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '01123456',
    ),
    'Congo': PhoneFormat(
      countryCode: '+242',
      totalDigits: 9,
      mobilePrefixes: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '011234567',
    ),
    'République démocratique du Congo': PhoneFormat(
      countryCode: '+243',
      totalDigits: 9,
      mobilePrefixes: ['80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '801234567',
    ),
    'Centrafrique': PhoneFormat(
      countryCode: '+236',
      totalDigits: 8,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '70123456',
    ),
    'Togo': PhoneFormat(
      countryCode: '+228',
      totalDigits: 8,
      mobilePrefixes: ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '90123456',
    ),
    'Bénin': PhoneFormat(
      countryCode: '+229',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'Nigeria': PhoneFormat(
      countryCode: '+234',
      totalDigits: 10,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '7012345678',
    ),
    'Ghana': PhoneFormat(
      countryCode: '+233',
      totalDigits: 9,
      mobilePrefixes: ['20', '24', '26', '27', '28', '50', '54', '55', '56', '57', '59'],
      example: '201234567',
    ),
    'Liberia': PhoneFormat(
      countryCode: '+231',
      totalDigits: 8,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '70123456',
    ),
    'Sierra Leone': PhoneFormat(
      countryCode: '+232',
      totalDigits: 8,
      mobilePrefixes: ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '20123456',
    ),
    'Maroc': PhoneFormat(
      countryCode: '+212',
      totalDigits: 9,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '601234567',
    ),
    'Algérie': PhoneFormat(
      countryCode: '+213',
      totalDigits: 9,
      mobilePrefixes: ['5', '6', '7', '9'],
      example: '501234567',
    ),
    'Tunisie': PhoneFormat(
      countryCode: '+216',
      totalDigits: 8,
      mobilePrefixes: ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '20123456',
    ),
    'Égypte': PhoneFormat(
      countryCode: '+20',
      totalDigits: 10,
      mobilePrefixes: ['10', '11', '12', '15'],
      example: '1012345678',
    ),
    'Afrique du Sud': PhoneFormat(
      countryCode: '+27',
      totalDigits: 9,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '601234567',
    ),
    'Kenya': PhoneFormat(
      countryCode: '+254',
      totalDigits: 9,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '701234567',
    ),
    'Éthiopie': PhoneFormat(
      countryCode: '+251',
      totalDigits: 9,
      mobilePrefixes: ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '901234567',
    ),
    'Ouganda': PhoneFormat(
      countryCode: '+256',
      totalDigits: 9,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '701234567',
    ),
    'Tanzanie': PhoneFormat(
      countryCode: '+255',
      totalDigits: 9,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '601234567',
    ),
    'Rwanda': PhoneFormat(
      countryCode: '+250',
      totalDigits: 9,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '701234567',
    ),
    'Burundi': PhoneFormat(
      countryCode: '+257',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'Madagascar': PhoneFormat(
      countryCode: '+261',
      totalDigits: 9,
      mobilePrefixes: ['30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '301234567',
    ),
    'Maurice': PhoneFormat(
      countryCode: '+230',
      totalDigits: 8,
      mobilePrefixes: ['50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '50123456',
    ),
    'Seychelles': PhoneFormat(
      countryCode: '+248',
      totalDigits: 7,
      mobilePrefixes: ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '2012345',
    ),
    'Comores': PhoneFormat(
      countryCode: '+269',
      totalDigits: 7,
      mobilePrefixes: ['30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '3012345',
    ),
    'Djibouti': PhoneFormat(
      countryCode: '+253',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'Somalie': PhoneFormat(
      countryCode: '+252',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'Soudan': PhoneFormat(
      countryCode: '+249',
      totalDigits: 9,
      mobilePrefixes: ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '901234567',
    ),
    'Soudan du Sud': PhoneFormat(
      countryCode: '+211',
      totalDigits: 9,
      mobilePrefixes: ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '901234567',
    ),
    'Érythrée': PhoneFormat(
      countryCode: '+291',
      totalDigits: 7,
      mobilePrefixes: ['10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '1012345',
    ),
    'Zimbabwe': PhoneFormat(
      countryCode: '+263',
      totalDigits: 9,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '701234567',
    ),
    'Zambie': PhoneFormat(
      countryCode: '+260',
      totalDigits: 9,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '701234567',
    ),
    'Botswana': PhoneFormat(
      countryCode: '+267',
      totalDigits: 8,
      mobilePrefixes: ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '70123456',
    ),
    'Namibie': PhoneFormat(
      countryCode: '+264',
      totalDigits: 9,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '601234567',
    ),
    'Angola': PhoneFormat(
      countryCode: '+244',
      totalDigits: 9,
      mobilePrefixes: ['9'],
      example: '901234567',
    ),
    'Mozambique': PhoneFormat(
      countryCode: '+258',
      totalDigits: 9,
      mobilePrefixes: ['80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '801234567',
    ),
    'Malawi': PhoneFormat(
      countryCode: '+265',
      totalDigits: 9,
      mobilePrefixes: ['80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '801234567',
    ),
    'Lesotho': PhoneFormat(
      countryCode: '+266',
      totalDigits: 8,
      mobilePrefixes: ['50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '50123456',
    ),
    'Eswatini': PhoneFormat(
      countryCode: '+268',
      totalDigits: 8,
      mobilePrefixes: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '60123456',
    ),
    'São Tomé-et-Príncipe': PhoneFormat(
      countryCode: '+239',
      totalDigits: 7,
      mobilePrefixes: ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '9012345',
    ),
    'Guinée équatoriale': PhoneFormat(
      countryCode: '+240',
      totalDigits: 9,
      mobilePrefixes: ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99'],
      example: '201234567',
    ),
    'Albanie': PhoneFormat(
      countryCode: '+355',
      totalDigits: 9,
      mobilePrefixes: ['6'],
      example: '601234567',
    ),
    'Andorre': PhoneFormat(
      countryCode: '+376',
      totalDigits: 6,
      mobilePrefixes: ['3', '4', '6'],
      example: '301234',
    ),
    'Argentine': PhoneFormat(
      countryCode: '+54',
      totalDigits: 10,
      mobilePrefixes: ['9'],
      example: '9012345678',
    ),
    'Afghanistan': PhoneFormat(
      countryCode: '+93',
      totalDigits: 9,
      mobilePrefixes: ['7'],
      example: '701234567',
    ),
    'Arabie saoudite': PhoneFormat(
      countryCode: '+966',
      totalDigits: 9,
      mobilePrefixes: ['5'],
      example: '501234567',
    ),
    'Australie': PhoneFormat(
      countryCode: '+61',
      totalDigits: 9,
      mobilePrefixes: ['1', '4'],
      example: '401234567',
    ),
    'Autriche': PhoneFormat(
      countryCode: '+43',
      totalDigits: 10,
      mobilePrefixes: ['6'],
      example: '6012345678',
    ),
    'Allemagne': PhoneFormat(
      countryCode: '+49',
      totalDigits: 11,
      mobilePrefixes: ['15', '16', '17'],
      example: '15123456789',
    ),
    'États-Unis': PhoneFormat(
      countryCode: '+1',
      totalDigits: 10,
      mobilePrefixes: ['2', '3', '4', '5', '6', '7', '8', '9'],
      example: '2012345678',
    ),
    'Canada': PhoneFormat(
      countryCode: '+1',
      totalDigits: 10,
      mobilePrefixes: ['2', '3', '4', '5', '6', '7', '8', '9'],
      example: '2012345678',
    ),
    'Brésil': PhoneFormat(
      countryCode: '+55',
      totalDigits: 11,
      mobilePrefixes: ['9'],
      example: '90123456789',
    ),
    'Chine': PhoneFormat(
      countryCode: '+86',
      totalDigits: 11,
      mobilePrefixes: ['1'],
      example: '10123456789',
    ),
    'Japon': PhoneFormat(
      countryCode: '+81',
      totalDigits: 11,
      mobilePrefixes: ['7', '8', '9'],
      example: '70123456789',
    ),
    'Inde': PhoneFormat(
      countryCode: '+91',
      totalDigits: 10,
      mobilePrefixes: ['6', '7', '8', '9'],
      example: '6012345678',
    ),
    'Royaume-Uni': PhoneFormat(
      countryCode: '+44',
      totalDigits: 10,
      mobilePrefixes: ['7'],
      example: '7012345678',
    ),
    'Italie': PhoneFormat(
      countryCode: '+39',
      totalDigits: 10,
      mobilePrefixes: ['3'],
      example: '3012345678',
    ),
    'Espagne': PhoneFormat(
      countryCode: '+34',
      totalDigits: 9,
      mobilePrefixes: ['6', '7'],
      example: '601234567',
    ),
    'Belgique': PhoneFormat(
      countryCode: '+32',
      totalDigits: 9,
      mobilePrefixes: ['4'],
      example: '401234567',
    ),
    'Suisse': PhoneFormat(
      countryCode: '+41',
      totalDigits: 9,
      mobilePrefixes: ['7'],
      example: '701234567',
    ),
    'Pays-Bas': PhoneFormat(
      countryCode: '+31',
      totalDigits: 9,
      mobilePrefixes: ['6'],
      example: '601234567',
    ),
    'Suède': PhoneFormat(
      countryCode: '+46',
      totalDigits: 9,
      mobilePrefixes: ['7'],
      example: '701234567',
    ),
    'Norvège': PhoneFormat(
      countryCode: '+47',
      totalDigits: 8,
      mobilePrefixes: ['4', '9'],
      example: '40123456',
    ),
    'Danemark': PhoneFormat(
      countryCode: '+45',
      totalDigits: 8,
      mobilePrefixes: ['2', '3', '4', '5', '6', '7', '8', '9'],
      example: '20123456',
    ),
    'Finlande': PhoneFormat(
      countryCode: '+358',
      totalDigits: 9,
      mobilePrefixes: ['4', '5'],
      example: '401234567',
    ),
    'Pologne': PhoneFormat(
      countryCode: '+48',
      totalDigits: 9,
      mobilePrefixes: ['5', '6', '7', '8', '9'],
      example: '501234567',
    ),
    'République tchèque': PhoneFormat(
      countryCode: '+420',
      totalDigits: 9,
      mobilePrefixes: ['6', '7'],
      example: '601234567',
    ),
    'Hongrie': PhoneFormat(
      countryCode: '+36',
      totalDigits: 9,
      mobilePrefixes: ['2', '3', '4', '5', '6', '7', '8', '9'],
      example: '201234567',
    ),
    'Roumanie': PhoneFormat(
      countryCode: '+40',
      totalDigits: 9,
      mobilePrefixes: ['7'],
      example: '701234567',
    ),
    'Bulgarie': PhoneFormat(
      countryCode: '+359',
      totalDigits: 9,
      mobilePrefixes: ['8', '9'],
      example: '801234567',
    ),
    'Grèce': PhoneFormat(
      countryCode: '+30',
      totalDigits: 10,
      mobilePrefixes: ['6'],
      example: '6012345678',
    ),
    'Portugal': PhoneFormat(
      countryCode: '+351',
      totalDigits: 9,
      mobilePrefixes: ['9'],
      example: '901234567',
    ),
    'Turquie': PhoneFormat(
      countryCode: '+90',
      totalDigits: 10,
      mobilePrefixes: ['5'],
      example: '5012345678',
    ),
    'Russie': PhoneFormat(
      countryCode: '+7',
      totalDigits: 10,
      mobilePrefixes: ['9'],
      example: '9012345678',
    ),
    'Ukraine': PhoneFormat(
      countryCode: '+380',
      totalDigits: 9,
      mobilePrefixes: ['5', '6', '7', '8', '9'],
      example: '501234567',
    ),
    'Israël': PhoneFormat(
      countryCode: '+972',
      totalDigits: 9,
      mobilePrefixes: ['5'],
      example: '501234567',
    ),
    'Émirats arabes unis': PhoneFormat(
      countryCode: '+971',
      totalDigits: 9,
      mobilePrefixes: ['5'],
      example: '501234567',
    ),
    'Qatar': PhoneFormat(
      countryCode: '+974',
      totalDigits: 8,
      mobilePrefixes: ['3', '5', '6', '7'],
      example: '30123456',
    ),
    'Koweït': PhoneFormat(
      countryCode: '+965',
      totalDigits: 8,
      mobilePrefixes: ['5', '6', '9'],
      example: '50123456',
    ),
    'Bahreïn': PhoneFormat(
      countryCode: '+973',
      totalDigits: 8,
      mobilePrefixes: ['3', '6', '7'],
      example: '30123456',
    ),
    'Oman': PhoneFormat(
      countryCode: '+968',
      totalDigits: 8,
      mobilePrefixes: ['7', '9'],
      example: '70123456',
    ),
    'Jordanie': PhoneFormat(
      countryCode: '+962',
      totalDigits: 9,
      mobilePrefixes: ['7'],
      example: '701234567',
    ),
    'Liban': PhoneFormat(
      countryCode: '+961',
      totalDigits: 8,
      mobilePrefixes: ['3', '7', '8', '9'],
      example: '30123456',
    ),
    'Irak': PhoneFormat(
      countryCode: '+964',
      totalDigits: 10,
      mobilePrefixes: ['7'],
      example: '7012345678',
    ),
    'Iran': PhoneFormat(
      countryCode: '+98',
      totalDigits: 10,
      mobilePrefixes: ['9'],
      example: '9012345678',
    ),
    'Pakistan': PhoneFormat(
      countryCode: '+92',
      totalDigits: 10,
      mobilePrefixes: ['3'],
      example: '3012345678',
    ),
    'Bangladesh': PhoneFormat(
      countryCode: '+880',
      totalDigits: 10,
      mobilePrefixes: ['1'],
      example: '1012345678',
    ),
    'Sri Lanka': PhoneFormat(
      countryCode: '+94',
      totalDigits: 9,
      mobilePrefixes: ['7'],
      example: '701234567',
    ),
    'Népal': PhoneFormat(
      countryCode: '+977',
      totalDigits: 10,
      mobilePrefixes: ['9'],
      example: '9012345678',
    ),
    'Bhoutan': PhoneFormat(
      countryCode: '+975',
      totalDigits: 8,
      mobilePrefixes: ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
      example: '10123456',
    ),
    'Maldives': PhoneFormat(
      countryCode: '+960',
      totalDigits: 7,
      mobilePrefixes: ['7', '9'],
      example: '7012345',
    ),
    'Thaïlande': PhoneFormat(
      countryCode: '+66',
      totalDigits: 9,
      mobilePrefixes: ['6', '8', '9'],
      example: '601234567',
    ),
    'Vietnam': PhoneFormat(
      countryCode: '+84',
      totalDigits: 9,
      mobilePrefixes: ['3', '5', '7', '8', '9'],
      example: '301234567',
    ),
    'Cambodge': PhoneFormat(
      countryCode: '+855',
      totalDigits: 9,
      mobilePrefixes: ['1', '6', '7', '8', '9'],
      example: '101234567',
    ),
    'Laos': PhoneFormat(
      countryCode: '+856',
      totalDigits: 8,
      mobilePrefixes: ['2', '3', '4', '5', '6', '7', '8', '9'],
      example: '20123456',
    ),
    'Myanmar': PhoneFormat(
      countryCode: '+95',
      totalDigits: 9,
      mobilePrefixes: ['9'],
      example: '901234567',
    ),
    'Malaisie': PhoneFormat(
      countryCode: '+60',
      totalDigits: 9,
      mobilePrefixes: ['1'],
      example: '101234567',
    ),
    'Singapour': PhoneFormat(
      countryCode: '+65',
      totalDigits: 8,
      mobilePrefixes: ['8', '9'],
      example: '80123456',
    ),
    'Indonésie': PhoneFormat(
      countryCode: '+62',
      totalDigits: 10,
      mobilePrefixes: ['8'],
      example: '8012345678',
    ),
    'Philippines': PhoneFormat(
      countryCode: '+63',
      totalDigits: 10,
      mobilePrefixes: ['9'],
      example: '9012345678',
    ),
    'Corée du Sud': PhoneFormat(
      countryCode: '+82',
      totalDigits: 10,
      mobilePrefixes: ['1'],
      example: '1012345678',
    ),
    'Corée du Nord': PhoneFormat(
      countryCode: '+850',
      totalDigits: 8,
      mobilePrefixes: ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
      example: '10123456',
    ),
    'Mongolie': PhoneFormat(
      countryCode: '+976',
      totalDigits: 8,
      mobilePrefixes: ['8', '9'],
      example: '80123456',
    ),
    'Kazakhstan': PhoneFormat(
      countryCode: '+7',
      totalDigits: 10,
      mobilePrefixes: ['7'],
      example: '7012345678',
    ),
    'Ouzbékistan': PhoneFormat(
      countryCode: '+998',
      totalDigits: 9,
      mobilePrefixes: ['9'],
      example: '901234567',
    ),
    'Kirghizistan': PhoneFormat(
      countryCode: '+996',
      totalDigits: 9,
      mobilePrefixes: ['5', '7', '9'],
      example: '501234567',
    ),
    'Tadjikistan': PhoneFormat(
      countryCode: '+992',
      totalDigits: 9,
      mobilePrefixes: ['9'],
      example: '901234567',
    ),
    'Turkménistan': PhoneFormat(
      countryCode: '+993',
      totalDigits: 8,
      mobilePrefixes: ['6', '7', '8', '9'],
      example: '60123456',
    ),
  };

  // Méthode de validation principale
  static String? validatePhoneNumber(String phoneNumber, String countryName) {
    if (phoneNumber.isEmpty) {
      return 'Numéro invalide';
    }

    // Nettoyer le numéro (enlever espaces, tirets, etc.)
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanNumber.isEmpty) {
      return 'Numéro invalide';
    }

    // Vérifier si le pays existe dans notre base de données
    final format = phoneFormats[countryName];
    if (format == null) {
      return 'Numéro invalide';
    }

    // Vérifier la longueur
    if (cleanNumber.length != format.totalDigits) {
      return 'Numéro invalide';
    }

    // Vérifier le préfixe mobile
    bool validPrefix = false;
    for (String prefix in format.mobilePrefixes) {
      if (cleanNumber.startsWith(prefix)) {
        validPrefix = true;
        break;
      }
    }

    if (!validPrefix) {
      return 'Numéro invalide';
    }

    return null; // Numéro valide
  }

  // Obtenir le format d'un pays
  static PhoneFormat? getCountryFormat(String countryName) {
    return phoneFormats[countryName];
  }

  // Obtenir un exemple de numéro pour un pays
  static String? getExampleNumber(String countryName) {
    final format = phoneFormats[countryName];
    return format?.example;
  }
}

// Classe pour définir le format d'un numéro de téléphone
class PhoneFormat {
  final String countryCode;
  final int totalDigits;
  final List<String> mobilePrefixes;
  final String example;

  const PhoneFormat({
    required this.countryCode,
    required this.totalDigits,
    required this.mobilePrefixes,
    required this.example,
  });
}
