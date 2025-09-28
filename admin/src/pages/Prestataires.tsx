import { useState, useEffect } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Progress } from "@/components/ui/progress";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { 
  Search, Filter, Download, MoreHorizontal, Phone, Mail, MapPin, 
  CheckCircle, XCircle, Clock, Star, FileText, Eye, UserCheck, Ban 
} from "lucide-react";
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

const Prestataires = () => {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedTab, setSelectedTab] = useState("all");
  const [prestataires, setPrestataires] = useState<Prestataire[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedPrestataire, setSelectedPrestataire] = useState<Prestataire | null>(null);

  const handleDownload = async (fileName: string, documentType: string) => {
    try {
      // URL du backend pour télécharger les fichiers
      const backendUrl = 'http://localhost:8080/api/files';
      const downloadUrl = `${backendUrl}/${fileName}`;
      
      // Créer un lien de téléchargement
      const link = document.createElement('a');
      link.href = downloadUrl;
      link.download = fileName;
      link.target = '_blank';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } catch (error) {
      console.error('Erreur lors du téléchargement:', error);
      alert('Erreur lors du téléchargement du fichier');
    }
  };

  useEffect(() => {
    fetchPrestataires();
  }, []);

  const fetchPrestataires = async () => {
    try {
      setLoading(true);
      const response = await axios.get('http://localhost:8080/api/prestataires/disponibles');
      setPrestataires(response.data);
    } catch (error) {
      console.error('Erreur lors du chargement des prestataires:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleValidatePrestataire = async (prestataireId: number) => {
    try {
      const response = await axios.patch(`http://localhost:8080/api/prestataires/${prestataireId}/valider?validePar=admin`);
      
      if (response.data.success) {
        // Afficher un message de succès
        alert('Prestataire validé avec succès !');
        
        // Recharger la liste des prestataires
        fetchPrestataires();
      } else {
        alert('Erreur lors de la validation: ' + response.data.message);
      }
    } catch (error) {
      console.error('Erreur lors de la validation:', error);
      alert('Erreur lors de la validation du prestataire');
    }
  };

  const handleSuspendPrestataire = async (prestataireId: number) => {
    try {
      const response = await axios.patch(`http://localhost:8080/api/prestataires/${prestataireId}/suspendre?validePar=admin`);

      if (response.data.success) {
        alert('Prestataire suspendu avec succès !');
        fetchPrestataires();
      } else {
        alert('Erreur lors de la suspension: ' + response.data.message);
      }
    } catch (error) {
      console.error('Erreur lors de la suspension:', error);
      alert('Erreur lors de la suspension du prestataire');
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "DISPONIBLE":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Disponible</Badge>;
      case "OCCUPE":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">Occupé</Badge>;
      case "HORS_LIGNE":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Hors ligne</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getVersionBadge = (version: string) => {
    switch (version) {
      case "Pro":
        return <Badge className="bg-blue-100 text-blue-800 border-blue-200">Pro</Badge>;
      case "Simple":
        return <Badge className="bg-gray-100 text-gray-800 border-gray-200">Simple</Badge>;
      default:
        return <Badge variant="outline">{version}</Badge>;
    }
  };

  const filteredPrestataires = prestataires.filter(prestataire => {
    const matchesSearch = prestataire.nom.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         prestataire.prenom.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         prestataire.serviceType.toLowerCase().includes(searchQuery.toLowerCase());
    
    if (selectedTab === "all") return matchesSearch;
    if (selectedTab === "disponible") return matchesSearch && prestataire.statut === "DISPONIBLE";
    if (selectedTab === "occupe") return matchesSearch && prestataire.statut === "OCCUPE";
    if (selectedTab === "hors_ligne") return matchesSearch && prestataire.statut === "HORS_LIGNE";
    
    return matchesSearch;
  });

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Gestion des Prestataires</h1>
            <p className="text-muted-foreground">Validez et gérez tous vos prestataires de services</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Exporter
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <UserCheck className="h-4 w-4" />
              Valider en masse
            </Button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Total Prestataires</p>
                  <p className="text-2xl font-bold text-primary">{prestataires.length}</p>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <UserCheck className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Disponibles</p>
                  <p className="text-2xl font-bold text-green-600">{prestataires.filter(p => p.statut === "DISPONIBLE").length}</p>
                </div>
                <div className="p-3 bg-green-500 rounded-lg">
                  <CheckCircle className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-500/5 to-orange-500/10 border-orange-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Occupés</p>
                  <p className="text-2xl font-bold text-orange-600">{prestataires.filter(p => p.statut === "OCCUPE").length}</p>
                </div>
                <div className="p-3 bg-orange-500 rounded-lg">
                  <Clock className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-red-500/5 to-red-500/10 border-red-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Hors ligne</p>
                  <p className="text-2xl font-bold text-red-600">{prestataires.filter(p => p.statut === "HORS_LIGNE").length}</p>
                </div>
                <div className="p-3 bg-red-500 rounded-lg">
                  <Ban className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Filters and Search */}
        <Card>
          <CardContent className="p-6">
            <div className="flex flex-col sm:flex-row gap-4">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input
                  placeholder="Rechercher par nom, service ou téléphone..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10"
                />
              </div>
              <Button variant="outline" className="gap-2">
                <Filter className="h-4 w-4" />
                Filtres avancés
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Prestataires Table */}
        <Card>
          <CardHeader>
            <CardTitle>Liste des Prestataires</CardTitle>
            <Tabs value={selectedTab} onValueChange={setSelectedTab}>
              <TabsList>
                <TabsTrigger value="all">Tous ({prestataires.length})</TabsTrigger>
                <TabsTrigger value="disponible">Disponibles ({prestataires.filter(p => p.statut === "DISPONIBLE").length})</TabsTrigger>
                <TabsTrigger value="occupe">Occupés ({prestataires.filter(p => p.statut === "OCCUPE").length})</TabsTrigger>
                <TabsTrigger value="hors_ligne">Hors ligne ({prestataires.filter(p => p.statut === "HORS_LIGNE").length})</TabsTrigger>
              </TabsList>
            </Tabs>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="text-center py-12">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                <p className="mt-4 text-muted-foreground">Chargement des prestataires...</p>
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Prestataire</TableHead>
                    <TableHead>Service</TableHead>
                    <TableHead>Contact</TableHead>
                    <TableHead>Documents</TableHead>
                    <TableHead>Version</TableHead>
                    <TableHead>Statut</TableHead>
                    <TableHead>Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredPrestataires.map((prestataire) => (
                    <TableRow key={prestataire.id} className="hover:bg-muted/50">
                      <TableCell>
                        <div className="flex items-center gap-3">
                          <Avatar>
                            <AvatarImage src={prestataire.imageProfil} />
                            <AvatarFallback className="bg-primary text-primary-foreground">
                              {prestataire.prenom.charAt(0)}{prestataire.nom.charAt(0)}
                            </AvatarFallback>
                          </Avatar>
                          <div>
                            <p className="font-medium">{prestataire.prenom} {prestataire.nom}</p>
                            <p className="text-sm text-muted-foreground">ID: {prestataire.id}</p>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div>
                          <p className="font-medium">{prestataire.serviceType}</p>
                          <div className="flex items-center gap-1 text-sm text-muted-foreground">
                            <MapPin className="h-3 w-3" />
                            {prestataire.ville}, {prestataire.codePostal}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="space-y-1">
                          <div className="flex items-center gap-1 text-sm">
                            <Phone className="h-3 w-3" />
                            {prestataire.telephone}
                          </div>
                          <div className="flex items-center gap-1 text-sm text-muted-foreground">
                            <MapPin className="h-3 w-3" />
                            {prestataire.adresse}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="flex gap-2">
                          {prestataire.carteIdentiteRecto ? 
                            <CheckCircle className="h-4 w-4 text-green-600" /> : 
                            <XCircle className="h-4 w-4 text-red-600" />
                          }
                          {prestataire.diplome ? 
                            <CheckCircle className="h-4 w-4 text-green-600" /> : 
                            <XCircle className="h-4 w-4 text-red-600" />
                          }
                          {prestataire.cv ? 
                            <CheckCircle className="h-4 w-4 text-green-600" /> : 
                            <XCircle className="h-4 w-4 text-red-600" />
                          }
                        </div>
                        <p className="text-xs text-muted-foreground mt-1">CI, Diplôme, CV</p>
                      </TableCell>
                      <TableCell>
                        {getVersionBadge(prestataire.versionDocument)}
                      </TableCell>
                      <TableCell>
                        {getStatusBadge(prestataire.statut)}
                      </TableCell>
                      <TableCell>
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                              <MoreHorizontal className="h-4 w-4" />
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuItem 
                              className="gap-2"
                              onClick={() => setSelectedPrestataire(prestataire)}
                            >
                              <Eye className="h-4 w-4" />
                              Voir profil
                            </DropdownMenuItem>
                            <DropdownMenuItem className="gap-2">
                              <FileText className="h-4 w-4" />
                              Documents
                            </DropdownMenuItem>
                            <DropdownMenuItem 
                              className="gap-2 text-green-600"
                              onClick={() => handleValidatePrestataire(prestataire.id)}
                            >
                              <CheckCircle className="h-4 w-4" />
                              Valider
                            </DropdownMenuItem>
                            <DropdownMenuItem 
                              className="gap-2 text-red-600"
                              onClick={() => handleSuspendPrestataire(prestataire.id)}
                            >
                              <Ban className="h-4 w-4" />
                              Suspendre
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        {/* Modal pour voir les détails */}
        {selectedPrestataire && (
          <Dialog open={!!selectedPrestataire} onOpenChange={() => setSelectedPrestataire(null)}>
            <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>Détails du Prestataire</DialogTitle>
                <DialogDescription>
                  Informations complètes et documents du prestataire
                </DialogDescription>
              </DialogHeader>
              <div className="space-y-6">
                {/* Informations personnelles */}
                <div>
                  <h3 className="text-lg font-semibold mb-3">Informations Personnelles</h3>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div><span className="font-medium">Nom:</span> {selectedPrestataire.nom}</div>
                    <div><span className="font-medium">Prénom:</span> {selectedPrestataire.prenom}</div>
                    <div><span className="font-medium">Téléphone:</span> {selectedPrestataire.telephone}</div>
                    <div><span className="font-medium">Ville:</span> {selectedPrestataire.ville}</div>
                    <div><span className="font-medium">Code Postal:</span> {selectedPrestataire.codePostal}</div>
                    <div><span className="font-medium">Adresse:</span> {selectedPrestataire.adresse}</div>
                  </div>
                </div>

                {/* Informations professionnelles */}
                <div>
                  <h3 className="text-lg font-semibold mb-3">Informations Professionnelles</h3>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div><span className="font-medium">Service:</span> {selectedPrestataire.serviceType}</div>
                    <div><span className="font-medium">Type:</span> {selectedPrestataire.typeService}</div>
                    <div><span className="font-medium">Expérience:</span> {selectedPrestataire.experience}</div>
                    <div><span className="font-medium">Version:</span> {getVersionBadge(selectedPrestataire.versionDocument)}</div>
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
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => handleDownload(selectedPrestataire.imageProfil, 'Photo de profil')}
                        >
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
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => handleDownload(selectedPrestataire.carteIdentiteRecto, 'Carte identité recto')}
                        >
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
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => handleDownload(selectedPrestataire.carteIdentiteVerso, 'Carte identité verso')}
                        >
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
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => handleDownload(selectedPrestataire.cv, 'CV')}
                        >
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
                        <Button 
                          variant="outline" 
                          size="sm"
                          onClick={() => handleDownload(selectedPrestataire.diplome, 'Diplôme')}
                        >
                          <Download className="h-4 w-4" />
                        </Button>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        )}
      </div>
    </PageLayout>
  );
};

export default Prestataires;
