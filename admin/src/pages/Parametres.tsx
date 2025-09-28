import { useState } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { 
  Settings, Save, Download, Upload, Plus, Edit, Trash2, 
  DollarSign, Percent, Clock, Globe, Bell, Shield, 
  Users, Smartphone, CreditCard 
} from "lucide-react";

const mockServices = [
  {
    id: 1,
    category: "Bâtiment & Construction",
    services: [
      { name: "Plombier", price: 15000, commission: 10, active: true },
      { name: "Électricien", price: 18000, commission: 10, active: true },
      { name: "Maçon", price: 20000, commission: 12, active: true },
      { name: "Carreleur", price: 25000, commission: 12, active: false }
    ]
  },
  {
    id: 2,
    category: "Froid & Climatisation",
    services: [
      { name: "Frigoriste", price: 22000, commission: 15, active: true },
      { name: "Chauffagiste", price: 20000, commission: 12, active: true }
    ]
  },
  {
    id: 3,
    category: "Entretien & Propreté",
    services: [
      { name: "Ménage", price: 8000, commission: 8, active: true },
      { name: "Jardinage", price: 12000, commission: 10, active: true },
      { name: "Lavage voiture", price: 5000, commission: 8, active: true }
    ]
  }
];

const mockPaymentMethods = [
  { name: "Orange Money", enabled: true, commission: 2.5, minAmount: 500, maxAmount: 500000 },
  { name: "Wave", enabled: true, commission: 1.5, minAmount: 100, maxAmount: 1000000 },
  { name: "Free Money", enabled: true, commission: 2.0, minAmount: 500, maxAmount: 300000 },
  { name: "Mixx by Yas", enabled: false, commission: 2.2, minAmount: 1000, maxAmount: 200000 }
];

