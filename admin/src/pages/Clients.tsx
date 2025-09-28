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
  CheckCircle, XCircle, Clock, Star, FileText, Eye, Users, Ban 
} from "lucide-react";
import axios from "axios";

interface Client {
  id: number;
  nom: string;
  prenom: string;
  telephone: string;
  email: string;
  adresse: string;
  ville: string;
  codePostal: string;
  dateInscription: string;
  statut: string;
  nombreCommandes: number;
  montantTotal: number;
  derniereActivite: string;
  preferences: string;
  imageProfil: string;
}

const Clients = () => {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedTab, setSelectedTab] = useState("all");
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedClient, setSelectedClient] = useState<Client | null>(null);

  const handleDownload = async (fileName: string, documentType: string) => {
    try {
      // URL du backend pour télécharger les fichiers
      const backendUrl = 'http://localhost:8081/api/files';
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
    fetchClients();
  }, []);

  const fetchClients = async () => {
    try {
      setLoading(true);
      // Simulation de données clients - à remplacer par l'API réelle
      const mockClients: Client[] = [
        {
          id: 1,
          nom: "Dupont",
          prenom: "Marie",
          telephone: "+221 77 123 45 67",
          email: "marie.dupont@email.com",
          adresse: "123 Avenue Bourguiba",
          ville: "Dakar",
          codePostal: "10000",
          dateInscription: "2024-01-15",
          statut: "ACTIF",
          nombreCommandes: 12,
          montantTotal: 45000,
          derniereActivite: "2024-01-20",
          preferences: "Nettoyage, Cuisine",
          imageProfil: ""
        },
        {
          id: 2,
          nom: "Fall",
          prenom: "Amadou",
          telephone: "+221 78 234 56 78",
          email: "amadou.fall@email.com",
          adresse: "456 Rue de la République",
          ville: "Thiès",
          codePostal: "24000",
          dateInscription: "2024-01-10",
          statut: "ACTIF",
          nombreCommandes: 8,
          montantTotal: 32000,
          derniereActivite: "2024-01-18",
          preferences: "Jardinage, Bricolage",
          imageProfil: ""
        },
        {
          id: 3,
          nom: "Ndiaye",
          prenom: "Fatou",
          telephone: "+221 76 345 67 89",
          email: "fatou.ndiaye@email.com",
          adresse: "789 Boulevard du Centenaire",
          ville: "Dakar",
          codePostal: "10000",
          dateInscription: "2024-01-05",
          statut: "INACTIF",
          nombreCommandes: 3,
          montantTotal: 15000,
          derniereActivite: "2024-01-12",
          preferences: "Cuisine",
          imageProfil: ""
        }
      ];
      setClients(mockClients);
    } catch (error) {
      console.error('Erreur lors du chargement des clients:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "ACTIF":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Actif</Badge>;
      case "INACTIF":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">Inactif</Badge>;
      case "SUSPENDU":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Suspendu</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getActivityBadge = (days: number) => {
    if (days <= 7) {
      return <Badge className="bg-green-100 text-green-800 border-green-200">Récent</Badge>;
    } else if (days <= 30) {
      return <Badge className="bg-yellow-100 text-yellow-800 border-yellow-200">Modéré</Badge>;
    } else {
      return <Badge className="bg-red-100 text-red-800 border-red-200">Ancien</Badge>;
    }
  };

  const filteredClients = clients.filter(client => {
    const matchesSearch = client.nom.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         client.prenom.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         client.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         client.telephone.includes(searchQuery);
    
    if (selectedTab === "all") return matchesSearch;
    if (selectedTab === "actif") return matchesSearch && client.statut === "ACTIF";
    if (selectedTab === "inactif") return matchesSearch && client.statut === "INACTIF";
    if (selectedTab === "suspendu") return matchesSearch && client.statut === "SUSPENDU";
    
    return matchesSearch;
  });

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Gestion des Clients</h1>
            <p className="text-muted-foreground">Gérez et suivez tous vos clients</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Exporter
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <Users className="h-4 w-4" />
              Analyser
            </Button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Total Clients</p>
                  <p className="text-2xl font-bold text-primary">{clients.length}</p>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <Users className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Actifs</p>
                  <p className="text-2xl font-bold text-green-600">{clients.filter(c => c.statut === "ACTIF").length}</p>
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
                  <p className="text-sm text-muted-foreground">Inactifs</p>
                  <p className="text-2xl font-bold text-orange-600">{clients.filter(c => c.statut === "INACTIF").length}</p>
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
                  <p className="text-sm text-muted-foreground">Suspendus</p>
                  <p className="text-2xl font-bold text-red-600">{clients.filter(c => c.statut === "SUSPENDU").length}</p>
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
                  placeholder="Rechercher par nom, email ou téléphone..."
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

        {/* Clients Table */}
        <Card>
          <CardHeader>
            <CardTitle>Liste des Clients</CardTitle>
            <Tabs value={selectedTab} onValueChange={setSelectedTab}>
              <TabsList>
                <TabsTrigger value="all">Tous ({clients.length})</TabsTrigger>
                <TabsTrigger value="actif">Actifs ({clients.filter(c => c.statut === "ACTIF").length})</TabsTrigger>
                <TabsTrigger value="inactif">Inactifs ({clients.filter(c => c.statut === "INACTIF").length})</TabsTrigger>
                <TabsTrigger value="suspendu">Suspendus ({clients.filter(c => c.statut === "SUSPENDU").length})</TabsTrigger>
              </TabsList>
            </Tabs>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="text-center py-12">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                <p className="mt-4 text-muted-foreground">Chargement des clients...</p>
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Client</TableHead>
                    <TableHead>Contact</TableHead>
                    <TableHead>Localisation</TableHead>
                    <TableHead>Activité</TableHead>
                    <TableHead>Commandes</TableHead>
                    <TableHead>Statut</TableHead>
                    <TableHead>Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredClients.map((client) => (
                    <TableRow key={client.id} className="hover:bg-muted/50">
                      <TableCell>
                        <div className="flex items-center gap-3">
                          <Avatar>
                            <AvatarImage src={client.imageProfil} />
                            <AvatarFallback className="bg-primary text-primary-foreground">
                              {client.prenom.charAt(0)}{client.nom.charAt(0)}
                            </AvatarFallback>
                          </Avatar>
                          <div>
                            <p className="font-medium">{client.prenom} {client.nom}</p>
                            <p className="text-sm text-muted-foreground">ID: {client.id}</p>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="space-y-1">
                          <div className="flex items-center gap-1 text-sm">
                            <Phone className="h-3 w-3" />
                            {client.telephone}
                          </div>
                          <div className="flex items-center gap-1 text-sm text-muted-foreground">
                            <Mail className="h-3 w-3" />
                            {client.email}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div>
                          <div className="flex items-center gap-1 text-sm text-muted-foreground">
                            <MapPin className="h-3 w-3" />
                            {client.ville}, {client.codePostal}
                          </div>
                          <p className="text-xs text-muted-foreground mt-1">{client.adresse}</p>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="space-y-1">
                          <p className="text-sm font-medium">{client.nombreCommandes} commandes</p>
                          <p className="text-xs text-muted-foreground">
                            Dernière: {new Date(client.derniereActivite).toLocaleDateString()}
                          </p>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="space-y-1">
                          <p className="text-sm font-medium">{client.montantTotal.toLocaleString()} FCFA</p>
                          <p className="text-xs text-muted-foreground">
                            Moyenne: {Math.round(client.montantTotal / client.nombreCommandes).toLocaleString()} FCFA
                          </p>
                        </div>
                      </TableCell>
                      <TableCell>
                        {getStatusBadge(client.statut)}
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
                              onClick={() => setSelectedClient(client)}
                            >
                              <Eye className="h-4 w-4" />
                              Voir profil
                            </DropdownMenuItem>
                            <DropdownMenuItem className="gap-2">
                              <FileText className="h-4 w-4" />
                              Historique
                            </DropdownMenuItem>
                            <DropdownMenuItem className="gap-2 text-green-600">
                              <CheckCircle className="h-4 w-4" />
                              Activer
                            </DropdownMenuItem>
                            <DropdownMenuItem className="gap-2 text-red-600">
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
        {selectedClient && (
          <Dialog open={!!selectedClient} onOpenChange={() => setSelectedClient(null)}>
            <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>Détails du Client</DialogTitle>
                <DialogDescription>
                  Informations complètes et historique du client
                </DialogDescription>
              </DialogHeader>
              <div className="space-y-6">
                {/* Informations personnelles */}
                <div>
                  <h3 className="text-lg font-semibold mb-3">Informations Personnelles</h3>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div><span className="font-medium">Nom:</span> {selectedClient.nom}</div>
                    <div><span className="font-medium">Prénom:</span> {selectedClient.prenom}</div>
                    <div><span className="font-medium">Téléphone:</span> {selectedClient.telephone}</div>
                    <div><span className="font-medium">Email:</span> {selectedClient.email}</div>
                    <div><span className="font-medium">Ville:</span> {selectedClient.ville}</div>
                    <div><span className="font-medium">Code Postal:</span> {selectedClient.codePostal}</div>
                    <div className="col-span-2"><span className="font-medium">Adresse:</span> {selectedClient.adresse}</div>
                  </div>
                </div>

                {/* Informations d'activité */}
                <div>
                  <h3 className="text-lg font-semibold mb-3">Activité et Commandes</h3>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div><span className="font-medium">Date d'inscription:</span> {new Date(selectedClient.dateInscription).toLocaleDateString()}</div>
                    <div><span className="font-medium">Statut:</span> {getStatusBadge(selectedClient.statut)}</div>
                    <div><span className="font-medium">Nombre de commandes:</span> {selectedClient.nombreCommandes}</div>
                    <div><span className="font-medium">Montant total:</span> {selectedClient.montantTotal.toLocaleString()} FCFA</div>
                    <div><span className="font-medium">Dernière activité:</span> {new Date(selectedClient.derniereActivite).toLocaleDateString()}</div>
                    <div><span className="font-medium">Montant moyen:</span> {Math.round(selectedClient.montantTotal / selectedClient.nombreCommandes).toLocaleString()} FCFA</div>
                  </div>
                  {selectedClient.preferences && (
                    <div className="mt-3">
                      <span className="font-medium">Préférences de services:</span>
                      <p className="text-muted-foreground mt-1">{selectedClient.preferences}</p>
                    </div>
                  )}
                </div>

                {/* Statistiques */}
                <div>
                  <h3 className="text-lg font-semibold mb-3">Statistiques</h3>
                  <div className="space-y-3">
                    <div>
                      <div className="flex justify-between text-sm mb-1">
                        <span>Fidélité client</span>
                        <span>{Math.min(100, (selectedClient.nombreCommandes * 10))}%</span>
                      </div>
                      <Progress value={Math.min(100, (selectedClient.nombreCommandes * 10))} className="h-2" />
                    </div>
                    <div>
                      <div className="flex justify-between text-sm mb-1">
                        <span>Valeur client</span>
                        <span>{selectedClient.montantTotal > 50000 ? 'Élevée' : selectedClient.montantTotal > 20000 ? 'Moyenne' : 'Faible'}</span>
                      </div>
                      <Progress 
                        value={selectedClient.montantTotal > 50000 ? 100 : selectedClient.montantTotal > 20000 ? 60 : 30} 
                        className="h-2" 
                      />
                    </div>
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

export default Clients;