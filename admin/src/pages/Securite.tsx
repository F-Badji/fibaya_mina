import { useState } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Switch } from "@/components/ui/switch";
import { Progress } from "@/components/ui/progress";
import { 
  Shield, AlertTriangle, Eye, Ban, CheckCircle, XCircle, 
  Users, FileText, Lock, Activity, Settings, Scan 
} from "lucide-react";

const mockSecurityEvents = [
  {
    id: "SEC001",
    type: "Tentative de fraude",
    description: "Tentative de création de compte avec faux documents",
    severity: "Élevé",
    user: "user_12345@email.com",
    timestamp: "2024-03-16 14:30",
    status: "Bloqué",
    ip: "192.168.1.100"
  },
  {
    id: "SEC002",
    type: "Connexions multiples",
    description: "Connexions simultanées depuis 5 appareils différents",
    severity: "Moyen",
    user: "Aminata Diallo",
    timestamp: "2024-03-16 12:15",
    status: "Surveillé",
    ip: "10.0.0.45"
  },
  {
    id: "SEC003",
    type: "Transaction suspecte",
    description: "Montant anormalement élevé pour ce prestataire",
    severity: "Moyen",
    user: "Ibrahima Diop",
    timestamp: "2024-03-16 09:45",
    status: "Validé",
    ip: "172.16.0.23"
  }
];

const mockVulnerabilities = [
  {
    category: "Authentification",
    issues: [
      { name: "Mots de passe faibles", count: 23, severity: "Moyen" },
      { name: "Comptes sans 2FA", count: 156, severity: "Faible" }
    ]
  },
  {
    category: "Données",
    issues: [
      { name: "Documents non vérifiés", count: 12, severity: "Élevé" },
      { name: "Données personnelles exposées", count: 3, severity: "Critique" }
    ]
  },
  {
    category: "Accès",
    issues: [
      { name: "Sessions expirées non fermées", count: 45, severity: "Faible" },
      { name: "Tentatives de connexion anormales", count: 8, severity: "Moyen" }
    ]
  }
];

const mockAdminLogs = [
  {
    admin: "Admin Principal",
    action: "Validation prestataire",
    target: "Khadija Mbaye",
    timestamp: "2024-03-16 16:45",
    ip: "192.168.1.2"
  },
  {
    admin: "Admin Finance",
    action: "Modification commission",
    target: "Paramètres globaux",
    timestamp: "2024-03-16 14:20",
    ip: "192.168.1.3"
  },
  {
    admin: "Admin Support",
    action: "Suspension compte",
    target: "Utilisateur suspect",
    timestamp: "2024-03-16 11:30",
    ip: "192.168.1.4"
  }
];

