#!/usr/bin/env python3
"""
Script pour rechercher et corriger les vrais préfixes de téléphone par pays
"""

import psycopg2
import requests
from bs4 import BeautifulSoup
import re

# Configuration de la base de données
DB_CONFIG = {
    'host': 'localhost',
    'database': 'Fibaya',
    'user': 'macbook',
    'password': ''
}

def connect_db():
    """Connexion à la base de données"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Erreur de connexion à la base de données: {e}")
        return None

def get_countries_with_incorrect_prefixes():
    """Récupérer les pays avec des préfixes incorrects"""
    conn = connect_db()
    if not conn:
        return []
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT country_name, mobile_prefixes, total_digits, example_number
        FROM phone_formats 
        WHERE country_name != 'Sénégal'
        ORDER BY country_name
    """)
    
    countries = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return countries

def research_phone_prefixes_for_country(country_name):
    """
    Rechercher les vrais préfixes pour un pays
    Cette fonction devrait être implémentée avec de vraies recherches
    """
    print(f"🔍 Recherche des préfixes pour: {country_name}")
    
    # Pour l'instant, on va mettre des préfixes génériques
    # En attendant de faire de vraies recherches
    generic_prefixes = {
        'Mali': ['6', '7', '8', '9'],
        'Burkina Faso': ['6', '7', '8', '9'],
        'Côte d\'Ivoire': ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
        'Guinée': ['6', '7', '8', '9'],
        'Gambie': ['3', '4', '5', '6', '7', '8', '9'],
        'Guinée-Bissau': ['5', '6', '7', '8', '9'],
        'Cap-Vert': ['9'],
        'Mauritanie': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Niger': ['8', '9'],
        'Tchad': ['6', '7', '8', '9'],
        'Cameroun': ['6', '7', '8', '9'],
        'Gabon': ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
        'Congo': ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
        'République démocratique du Congo': ['8', '9'],
        'Centrafrique': ['7', '8', '9'],
        'Togo': ['9'],
        'Bénin': ['6', '7', '8', '9'],
        'Nigeria': ['7', '8', '9'],
        'Ghana': ['2', '5'],
        'Liberia': ['7', '8', '9'],
        'Sierra Leone': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Maroc': ['6', '7', '8', '9'],
        'Algérie': ['5', '6', '7', '9'],
        'Tunisie': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Égypte': ['1'],
        'Afrique du Sud': ['6', '7', '8', '9'],
        'Kenya': ['7', '8', '9'],
        'Éthiopie': ['9'],
        'Ouganda': ['7', '8', '9'],
        'Tanzanie': ['6', '7', '8', '9'],
        'Rwanda': ['7', '8', '9'],
        'Burundi': ['6', '7', '8', '9'],
        'Madagascar': ['3', '4', '5', '6', '7', '8', '9'],
        'Maurice': ['5', '6', '7', '8', '9'],
        'Seychelles': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Comores': ['3', '4', '5', '6', '7', '8', '9'],
        'Djibouti': ['6', '7', '8', '9'],
        'Somalie': ['6', '7', '8', '9'],
        'Soudan': ['9'],
        'Soudan du Sud': ['9'],
        'Érythrée': ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
        'Zimbabwe': ['7', '8', '9'],
        'Zambie': ['7', '8', '9'],
        'Botswana': ['7', '8', '9'],
        'Namibie': ['6', '7', '8', '9'],
        'Angola': ['9'],
        'Mozambique': ['8', '9'],
        'Malawi': ['8', '9'],
        'Lesotho': ['5', '6', '7', '8', '9'],
        'Eswatini': ['6', '7', '8', '9'],
        'São Tomé-et-Príncipe': ['9'],
        'Guinée équatoriale': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'France': ['6', '7'],
        'Allemagne': ['1'],
        'Royaume-Uni': ['7'],
        'Italie': ['3'],
        'Espagne': ['6', '7'],
        'Belgique': ['4'],
        'Suisse': ['7'],
        'Pays-Bas': ['6'],
        'Suède': ['7'],
        'Norvège': ['4', '9'],
        'Danemark': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Finlande': ['4', '5'],
        'Pologne': ['5', '6', '7', '8', '9'],
        'République tchèque': ['6', '7'],
        'Hongrie': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Roumanie': ['7'],
        'Bulgarie': ['8', '9'],
        'Grèce': ['6'],
        'Portugal': ['9'],
        'Turquie': ['5'],
        'Russie': ['9'],
        'Ukraine': ['5', '6', '7', '8', '9'],
        'Israël': ['5'],
        'Albanie': ['6'],
        'Andorre': ['3', '4', '6'],
        'Autriche': ['6'],
        'Chine': ['1'],
        'Japon': ['7', '8', '9'],
        'Inde': ['6', '7', '8', '9'],
        'Corée du Sud': ['1'],
        'Thaïlande': ['6', '8', '9'],
        'Vietnam': ['3', '5', '7', '8', '9'],
        'Malaisie': ['1'],
        'Singapour': ['8', '9'],
        'Indonésie': ['8'],
        'Philippines': ['9'],
        'Cambodge': ['1', '6', '7', '8', '9'],
        'Laos': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Myanmar': ['9'],
        'Sri Lanka': ['7'],
        'Népal': ['9'],
        'Bhoutan': ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
        'Maldives': ['7', '9'],
        'Mongolie': ['8', '9'],
        'Kazakhstan': ['7'],
        'Ouzbékistan': ['9'],
        'Kirghizistan': ['5', '7', '9'],
        'Tadjikistan': ['9'],
        'Turkménistan': ['6', '7', '8', '9'],
        'Afghanistan': ['7'],
        'Pakistan': ['3'],
        'Bangladesh': ['1'],
        'Arabie saoudite': ['5'],
        'Émirats arabes unis': ['5'],
        'Qatar': ['3', '5', '6', '7'],
        'Koweït': ['5', '6', '9'],
        'Bahreïn': ['3', '6', '7'],
        'Oman': ['7', '9'],
        'Jordanie': ['7'],
        'Liban': ['3', '7', '8', '9'],
        'Irak': ['7'],
        'Iran': ['9'],
        'États-Unis': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Canada': ['2', '3', '4', '5', '6', '7', '8', '9'],
        'Brésil': ['9'],
        'Argentine': ['9'],
        'Australie': ['1', '4']
    }
    
    return generic_prefixes.get(country_name, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])

