#!/usr/bin/env python3
"""
Script pour corriger l'échappement des apostrophes dans le fichier service_service.dart
"""

import re

def fix_apostrophes():
    """Corrige l'échappement des apostrophes dans le fichier service_service.dart"""
    try:
        with open('/Users/macbook/Desktop/fibaya_mina/lib/prestataire_app/services/service_service.dart', 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Remplacer les apostrophes mal échappées
        # Pattern: 'text\'text' -> "text'text"
        content = re.sub(r"'([^']*)\\'([^']*)'", r'"\1\'\2"', content)
        
        # Pattern: 'text\' -> "text'"
        content = re.sub(r"'([^']*)\\'", r'"\1\'"', content)
        
        # Pattern: \'text' -> "'text"
        content = re.sub(r"\\'([^']*)'", r'"\'\1"', content)
        
        # Sauvegarder le fichier corrigé
        with open('/Users/macbook/Desktop/fibaya_mina/lib/prestataire_app/services/service_service.dart', 'w', encoding='utf-8') as f:
            f.write(content)
        
        print("✅ Apostrophes corrigées dans service_service.dart")
        
    except Exception as e:
        print(f"Erreur lors de la correction: {e}")

if __name__ == "__main__":
    fix_apostrophes()
