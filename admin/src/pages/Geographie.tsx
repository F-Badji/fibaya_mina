import { useState } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { 
  MapPin, Users, Zap, TrendingUp, Plus, Edit, Trash2, 
  Navigation, Settings, Download, Filter 
} from "lucide-react";

const regions = [
  {
    id: 1,
    name: "Dakar",
    coordinates: "14.6937, -17.4441",
    clients: 1250,
    prestataires: 89,
    commandes: 3420,
    revenus: 85600000,
    croissance: "+15%",
    zones: [
      { name: "Plateau", clients: 285, prestataires: 23 },
      { name: "Almadies", clients: 198, prestataires: 18 },
      { name: "Parcelles Assainies", clients: 432, prestataires: 31 },
      { name: "Guédiawaye", clients: 335, prestataires: 17 }
    ]
  },
  {
    id: 2,
    name: "Thiès",
    coordinates: "14.7886, -16.9269",
    clients: 450,
    prestataires: 34,
    commandes: 1280,
    revenus: 32400000,
    croissance: "+8%",
    zones: [
      { name: "Centre-ville", clients: 195, prestataires: 15 },
      { name: "Mbour", clients: 255, prestataires: 19 }
    ]
  },
  {
    id: 3,
    name: "Saint-Louis",
    coordinates: "16.0374, -16.4889",
    clients: 320,
    prestataires: 23,
    commandes: 890,
    revenus: 22300000,
    croissance: "+12%",
    zones: [
      { name: "Île", clients: 145, prestataires: 12 },
      { name: "Sor", clients: 175, prestataires: 11 }
    ]
  },
  {
    id: 4,
    name: "Kaolack",
    coordinates: "14.1612, -16.0781",
    clients: 280,
    prestataires: 19,
    commandes: 740,
    revenus: 18500000,
    croissance: "+5%",
    zones: [
      { name: "Centre", clients: 180, prestataires: 12 },
      { name: "Périphérie", clients: 100, prestataires: 7 }
    ]
  },
  {
    id: 5,
    name: "Ziguinchor",
    coordinates: "12.5681, -16.2739",
    clients: 190,
    prestataires: 12,
    commandes: 520,
    revenus: 13000000,
    croissance: "+3%",
    zones: [
      { name: "Centre-ville", clients: 120, prestataires: 8 },
      { name: "Boucotte", clients: 70, prestataires: 4 }
    ]
  }
];

const serviceZones = [
  {
    service: "Plomberie",
    coverage: "National",
    regions: 5,
    prestataires: 67,
    tempsReponse: "15 min",
    satisfaction: 4.6
  },
  {
    service: "Électricité",
    coverage: "Dakar-Thiès",
    regions: 2,
    prestataires: 45,
    tempsReponse: "20 min",
    satisfaction: 4.7
  },
  {
    service: "Ménage",
    coverage: "National",
    regions: 5,
    prestataires: 89,
    tempsReponse: "25 min",
    satisfaction: 4.5
  },
  {
    service: "Mécanique",
    coverage: "Dakar uniquement",
    regions: 1,
    prestataires: 23,
    tempsReponse: "30 min",
    satisfaction: 4.4
  }
];

