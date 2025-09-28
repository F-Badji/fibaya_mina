import { StatsCard } from "./StatsCard";
import { Users, UserCheck, CreditCard, TrendingUp, AlertTriangle, Clock } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";

const mockStats = {
  totalClients: 2847,
  totalPrestataires: 1253,
  todayRevenue: 45230,
  activeOrders: 186,
  pendingValidations: 23,
  systemAlerts: 5
};

const mockRecentOrders = [
  {
    id: "CMD-2024-001",
    client: "Aminata Diallo",
    service: "Plomberie",
    prestataire: "Mamadou Sow",
    amount: 25000,
    status: "En cours",
    time: "Il y a 5 min"
  },
  {
    id: "CMD-2024-002",
    client: "Ousmane Fall",
    service: "Électricité",
    prestataire: "Cheikh Ndiaye",
    amount: 18500,
    status: "Terminé",
    time: "Il y a 12 min"
  },
  {
    id: "CMD-2024-003",
    client: "Fatou Sarr",
    service: "Ménage",
    prestataire: "Aïssatou Ba",
    amount: 15000,
    status: "En attente",
    time: "Il y a 18 min"
  }
];

const mockPendingPrestataires = [
  {
    id: "PREST-001",
    name: "Ibrahima Diop",
    service: "Maçonnerie",
    location: "Dakar",
    registeredAt: "Il y a 2h",
    documents: { ci: true, diplome: true, cv: false }
  },
  {
    id: "PREST-002",
    name: "Khadija Mbaye",
    service: "Coiffure",
    location: "Thiès",
    registeredAt: "Il y a 4h",
    documents: { ci: true, diplome: false, cv: true }
  }
];

export function Dashboard() {
  const getStatusBadge = (status: string) => {
    switch (status) {
      case "En cours":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">En cours</Badge>;
      case "Terminé":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Terminé</Badge>;
      case "En attente":
        return <Badge variant="outline">En attente</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  return (
    <div className="space-y-6">
      {/* Welcome Section */}
      <div className="bg-gradient-to-r from-primary to-primary/80 p-6 rounded-xl text-primary-foreground">
        <h1 className="text-2xl font-bold mb-2">Tableau de bord FIBAYA</h1>
        <p className="opacity-90">Gérez et supervisez l'ensemble de votre écosystème</p>
        <div className="mt-4 text-sm opacity-80">
          Dernière mise à jour: {new Date().toLocaleString('fr-FR')}
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
        <StatsCard
          title="Total Clients"
          value={mockStats.totalClients.toLocaleString()}
          change="+12% ce mois"
          changeType="positive"
          icon={<Users className="h-4 w-4" />}
          gradient
        />
        <StatsCard
          title="Prestataires"
          value={mockStats.totalPrestataires.toLocaleString()}
          change="+8% ce mois"
          changeType="positive"
          icon={<UserCheck className="h-4 w-4" />}
          variant="success"
        />
        <StatsCard
          title="Revenus du jour"
          value={`${mockStats.todayRevenue.toLocaleString()} FCFA`}
          change="+5.2% vs hier"
          changeType="positive"
          icon={<CreditCard className="h-4 w-4" />}
          variant="success"
        />
        <StatsCard
          title="Commandes actives"
          value={mockStats.activeOrders}
          change="23 nouvelles"
          changeType="positive"
          icon={<TrendingUp className="h-4 w-4" />}
        />
        <StatsCard
          title="En attente validation"
          value={mockStats.pendingValidations}
          change="Nécessite action"
          changeType="negative"
          icon={<Clock className="h-4 w-4" />}
          variant="warning"
        />
        <StatsCard
          title="Alertes système"
          value={mockStats.systemAlerts}
          change="2 critiques"
          changeType="negative"
          icon={<AlertTriangle className="h-4 w-4" />}
          variant="danger"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Orders */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center justify-between">
              Commandes récentes
              <Button variant="outline" size="sm">Voir tout</Button>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {mockRecentOrders.map((order) => (
                <div key={order.id} className="flex items-center justify-between p-3 border rounded-lg">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <span className="font-medium text-sm">{order.id}</span>
                      {getStatusBadge(order.status)}
                    </div>
                    <p className="text-sm text-muted-foreground">
                      {order.client} → {order.prestataire}
                    </p>
                    <p className="text-xs text-muted-foreground">{order.service}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold text-primary">
                      {order.amount.toLocaleString()} FCFA
                    </p>
                    <p className="text-xs text-muted-foreground">{order.time}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Pending Validations */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center justify-between">
              Prestataires en attente
              <Button variant="outline" size="sm">Gérer</Button>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {mockPendingPrestataires.map((prestataire) => (
                <div key={prestataire.id} className="p-3 border rounded-lg">
                  <div className="flex items-center justify-between mb-2">
                    <div>
                      <p className="font-medium">{prestataire.name}</p>
                      <p className="text-sm text-muted-foreground">
                        {prestataire.service} • {prestataire.location}
                      </p>
                    </div>
                    <span className="text-xs text-muted-foreground">
                      {prestataire.registeredAt}
                    </span>
                  </div>
                  
                  <div className="flex items-center gap-4 mb-3">
                    <div className="flex items-center gap-2 text-xs">
                      <div className={`w-2 h-2 rounded-full ${prestataire.documents.ci ? 'bg-green-500' : 'bg-muted'}`}></div>
                      CI
                    </div>
                    <div className="flex items-center gap-2 text-xs">
                      <div className={`w-2 h-2 rounded-full ${prestataire.documents.diplome ? 'bg-green-500' : 'bg-muted'}`}></div>
                      Diplôme
                    </div>
                    <div className="flex items-center gap-2 text-xs">
                      <div className={`w-2 h-2 rounded-full ${prestataire.documents.cv ? 'bg-green-500' : 'bg-muted'}`}></div>
                      CV
                    </div>
                  </div>

                  <div className="flex gap-2">
                    <Button size="sm" className="flex-1 bg-green-600 hover:bg-green-700">
                      Valider
                    </Button>
                    <Button size="sm" variant="outline" className="flex-1">
                      Examiner
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Performance Overview */}
      <Card>
        <CardHeader>
          <CardTitle>Performance de la plateforme</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm text-muted-foreground">Taux de satisfaction</span>
                <span className="text-sm font-medium">92%</span>
              </div>
              <Progress value={92} className="h-2" />
            </div>
            <div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm text-muted-foreground">Temps de réponse moyen</span>
                <span className="text-sm font-medium">15 min</span>
              </div>
              <Progress value={85} className="h-2" />
            </div>
            <div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm text-muted-foreground">Taux de conversion</span>
                <span className="text-sm font-medium">78%</span>
              </div>
              <Progress value={78} className="h-2" />
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
