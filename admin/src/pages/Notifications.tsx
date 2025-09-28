import { useState } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Switch } from "@/components/ui/switch";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { 
  Bell, Send, MessageSquare, Smartphone, Mail, Users, 
  AlertTriangle, CheckCircle, Clock, Settings, Plus, Eye, Trash2 
} from "lucide-react";

const mockNotifications = [
  {
    id: "NOTIF001",
    type: "Nouvelle inscription",
    title: "Nouveau prestataire en attente",
    message: "Khadija Mbaye s'est inscrite comme coiffeuse",
    target: "Administrateurs",
    channels: ["push", "email"],
    status: "Envoyé",
    createdAt: "2024-03-16 14:30",
    recipients: 3
  },
  {
    id: "NOTIF002", 
    type: "Problème paiement",
    title: "Échec de transaction",
    message: "Transaction échouée pour la commande CMD-2024-001",
    target: "Équipe finance",
    channels: ["push", "sms"],
    status: "En cours",
    createdAt: "2024-03-16 12:15",
    recipients: 5
  },
  {
    id: "NOTIF003",
    type: "Commande urgente",
    title: "Service d'urgence demandé",
    message: "Fuite d'eau urgente signalée à Dakar",
    target: "Plombiers Dakar",
    channels: ["push", "sms", "email"],
    status: "Programmé",
    createdAt: "2024-03-16 16:45",
    recipients: 12
  }
];

const mockChannelStats = {
  push: { sent: 1250, delivered: 1189, opened: 892 },
  sms: { sent: 890, delivered: 856, opened: 634 },
  email: { sent: 456, delivered: 423, opened: 287 }
};