const Securite = () => {
  const [selectedTab, setSelectedTab] = useState("overview");

  const getSeverityBadge = (severity: string) => {
    switch (severity) {
      case "Critique":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Critique</Badge>;
      case "Élevé":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Élevé</Badge>;
      case "Moyen":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">Moyen</Badge>;
      case "Faible":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Faible</Badge>;
      default:
        return <Badge variant="outline">{severity}</Badge>;
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "Bloqué":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Bloqué</Badge>;
      case "Surveillé":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">Surveillé</Badge>;
      case "Validé":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Validé</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const totalThreats = mockSecurityEvents.length;
  const blockedThreats = mockSecurityEvents.filter(e => e.status === "Bloqué").length;
  const criticalIssues = mockVulnerabilities.flatMap(v => v.issues).filter(i => i.severity === "Critique").length;

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Sécurité & Surveillance</h1>
            <p className="text-muted-foreground">Surveillez et protégez votre plateforme contre les menaces</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Scan className="h-4 w-4" />
              Scan de sécurité
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <Settings className="h-4 w-4" />
              Paramètres sécurité
            </Button>
          </div>
        </div>

        {/* Security Overview Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Score de sécurité</p>
                  <p className="text-2xl font-bold text-green-600">87%</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Shield className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">Bon niveau</span>
                  </div>
                </div>
                <div className="p-3 bg-green-500 rounded-lg">
                  <Shield className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-red-500/5 to-red-500/10 border-red-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Menaces bloquées</p>
                  <p className="text-2xl font-bold text-red-600">{blockedThreats}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Ban className="h-3 w-3 text-red-600" />
                    <span className="text-xs text-red-600">Dernières 24h</span>
                  </div>
                </div>
                <div className="p-3 bg-red-500 rounded-lg">
                  <Ban className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-500/5 to-orange-500/10 border-orange-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Alertes actives</p>
                  <p className="text-2xl font-bold text-orange-600">{totalThreats}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <AlertTriangle className="h-3 w-3 text-orange-600" />
                    <span className="text-xs text-orange-600">À examiner</span>
                  </div>
                </div>
                <div className="p-3 bg-orange-500 rounded-lg">
                  <AlertTriangle className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Comptes vérifiés</p>
                  <p className="text-2xl font-bold text-primary">92%</p>
                  <div className="flex items-center gap-1 mt-1">
                    <CheckCircle className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+3% ce mois</span>
                  </div>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <Users className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Security Status */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader>
              <CardTitle>Évaluation de la sécurité</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <div className="flex justify-between mb-2">
                    <span className="text-sm">Authentification</span>
                    <span className="text-sm font-medium">95%</span>
                  </div>
                  <Progress value={95} className="h-2" />
                </div>
                <div>
                  <div className="flex justify-between mb-2">
                    <span className="text-sm">Protection des données</span>
                    <span className="text-sm font-medium">88%</span>
                  </div>
                  <Progress value={88} className="h-2" />
                </div>
                <div>
                  <div className="flex justify-between mb-2">
                    <span className="text-sm">Contrôle d'accès</span>
                    <span className="text-sm font-medium">92%</span>
                  </div>
                  <Progress value={92} className="h-2" />
                </div>
                <div>
                  <div className="flex justify-between mb-2">
                    <span className="text-sm">Surveillance réseau</span>
                    <span className="text-sm font-medium">78%</span>
                  </div>
                  <Progress value={78} className="h-2" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Paramètres de sécurité</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Double authentification obligatoire</p>
                  <p className="text-sm text-muted-foreground">Pour tous les administrateurs</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Détection automatique de fraude</p>
                  <p className="text-sm text-muted-foreground">Analyse comportementale en temps réel</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Chiffrement des communications</p>
                  <p className="text-sm text-muted-foreground">SSL/TLS pour toutes les connexions</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Logs d'activité détaillés</p>
                  <p className="text-sm text-muted-foreground">Enregistrement de toutes les actions</p>
                </div>
                <Switch defaultChecked />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Tabs */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab}>
          <TabsList>
            <TabsTrigger value="overview">Vue d'ensemble</TabsTrigger>
            <TabsTrigger value="threats">Menaces</TabsTrigger>
            <TabsTrigger value="vulnerabilities">Vulnérabilités</TabsTrigger>
            <TabsTrigger value="logs">Logs admin</TabsTrigger>
          </TabsList>

          <TabsContent value="threats" className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>Événements de sécurité récents</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Événement</TableHead>
                      <TableHead>Type</TableHead>
                      <TableHead>Utilisateur</TableHead>
                      <TableHead>Sévérité</TableHead>
                      <TableHead>Statut</TableHead>
                      <TableHead>Date/Heure</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {mockSecurityEvents.map((event) => (
                      <TableRow key={event.id}>
                        <TableCell>
                          <div>
                            <p className="font-medium">{event.type}</p>
                            <p className="text-sm text-muted-foreground">{event.description}</p>
                          </div>
                        </TableCell>
                        <TableCell>
                          <Badge variant="outline">{event.type}</Badge>
                        </TableCell>
                        <TableCell>
                          <div>
                            <p className="font-medium">{event.user}</p>
                            <p className="text-xs text-muted-foreground">IP: {event.ip}</p>
                          </div>
                        </TableCell>
                        <TableCell>
                          {getSeverityBadge(event.severity)}
                        </TableCell>
                        <TableCell>
                          {getStatusBadge(event.status)}
                        </TableCell>
                        <TableCell>
                          <span className="text-sm">{event.timestamp}</span>
                        </TableCell>
                        <TableCell>
                          <div className="flex gap-2">
                            <Button size="sm" variant="outline">
                              <Eye className="h-3 w-3" />
                            </Button>
                            <Button size="sm" variant="outline">
                              <Ban className="h-3 w-3" />
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

          <TabsContent value="vulnerabilities" className="space-y-4">
            <div className="grid grid-cols-1 gap-4">
              {mockVulnerabilities.map((category, index) => (
                <Card key={index}>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Lock className="h-5 w-5" />
                      {category.category}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-3">
                      {category.issues.map((issue, issueIndex) => (
                        <div key={issueIndex} className="flex items-center justify-between p-3 border rounded-lg">
                          <div className="flex-1">
                            <p className="font-medium">{issue.name}</p>
                            <p className="text-sm text-muted-foreground">{issue.count} occurrences</p>
                          </div>
                          <div className="flex items-center gap-3">
                            {getSeverityBadge(issue.severity)}
                            <Button size="sm" variant="outline">
                              Corriger
                            </Button>
                          </div>
                        </div>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="logs" className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>Logs d'activité des administrateurs</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Administrateur</TableHead>
                      <TableHead>Action</TableHead>
                      <TableHead>Cible</TableHead>
                      <TableHead>Date/Heure</TableHead>
                      <TableHead>Adresse IP</TableHead>
                      <TableHead>Détails</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {mockAdminLogs.map((log, index) => (
                      <TableRow key={index}>
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center">
                              <Users className="h-4 w-4 text-primary-foreground" />
                            </div>
                            {log.admin}
                          </div>
                        </TableCell>
                        <TableCell>
                          <Badge variant="outline">{log.action}</Badge>
                        </TableCell>
                        <TableCell>{log.target}</TableCell>
                        <TableCell>{log.timestamp}</TableCell>
                        <TableCell>
                          <code className="text-xs bg-muted px-2 py-1 rounded">{log.ip}</code>
                        </TableCell>
                        <TableCell>
                          <Button size="sm" variant="outline">
                            <Eye className="h-3 w-3" />
                          </Button>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </PageLayout>
  );
};

export default Securite;