const Parametres = () => {
  const [selectedTab, setSelectedTab] = useState("general");
  const [settings, setSettings] = useState({
    platformName: "FIBAYA",
    defaultCommission: 10,
    currency: "FCFA",
    timezone: "Africa/Dakar",
    language: "Français",
    maintenanceMode: false,
    autoValidation: false,
    emailNotifications: true,
    smsNotifications: true
  });

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Paramètres Système</h1>
            <p className="text-muted-foreground">Configurez et personnalisez votre plateforme FIBAYA</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Sauvegarder config
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <Save className="h-4 w-4" />
              Appliquer changements
            </Button>
          </div>
        </div>

        {/* Settings Overview Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Services actifs</p>
                  <p className="text-2xl font-bold text-primary">
                    {mockServices.flatMap(c => c.services).filter(s => s.active).length}
                  </p>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <Settings className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Commission moyenne</p>
                  <p className="text-2xl font-bold text-green-600">{settings.defaultCommission}%</p>
                </div>
                <div className="p-3 bg-green-500 rounded-lg">
                  <Percent className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-500/5 to-orange-500/10 border-orange-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Moyens de paiement</p>
                  <p className="text-2xl font-bold text-orange-600">
                    {mockPaymentMethods.filter(p => p.enabled).length}
                  </p>
                </div>
                <div className="p-3 bg-orange-500 rounded-lg">
                  <CreditCard className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-blue-500/5 to-blue-500/10 border-blue-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Statut système</p>
                  <p className="text-2xl font-bold text-blue-600">
                    {settings.maintenanceMode ? "Maintenance" : "Actif"}
                  </p>
                </div>
                <div className="p-3 bg-blue-500 rounded-lg">
                  <Shield className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Settings Tabs */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab}>
          <TabsList className="grid w-full grid-cols-5">
            <TabsTrigger value="general">Général</TabsTrigger>
            <TabsTrigger value="services">Services</TabsTrigger>
            <TabsTrigger value="payments">Paiements</TabsTrigger>
            <TabsTrigger value="notifications">Notifications</TabsTrigger>
            <TabsTrigger value="security">Sécurité</TabsTrigger>
          </TabsList>

          <TabsContent value="general" className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Globe className="h-5 w-5" />
                    Configuration générale
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div>
                    <label className="text-sm font-medium mb-2 block">Nom de la plateforme</label>
                    <Input 
                      value={settings.platformName} 
                      onChange={(e) => setSettings({...settings, platformName: e.target.value})}
                    />
                  </div>
                  
                  <div>
                    <label className="text-sm font-medium mb-2 block">Commission par défaut (%)</label>
                    <Input 
                      type="number" 
                      value={settings.defaultCommission}
                      onChange={(e) => setSettings({...settings, defaultCommission: parseInt(e.target.value)})}
                    />
                  </div>

                  <div>
                    <label className="text-sm font-medium mb-2 block">Devise</label>
                    <Select value={settings.currency} onValueChange={(value) => setSettings({...settings, currency: value})}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="FCFA">FCFA (Franc CFA)</SelectItem>
                        <SelectItem value="EUR">EUR (Euro)</SelectItem>
                        <SelectItem value="USD">USD (Dollar)</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <label className="text-sm font-medium mb-2 block">Fuseau horaire</label>
                    <Select value={settings.timezone} onValueChange={(value) => setSettings({...settings, timezone: value})}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Africa/Dakar">Afrique/Dakar (GMT+0)</SelectItem>
                        <SelectItem value="Africa/Casablanca">Afrique/Casablanca (GMT+1)</SelectItem>
                        <SelectItem value="Europe/Paris">Europe/Paris (GMT+1)</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <label className="text-sm font-medium mb-2 block">Langue par défaut</label>
                    <Select value={settings.language} onValueChange={(value) => setSettings({...settings, language: value})}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Français">Français</SelectItem>
                        <SelectItem value="Wolof">Wolof</SelectItem>
                        <SelectItem value="English">English</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Settings className="h-5 w-5" />
                    Paramètres système
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Mode maintenance</p>
                      <p className="text-sm text-muted-foreground">Désactiver temporairement la plateforme</p>
                    </div>
                    <Switch 
                      checked={settings.maintenanceMode}
                      onCheckedChange={(checked) => setSettings({...settings, maintenanceMode: checked})}
                    />
                  </div>

                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Validation automatique</p>
                      <p className="text-sm text-muted-foreground">Valider automatiquement les nouveaux prestataires</p>
                    </div>
                    <Switch 
                      checked={settings.autoValidation}
                      onCheckedChange={(checked) => setSettings({...settings, autoValidation: checked})}
                    />
                  </div>

                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Notifications email</p>
                      <p className="text-sm text-muted-foreground">Envoyer les notifications par email</p>
                    </div>
                    <Switch 
                      checked={settings.emailNotifications}
                      onCheckedChange={(checked) => setSettings({...settings, emailNotifications: checked})}
                    />
                  </div>

                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Notifications SMS</p>
                      <p className="text-sm text-muted-foreground">Envoyer les notifications par SMS</p>
                    </div>
                    <Switch 
                      checked={settings.smsNotifications}
                      onCheckedChange={(checked) => setSettings({...settings, smsNotifications: checked})}
                    />
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="services" className="space-y-6">
            <div className="flex items-center justify-between">
              <h3 className="text-lg font-semibold">Gestion des services</h3>
              <Button className="gap-2 bg-primary hover:bg-primary/90">
                <Plus className="h-4 w-4" />
                Ajouter service
              </Button>
            </div>

            {mockServices.map((category) => (
              <Card key={category.id}>
                <CardHeader>
                  <CardTitle>{category.category}</CardTitle>
                </CardHeader>
                <CardContent>
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Service</TableHead>
                        <TableHead>Prix de base</TableHead>
                        <TableHead>Commission (%)</TableHead>
                        <TableHead>Statut</TableHead>
                        <TableHead>Actions</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {category.services.map((service, index) => (
                        <TableRow key={index}>
                          <TableCell>
                            <span className="font-medium">{service.name}</span>
                          </TableCell>
                          <TableCell>
                            <span className="font-medium">{service.price.toLocaleString()} FCFA</span>
                          </TableCell>
                          <TableCell>
                            <span className="font-medium">{service.commission}%</span>
                          </TableCell>
                          <TableCell>
                            {service.active ? (
                              <Badge className="bg-green-100 text-green-800 border-green-200">
                                Actif
                              </Badge>
                            ) : (
                              <Badge variant="outline">Inactif</Badge>
                            )}
                          </TableCell>
                          <TableCell>
                            <div className="flex gap-2">
                              <Button size="sm" variant="outline">
                                <Edit className="h-3 w-3" />
                              </Button>
                              <Button size="sm" variant="outline">
                                <Trash2 className="h-3 w-3" />
                              </Button>
                            </div>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </CardContent>
              </Card>
            ))}
          </TabsContent>

          <TabsContent value="payments" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CreditCard className="h-5 w-5" />
                  Moyens de paiement
                </CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Méthode</TableHead>
                      <TableHead>Statut</TableHead>
                      <TableHead>Commission (%)</TableHead>
                      <TableHead>Montant min</TableHead>
                      <TableHead>Montant max</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {mockPaymentMethods.map((method, index) => (
                      <TableRow key={index}>
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <Smartphone className="h-4 w-4" />
                            <span className="font-medium">{method.name}</span>
                          </div>
                        </TableCell>
                        <TableCell>
                          {method.enabled ? (
                            <Badge className="bg-green-100 text-green-800 border-green-200">
                              Activé
                            </Badge>
                          ) : (
                            <Badge variant="outline">Désactivé</Badge>
                          )}
                        </TableCell>
                        <TableCell>
                          <span className="font-medium">{method.commission}%</span>
                        </TableCell>
                        <TableCell>
                          <span>{method.minAmount.toLocaleString()} FCFA</span>
                        </TableCell>
                        <TableCell>
                          <span>{method.maxAmount.toLocaleString()} FCFA</span>
                        </TableCell>
                        <TableCell>
                          <div className="flex gap-2">
                            <Button size="sm" variant="outline">
                              <Edit className="h-3 w-3" />
                            </Button>
                            <Switch checked={method.enabled} />
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="notifications" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Bell className="h-5 w-5" />
                  Configuration des notifications
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div>
                  <h4 className="font-semibold mb-4">Notifications automatiques</h4>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Nouvelles inscriptions</p>
                        <p className="text-sm text-muted-foreground">Notifier les admins lors d'une nouvelle inscription</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Commandes en attente</p>
                        <p className="text-sm text-muted-foreground">Alerter après 30 minutes sans réponse</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Problèmes de paiement</p>
                        <p className="text-sm text-muted-foreground">Notification immédiate en cas d'échec</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="font-semibold mb-4">Paramètres de diffusion</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="text-sm font-medium mb-2 block">Limite SMS par heure</label>
                      <Input type="number" defaultValue="100" />
                    </div>
                    <div>
                      <label className="text-sm font-medium mb-2 block">Limite emails par heure</label>
                      <Input type="number" defaultValue="500" />
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="security" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="h-5 w-5" />
                  Paramètres de sécurité
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div>
                  <h4 className="font-semibold mb-4">Authentification</h4>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Double authentification obligatoire</p>
                        <p className="text-sm text-muted-foreground">Pour les comptes administrateurs</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Expiration des sessions</p>
                        <p className="text-sm text-muted-foreground">Déconnexion automatique après inactivité</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="font-semibold mb-4">Surveillance</h4>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Détection automatique de fraude</p>
                        <p className="text-sm text-muted-foreground">Analyse comportementale en temps réel</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Logs détaillés</p>
                        <p className="text-sm text-muted-foreground">Enregistrement de toutes les actions</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="font-semibold mb-4">Limites de sécurité</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="text-sm font-medium mb-2 block">Tentatives de connexion max</label>
                      <Input type="number" defaultValue="5" />
                    </div>
                    <div>
                      <label className="text-sm font-medium mb-2 block">Durée de blocage (minutes)</label>
                      <Input type="number" defaultValue="30" />
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </PageLayout>
  );
};

export default Parametres;