const Notifications = () => {
  const [selectedTab, setSelectedTab] = useState("overview");
  const [newNotification, setNewNotification] = useState({
    title: "",
    message: "",
    target: "",
    channels: [],
    scheduled: false
  });

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "Envoyé":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Envoyé</Badge>;
      case "En cours":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">En cours</Badge>;
      case "Programmé":
        return <Badge className="bg-blue-100 text-blue-800 border-blue-200">Programmé</Badge>;
      case "Échoué":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Échoué</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getChannelIcon = (channel: string) => {
    switch (channel) {
      case "push":
        return <Smartphone className="h-3 w-3" />;
      case "sms":
        return <MessageSquare className="h-3 w-3" />;
      case "email":
        return <Mail className="h-3 w-3" />;
      default:
        return <Bell className="h-3 w-3" />;
    }
  };

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Centre de Notifications</h1>
            <p className="text-muted-foreground">Gérez et envoyez des notifications à vos utilisateurs</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Settings className="h-4 w-4" />
              Paramètres
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <Plus className="h-4 w-4" />
              Nouvelle notification
            </Button>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Total envoyées</p>
                  <p className="text-2xl font-bold text-primary">2,596</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Send className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+12% ce mois</span>
                  </div>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <Bell className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Taux de livraison</p>
                  <p className="text-2xl font-bold text-green-600">94.2%</p>
                  <div className="flex items-center gap-1 mt-1">
                    <CheckCircle className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+2.1% vs mois dernier</span>
                  </div>
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
                  <p className="text-sm text-muted-foreground">Taux d'ouverture</p>
                  <p className="text-2xl font-bold text-orange-600">68.7%</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Eye className="h-3 w-3 text-orange-600" />
                    <span className="text-xs text-orange-600">Stable</span>
                  </div>
                </div>
                <div className="p-3 bg-orange-500 rounded-lg">
                  <Eye className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-red-500/5 to-red-500/10 border-red-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">En attente</p>
                  <p className="text-2xl font-bold text-red-600">23</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Clock className="h-3 w-3 text-red-600" />
                    <span className="text-xs text-red-600">À traiter</span>
                  </div>
                </div>
                <div className="p-3 bg-red-500 rounded-lg">
                  <Clock className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Channel Performance */}
        <Card>
          <CardHeader>
            <CardTitle>Performance par canal</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-3">
                  <Smartphone className="h-5 w-5 text-primary" />
                  <h3 className="font-semibold">Notifications Push</h3>
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Envoyées</span>
                    <span className="font-medium">{mockChannelStats.push.sent}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Livrées</span>
                    <span className="font-medium text-green-600">{mockChannelStats.push.delivered}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Ouvertes</span>
                    <span className="font-medium text-primary">{mockChannelStats.push.opened}</span>
                  </div>
                </div>
              </div>

              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-3">
                  <MessageSquare className="h-5 w-5 text-green-600" />
                  <h3 className="font-semibold">SMS</h3>
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Envoyés</span>
                    <span className="font-medium">{mockChannelStats.sms.sent}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Livrés</span>
                    <span className="font-medium text-green-600">{mockChannelStats.sms.delivered}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Lus</span>
                    <span className="font-medium text-primary">{mockChannelStats.sms.opened}</span>
                  </div>
                </div>
              </div>

              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-3">
                  <Mail className="h-5 w-5 text-orange-600" />
                  <h3 className="font-semibold">Email</h3>
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Envoyés</span>
                    <span className="font-medium">{mockChannelStats.email.sent}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Livrés</span>
                    <span className="font-medium text-green-600">{mockChannelStats.email.delivered}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-muted-foreground">Ouverts</span>
                    <span className="font-medium text-primary">{mockChannelStats.email.opened}</span>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Tabs */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab}>
          <TabsList>
            <TabsTrigger value="overview">Vue d'ensemble</TabsTrigger>
            <TabsTrigger value="create">Créer notification</TabsTrigger>
            <TabsTrigger value="history">Historique</TabsTrigger>
            <TabsTrigger value="settings">Paramètres</TabsTrigger>
          </TabsList>

          <TabsContent value="create" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Créer une nouvelle notification</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm font-medium mb-2 block">Titre de la notification</label>
                    <Input 
                      placeholder="Ex: Nouveau service disponible"
                      value={newNotification.title}
                      onChange={(e) => setNewNotification({...newNotification, title: e.target.value})}
                    />
                  </div>
                  <div>
                    <label className="text-sm font-medium mb-2 block">Cible</label>
                    <Select value={newNotification.target} onValueChange={(value) => setNewNotification({...newNotification, target: value})}>
                      <SelectTrigger>
                        <SelectValue placeholder="Sélectionner la cible" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all_users">Tous les utilisateurs</SelectItem>
                        <SelectItem value="clients">Clients seulement</SelectItem>
                        <SelectItem value="prestataires">Prestataires seulement</SelectItem>
                        <SelectItem value="admins">Administrateurs</SelectItem>
                        <SelectItem value="region_dakar">Région Dakar</SelectItem>
                        <SelectItem value="region_thies">Région Thiès</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div>
                  <label className="text-sm font-medium mb-2 block">Message</label>
                  <Textarea 
                    placeholder="Rédigez votre message ici..."
                    rows={4}
                    value={newNotification.message}
                    onChange={(e) => setNewNotification({...newNotification, message: e.target.value})}
                  />
                </div>

                <div>
                  <label className="text-sm font-medium mb-3 block">Canaux de diffusion</label>
                  <div className="flex gap-4">
                    <div className="flex items-center space-x-2">
                      <Switch id="push" />
                      <label htmlFor="push" className="flex items-center gap-2">
                        <Smartphone className="h-4 w-4" />
                        Push
                      </label>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Switch id="sms" />
                      <label htmlFor="sms" className="flex items-center gap-2">
                        <MessageSquare className="h-4 w-4" />
                        SMS
                      </label>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Switch id="email" />
                      <label htmlFor="email" className="flex items-center gap-2">
                        <Mail className="h-4 w-4" />
                        Email
                      </label>
                    </div>
                  </div>
                </div>

                <div className="flex items-center space-x-2">
                  <Switch id="scheduled" />
                  <label htmlFor="scheduled">Programmer l'envoi</label>
                </div>

                <div className="flex gap-3">
                  <Button className="bg-primary hover:bg-primary/90">
                    Envoyer maintenant
                  </Button>
                  <Button variant="outline">
                    Enregistrer comme brouillon
                  </Button>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="history" className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>Historique des notifications</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Notification</TableHead>
                      <TableHead>Type</TableHead>
                      <TableHead>Cible</TableHead>
                      <TableHead>Canaux</TableHead>
                      <TableHead>Destinataires</TableHead>
                      <TableHead>Statut</TableHead>
                      <TableHead>Date</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {mockNotifications.map((notification) => (
                      <TableRow key={notification.id}>
                        <TableCell>
                          <div>
                            <p className="font-medium">{notification.title}</p>
                            <p className="text-sm text-muted-foreground">{notification.message}</p>
                          </div>
                        </TableCell>
                        <TableCell>
                          <Badge variant="outline">{notification.type}</Badge>
                        </TableCell>
                        <TableCell>{notification.target}</TableCell>
                        <TableCell>
                          <div className="flex gap-1">
                            {notification.channels.map((channel, index) => (
                              <div key={index} className="p-1 bg-muted rounded">
                                {getChannelIcon(channel)}
                              </div>
                            ))}
                          </div>
                        </TableCell>
                        <TableCell>
                          <span className="font-medium">{notification.recipients}</span>
                        </TableCell>
                        <TableCell>
                          {getStatusBadge(notification.status)}
                        </TableCell>
                        <TableCell>
                          <span className="text-sm">{notification.createdAt}</span>
                        </TableCell>
                        <TableCell>
                          <div className="flex gap-2">
                            <Button size="sm" variant="outline">
                              <Eye className="h-3 w-3" />
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
          </TabsContent>

          <TabsContent value="settings" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Paramètres de notification</CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div>
                  <h3 className="font-semibold mb-3">Notifications automatiques</h3>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Nouvelles inscriptions</p>
                        <p className="text-sm text-muted-foreground">Notifier lors d'une nouvelle inscription prestataire</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Problèmes de paiement</p>
                        <p className="text-sm text-muted-foreground">Alerter en cas d'échec de transaction</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">Commandes urgentes</p>
                        <p className="text-sm text-muted-foreground">Diffuser immédiatement les demandes urgentes</p>
                      </div>
                      <Switch defaultChecked />
                    </div>
                  </div>
                </div>

                <div>
                  <h3 className="font-semibold mb-3">Limites d'envoi</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="text-sm font-medium mb-2 block">SMS par heure</label>
                      <Input type="number" defaultValue="100" />
                    </div>
                    <div>
                      <label className="text-sm font-medium mb-2 block">Emails par heure</label>
                      <Input type="number" defaultValue="500" />
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

export default Notifications;