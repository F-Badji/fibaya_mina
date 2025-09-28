import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Search, ArrowLeft, Eye, Download, User, Phone, MapPin, Calendar, FileText, Users, Filter } from "lucide-react";
import axios from "axios";

interface Prestataire {
  id: number;
  nom: string;
  prenom: string;
  telephone: string;
  serviceType: string;
  typeService: string;
  experience: string;
  description: string;
  adresse: string;
  ville: string;
  codePostal: string;
  certifications: string;
  versionDocument: string;
  carteIdentiteRecto: string;
  carteIdentiteVerso: string;
  cv: string;
  diplome: string;
  imageProfil: string;
  statut: string;
  dateCreation: string;
  dateModification: string;
}

const PrestatairesAdmin = () => {
  const navigate = useNavigate();
  const [prestataires, setPrestataires] = useState<Prestataire[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedPrestataire, setSelectedPrestataire] = useState<Prestataire | null>(null);
  const [filterStatus, setFilterStatus] = useState<string>("all");

  useEffect(() => {
    fetchPrestataires();
  }, []);

  const fetchPrestataires = async () => {
    try {
      setLoading(true);
      const response = await axios.get('http://localhost:8081/api/prestataires/disponibles');
      setPrestataires(response.data);
    } catch (error) {
      console.error('Erreur lors du chargement des prestataires:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredPrestataires = prestataires.filter(prestataire => {
    const matchesSearch = prestataire.nom.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         prestataire.prenom.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         prestataire.serviceType.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesStatus = filterStatus === "all" || prestataire.statut === filterStatus;
    
    return matchesSearch && matchesStatus;
  });

  const getStatusBadge = (statut: string) => {
    switch (statut) {
      case 'DISPONIBLE':
        return <Badge className="bg-green-100 text-green-800 hover:bg-green-100">Disponible</Badge>;
      case 'OCCUPE':
        return <Badge variant="secondary">Occupé</Badge>;
      case 'HORS_LIGNE':
        return <Badge variant="outline">Hors ligne</Badge>;
      default:
        return <Badge variant="outline">{statut}</Badge>;
    }
  };

  const getVersionBadge = (version: string) => {
    switch (version) {
      case 'Pro':
        return <Badge className="bg-blue-100 text-blue-800 hover:bg-blue-100">Pro</Badge>;
      case 'Simple':
        return <Badge variant="secondary">Simple</Badge>;
      default:
        return <Badge variant="outline">{version}</Badge>;
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="bg-gradient-hero text-white relative overflow-hidden">
        <div className="relative z-10 p-4 pt-8">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-4">
              <Button 
                variant="ghost" 
                size="icon" 
                className="text-white hover:bg-white/20"
                onClick={() => navigate('/')}
              >
                <ArrowLeft className="h-5 w-5" />
              </Button>
              <div>
                <h1 className="text-2xl font-bold mb-1">Administration Prestataires</h1>
                <p className="text-white/80 text-sm">Gestion des prestataires de services</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-online rounded-full animate-pulse" />
              <span className="text-sm text-white/80">{prestataires.length} prestataires</span>
            </div>
          </div>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="p-4 bg-background sticky top-0 z-10 border-b">
        <div className="flex gap-2 mb-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Rechercher un prestataire..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10"
            />
          </div>
          <Button variant="outline" size="icon">
            <Filter className="h-4 w-4" />
          </Button>
        </div>
        
        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          <Badge
            variant={filterStatus === "all" ? "default" : "outline"}
            className={`cursor-pointer whitespace-nowrap transition-all hover:scale-105 ${
              filterStatus === "all" 
                ? "bg-gradient-primary text-white border-0" 
                : "hover:border-primary hover:text-primary"
            }`}
            onClick={() => setFilterStatus("all")}
          >
            Tous ({prestataires.length})
          </Badge>
          <Badge
            variant={filterStatus === "DISPONIBLE" ? "default" : "outline"}
            className={`cursor-pointer whitespace-nowrap transition-all hover:scale-105 ${
              filterStatus === "DISPONIBLE" 
                ? "bg-gradient-primary text-white border-0" 
                : "hover:border-primary hover:text-primary"
            }`}
            onClick={() => setFilterStatus("DISPONIBLE")}
          >
            Disponibles ({prestataires.filter(p => p.statut === "DISPONIBLE").length})
          </Badge>
          <Badge
            variant={filterStatus === "OCCUPE" ? "default" : "outline"}
            className={`cursor-pointer whitespace-nowrap transition-all hover:scale-105 ${
              filterStatus === "OCCUPE" 
                ? "bg-gradient-primary text-white border-0" 
                : "hover:border-primary hover:text-primary"
            }`}
            onClick={() => setFilterStatus("OCCUPE")}
          >
            Occupés ({prestataires.filter(p => p.statut === "OCCUPE").length})
          </Badge>
        </div>
      </div>

      {/* Stats Bar */}
      <div className="px-4 py-3 bg-muted/50">
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            {filteredPrestataires.length} prestataire(s) trouvé(s)
          </p>
          <div className="flex items-center gap-2">
            <Users className="h-4 w-4 text-success" />
            <span className="text-sm text-success font-medium">Administration active</span>
          </div>
        </div>
      </div>

      {/* Prestataires Grid */}
      <div className="p-4 pb-20">
        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
            <p className="mt-4 text-muted-foreground">Chargement des prestataires...</p>
          </div>
        ) : filteredPrestataires.length === 0 ? (
          <div className="text-center py-12">
            <div className="text-6xl mb-4">👥</div>
            <h3 className="text-lg font-semibold mb-2">Aucun prestataire trouvé</h3>
            <p className="text-muted-foreground">
              {searchTerm ? "Aucun prestataire ne correspond à votre recherche." : "Aucun prestataire n'est encore enregistré."}
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredPrestataires.map((prestataire, index) => (
              <div 
                key={prestataire.id} 
                className="animate-slide-up"
                style={{ animationDelay: `${index * 0.1}s` }}
              >
                <Card className="hover:shadow-lg transition-all hover:scale-105">
                  <CardHeader>
                    <div className="flex items-center space-x-4">
                      <Avatar className="h-12 w-12">
                        <AvatarImage src={prestataire.imageProfil} alt={`${prestataire.prenom} ${prestataire.nom}`} />
                        <AvatarFallback className="bg-gradient-primary text-white">
                          {prestataire.prenom.charAt(0)}{prestataire.nom.charAt(0)}
                        </AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <CardTitle className="text-lg">
                          {prestataire.prenom} {prestataire.nom}
                        </CardTitle>
                        <CardDescription className="flex items-center space-x-2 mt-1">
                          <span>{prestataire.serviceType}</span>
                          {getVersionBadge(prestataire.versionDocument)}
                        </CardDescription>
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-3">
                      <div className="flex items-center text-sm text-muted-foreground">
                        <Phone className="h-4 w-4 mr-2" />
                        {prestataire.telephone}
                      </div>
                      <div className="flex items-center text-sm text-muted-foreground">
                        <MapPin className="h-4 w-4 mr-2" />
                        {prestataire.ville}, {prestataire.codePostal}
                      </div>
                      <div className="flex items-center text-sm text-muted-foreground">
                        <Calendar className="h-4 w-4 mr-2" />
                        {prestataire.experience} d'expérience
                      </div>
                      <div className="flex items-center justify-between">
                        {getStatusBadge(prestataire.statut)}
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button 
                              variant="outline" 
                              size="sm"
                              onClick={() => setSelectedPrestataire(prestataire)}
                            >
                              <Eye className="h-4 w-4 mr-2" />
                              Voir détails
                            </Button>
                          </DialogTrigger>
                          <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
                            <DialogHeader>
                              <DialogTitle>Détails du Prestataire</DialogTitle>
                              <DialogDescription>
                                Informations complètes et documents du prestataire
                              </DialogDescription>
                            </DialogHeader>
                            {selectedPrestataire && (
                              <div className="space-y-6">
                                {/* Informations personnelles */}
                                <div>
                                  <h3 className="text-lg font-semibold mb-3">Informations Personnelles</h3>
                                  <div className="grid grid-cols-2 gap-4 text-sm">
                                    <div>
                                      <span className="font-medium">Nom:</span> {selectedPrestataire.nom}
                                    </div>
                                    <div>
                                      <span className="font-medium">Prénom:</span> {selectedPrestataire.prenom}
                                    </div>
                                    <div>
                                      <span className="font-medium">Téléphone:</span> {selectedPrestataire.telephone}
                                    </div>
                                    <div>
                                      <span className="font-medium">Ville:</span> {selectedPrestataire.ville}
                                    </div>
                                    <div>
                                      <span className="font-medium">Code Postal:</span> {selectedPrestataire.codePostal}
                                    </div>
                                    <div>
                                      <span className="font-medium">Adresse:</span> {selectedPrestataire.adresse}
                                    </div>
                                  </div>
                                </div>

                                {/* Informations professionnelles */}
                                <div>
                                  <h3 className="text-lg font-semibold mb-3">Informations Professionnelles</h3>
                                  <div className="grid grid-cols-2 gap-4 text-sm">
                                    <div>
                                      <span className="font-medium">Service:</span> {selectedPrestataire.serviceType}
                                    </div>
                                    <div>
                                      <span className="font-medium">Type:</span> {selectedPrestataire.typeService}
                                    </div>
                                    <div>
                                      <span className="font-medium">Expérience:</span> {selectedPrestataire.experience}
                                    </div>
                                    <div>
                                      <span className="font-medium">Version:</span> {getVersionBadge(selectedPrestataire.versionDocument)}
                                    </div>
                                  </div>
                                  {selectedPrestataire.description && (
                                    <div className="mt-3">
                                      <span className="font-medium">Description:</span>
                                      <p className="text-muted-foreground mt-1">{selectedPrestataire.description}</p>
                                    </div>
                                  )}
                                  {selectedPrestataire.certifications && (
                                    <div className="mt-3">
                                      <span className="font-medium">Certifications:</span>
                                      <p className="text-muted-foreground mt-1">{selectedPrestataire.certifications}</p>
                                    </div>
                                  )}
                                </div>

                                {/* Documents */}
                                <div>
                                  <h3 className="text-lg font-semibold mb-3">Documents</h3>
                                  <div className="space-y-2">
                                    {selectedPrestataire.imageProfil && (
                                      <div className="flex items-center justify-between p-2 bg-muted rounded">
                                        <div className="flex items-center">
                                          <FileText className="h-4 w-4 mr-2" />
                                          <span className="text-sm">Photo de profil: {selectedPrestataire.imageProfil}</span>
                                        </div>
                                        <Button variant="outline" size="sm">
                                          <Download className="h-4 w-4" />
                                        </Button>
                                      </div>
                                    )}
                                    {selectedPrestataire.carteIdentiteRecto && (
                                      <div className="flex items-center justify-between p-2 bg-muted rounded">
                                        <div className="flex items-center">
                                          <FileText className="h-4 w-4 mr-2" />
                                          <span className="text-sm">Carte identité recto: {selectedPrestataire.carteIdentiteRecto}</span>
                                        </div>
                                        <Button variant="outline" size="sm">
                                          <Download className="h-4 w-4" />
                                        </Button>
                                      </div>
                                    )}
                                    {selectedPrestataire.carteIdentiteVerso && (
                                      <div className="flex items-center justify-between p-2 bg-muted rounded">
                                        <div className="flex items-center">
                                          <FileText className="h-4 w-4 mr-2" />
                                          <span className="text-sm">Carte identité verso: {selectedPrestataire.carteIdentiteVerso}</span>
                                        </div>
                                        <Button variant="outline" size="sm">
                                          <Download className="h-4 w-4" />
                                        </Button>
                                      </div>
                                    )}
                                    {selectedPrestataire.cv && (
                                      <div className="flex items-center justify-between p-2 bg-muted rounded">
                                        <div className="flex items-center">
                                          <FileText className="h-4 w-4 mr-2" />
                                          <span className="text-sm">CV: {selectedPrestataire.cv}</span>
                                        </div>
                                        <Button variant="outline" size="sm">
                                          <Download className="h-4 w-4" />
                                        </Button>
                                      </div>
                                    )}
                                    {selectedPrestataire.diplome && (
                                      <div className="flex items-center justify-between p-2 bg-muted rounded">
                                        <div className="flex items-center">
                                          <FileText className="h-4 w-4 mr-2" />
                                          <span className="text-sm">Diplôme: {selectedPrestataire.diplome}</span>
                                        </div>
                                        <Button variant="outline" size="sm">
                                          <Download className="h-4 w-4" />
                                        </Button>
                                      </div>
                                    )}
                                  </div>
                                </div>
                              </div>
                            )}
                          </DialogContent>
                        </Dialog>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default PrestatairesAdmin;