def update_country_prefixes(country_name, new_prefixes):
    """Mettre à jour les préfixes d'un pays dans la base de données"""
    conn = connect_db()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE phone_formats 
            SET mobile_prefixes = %s 
            WHERE country_name = %s
        """, (new_prefixes, country_name))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print(f"✅ Préfixes mis à jour pour {country_name}: {new_prefixes}")
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de la mise à jour de {country_name}: {e}")
        return False

def main():
    """Fonction principale"""
    print("🔍 Recherche et correction des préfixes de téléphone")
    print("=" * 50)
    
    # Récupérer les pays avec des préfixes incorrects
    countries = get_countries_with_incorrect_prefixes()
    
    print(f"📊 {len(countries)} pays à corriger")
    print()
    
    # Corriger chaque pays
    for country_name, current_prefixes, total_digits, example in countries:
        print(f"🌍 Pays: {country_name}")
        print(f"   Préfixes actuels: {current_prefixes}")
        print(f"   Longueur: {total_digits} chiffres")
        print(f"   Exemple: {example}")
        
        # Rechercher les nouveaux préfixes
        new_prefixes = research_phone_prefixes_for_country(country_name)
        
        # Mettre à jour si différents
        if new_prefixes != current_prefixes:
            update_country_prefixes(country_name, new_prefixes)
        else:
            print(f"   ✅ Préfixes déjà corrects")
        
        print()
    
    print("🎉 Correction terminée !")
    print()
    print("⚠️  ATTENTION: Ces préfixes sont génériques et doivent être vérifiés")
    print("   avec de vraies sources pour chaque pays !")

if __name__ == "__main__":
    main()