const Geographie = () => {
  const [selectedTab, setSelectedTab] = useState("overview");
  const [selectedRegion, setSelectedRegion] = useState("all");

  const totalClients = regions.reduce((sum, region) => sum + region.clients, 0);
  const totalPrestataires = regions.reduce((sum, region) => sum + region.prestataires, 0);
  const totalCommandes = regions.reduce((sum, region) => sum + region.commandes, 0);
  const totalRevenus = regions.reduce((sum, region) => sum + region.revenus, 0);

  const filteredRegions = selectedRegion === "all" ? regions : regions.filter(r => r.id === parseInt(selectedRegion));

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Gestion Géographique</h1>
            <p className="text-muted-foreground">Surveillez et gérez la couverture territoriale de FIBAYA</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Rapport géographique
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <Plus className="h-4 w-4" />
              Nouvelle zone
            </Button>
          </div>
        </div>

        {/* Geographic Overview Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Total Clients</p>
                  <p className="text-2xl font-bold text-primary">{totalClients.toLocaleString()}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingUp className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+12% ce mois</span>
                  </div>
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
                  <p className="text-sm text-muted-foreground">Prestataires</p>
                  <p className="text-2xl font-bold text-green-600">{totalPrestataires}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Zap className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">5 régions</span>
                  </div>
                </div>
                <div className="p-3 bg-green-500 rounded-lg">
                  <Zap className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-500/5 to-orange-500/10 border-orange-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Commandes</p>
                  <p className="text-2xl font-bold text-orange-600">{totalCommandes.toLocaleString()}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Navigation className="h-3 w-3 text-orange-600" />
                    <span className="text-xs text-orange-600">Ce mois</span>
                  </div>
                </div>
                <div className="p-3 bg-orange-500 rounded-lg">
                  <Navigation className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-blue-500/5 to-blue-500/10 border-blue-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Revenus Total</p>
                  <p className="text-2xl font-bold text-blue-600">{(totalRevenus / 1000000).toFixed(1)}M FCFA</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingUp className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+9% ce mois</span>
                  </div>
                </div>
                <div className="p-3 bg-blue-500 rounded-lg">
                  <MapPin className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Geographic Map Placeholder */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle>Carte de couverture géographique</CardTitle>
              <div className="flex gap-2">
                <Select value={selectedRegion} onValueChange={setSelectedRegion}>
                  <SelectTrigger className="w-40">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Toutes les régions</SelectItem>
                    {regions.map(region => (
                      <SelectItem key={region.id} value={region.id.toString()}>
                        {region.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <Button variant="outline" size="sm" className="gap-2">
                  <Filter className="h-4 w-4" />
                  Filtrer
                </Button>
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <div className="bg-gradient-to-br from-primary/5 to-blue-500/5 rounded-lg p-8 text-center border-2 border-dashed border-primary/20">
              <MapPin className="h-16 w-16 text-primary mx-auto mb-4" />
              <h3 className="text-lg font-semibold mb-2">Carte interactive Sénégal</h3>
              <p className="text-muted-foreground mb-4">
                Visualisation en temps réel de la répartition des clients et prestataires par région
              </p>
              <Button className="bg-primary hover:bg-primary/90">
                Voir la carte complète
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Tabs */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab}>
          <TabsList>
            <TabsTrigger value="overview">Vue d'ensemble</TabsTrigger>
            <TabsTrigger value="regions">Régions</TabsTrigger>
            <TabsTrigger value="services">Services par zone</TabsTrigger>
            <TabsTrigger value="analytics">Analytics géo</TabsTrigger>
          </TabsList>

          <TabsContent value="regions" className="space-y-4">
            <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4">
              {filteredRegions.map((region) => (
                <Card key={region.id} className="hover:shadow-lg transition-shadow">
                  <CardHeader>
                    <div className="flex items-center justify-between">
                      <CardTitle className="flex items-center gap-2">
                        <MapPin className="h-5 w-5 text-primary" />
                        {region.name}
                      </CardTitle>
                      <Badge className="bg-green-100 text-green-800 border-green-200">
                        {region.croissance}
                      </Badge>
                    </div>
                    <p className="text-sm text-muted-foreground">{region.coordinates}</p>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4 text-center">
                      <div>
                        <p className="text-2xl font-bold text-primary">{region.clients}</p>
                        <p className="text-xs text-muted-foreground">Clients</p>
                      </div>
                      <div>
                        <p className="text-2xl font-bold text-green-600">{region.prestataires}</p>
                        <p className="text-xs text-muted-foreground">Prestataires</p>
                      </div>
                    </div>

                    <div className="grid grid-cols-2 gap-4 text-center">
                      <div>
                        <p className="text-lg font-semibold">{region.commandes}</p>
                        <p className="text-xs text-muted-foreground">Commandes</p>
                      </div>
                      <div>
                        <p className="text-lg font-semibold text-primary">
                          {(region.revenus / 1000000).toFixed(1)}M
                        </p>
                        <p className="text-xs text-muted-foreground">FCFA</p>
                      </div>
                    </div>

                    <div>
                      <h4 className="font-medium mb-2">Zones principales:</h4>
                      <div className="space-y-1">
                        {region.zones.map((zone, index) => (
                          <div key={index} className="flex justify-between text-sm">
                            <span>{zone.name}</span>
                            <span className="text-muted-foreground">
                              {zone.clients} clients, {zone.prestataires} prest.
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>

                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" className="flex-1">
                        <Edit className="h-3 w-3 mr-1" />
                        Modifier
                      </Button>
                      <Button size="sm" variant="outline" className="flex-1">
                        <Settings className="h-3 w-3 mr-1" />
                        Paramètres
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="services" className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>Couverture des services par zone</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Service</TableHead>
                      <TableHead>Couverture</TableHead>
                      <TableHead>Régions actives</TableHead>
                      <TableHead>Prestataires</TableHead>
                      <TableHead>Temps de réponse</TableHead>
                      <TableHead>Satisfaction</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {serviceZones.map((service, index) => (
                      <TableRow key={index}>
                        <TableCell>
                          <span className="font-medium">{service.service}</span>
                        </TableCell>
                        <TableCell>
                          <Badge variant="outline">{service.coverage}</Badge>
                        </TableCell>
                        <TableCell>
                          <span className="font-medium">{service.regions}</span> région(s)
                        </TableCell>
                        <TableCell>
                          <span className="font-medium text-primary">{service.prestataires}</span>
                        </TableCell>
                        <TableCell>
                          <span className="font-medium">{service.tempsReponse}</span>
                        </TableCell>
                        <TableCell>
                          <div className="flex items-center gap-1">
                            <span className="font-medium">{service.satisfaction}</span>
                            <span className="text-orange-500">★</span>
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="flex gap-2">
                            <Button size="sm" variant="outline">
                              <Edit className="h-3 w-3" />
                            </Button>
                            <Button size="sm" variant="outline">
                              <Settings className="h-3 w-3" />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="analytics" className="space-y-4">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle>Performance par région</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {regions.map((region) => (
                      <div key={region.id} className="flex items-center justify-between p-3 border rounded-lg">
                        <div className="flex items-center gap-3">
                          <div className="w-3 h-3 bg-primary rounded-full"></div>
                          <span className="font-medium">{region.name}</span>
                        </div>
                        <div className="text-right">
                          <p className="font-semibold">{region.commandes} commandes</p>
                          <p className="text-sm text-muted-foreground">
                            {((region.commandes / totalCommandes) * 100).toFixed(1)}% du total
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Zones d'expansion recommandées</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="p-3 border rounded-lg bg-green-50">
                      <h4 className="font-medium text-green-700">Tambacounda</h4>
                      <p className="text-sm text-muted-foreground mb-2">
                        Forte demande détectée, faible concurrence
                      </p>
                      <div className="flex justify-between text-xs">
                        <span>Potentiel: Élevé</span>
                        <span>Investment: Moyen</span>
                      </div>
                    </div>
                    
                    <div className="p-3 border rounded-lg bg-orange-50">
                      <h4 className="font-medium text-orange-700">Kolda</h4>
                      <p className="text-sm text-muted-foreground mb-2">
                        Marché émergent avec croissance potentielle
                      </p>
                      <div className="flex justify-between text-xs">
                        <span>Potentiel: Moyen</span>
                        <span>Investment: Faible</span>
                      </div>
                    </div>

                    <div className="p-3 border rounded-lg bg-blue-50">
                      <h4 className="font-medium text-blue-700">Fatick</h4>
                      <p className="text-sm text-muted-foreground mb-2">
                        Connexion stratégique entre régions existantes
                      </p>
                      <div className="flex justify-between text-xs">
                        <span>Potentiel: Moyen</span>
                        <span>Investment: Élevé</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </PageLayout>
  );
};

export default Geographie;