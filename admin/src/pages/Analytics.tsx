import { useState } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Progress } from "@/components/ui/progress";
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  LineChart, Line, PieChart, Pie, Cell, AreaChart, Area
} from 'recharts';
import { 
  TrendingUp, Users, Clock, Star, MapPin, Calendar, 
  Download, Filter, RefreshCw 
} from "lucide-react";

const monthlyData = [
  { month: 'Jan', commandes: 1200, revenus: 18500000, clients: 450, prestataires: 89 },
  { month: 'Fév', commandes: 1450, revenus: 21200000, clients: 523, prestataires: 105 },
  { month: 'Mar', commandes: 1680, revenus: 24800000, clients: 612, prestataires: 124 },
  { month: 'Avr', commandes: 1920, revenus: 28500000, clients: 698, prestataires: 142 },
  { month: 'Mai', commandes: 2150, revenus: 32100000, clients: 789, prestataires: 156 },
  { month: 'Jun', commandes: 2380, revenus: 35600000, clients: 856, prestataires: 168 }
];

const serviceData = [
  { name: 'Plomberie', value: 35, color: '#065b32' },
  { name: 'Électricité', value: 28, color: '#10b981' },
  { name: 'Ménage', value: 20, color: '#f59e0b' },
  { name: 'Mécanique', value: 12, color: '#ef4444' },
  { name: 'Autres', value: 5, color: '#6b7280' }
];

const regionData = [
  { region: 'Dakar', clients: 1250, prestataires: 89, commandes: 3420 },
  { region: 'Thiès', clients: 450, prestataires: 34, commandes: 1280 },
  { region: 'Saint-Louis', clients: 320, prestataires: 23, commandes: 890 },
  { region: 'Kaolack', clients: 280, prestataires: 19, commandes: 740 },
  { region: 'Ziguinchor', clients: 190, prestataires: 12, commandes: 520 }
];

const hourlyData = [
  { hour: '6h', commandes: 12 },
  { hour: '8h', commandes: 45 },
  { hour: '10h', commandes: 89 },
  { hour: '12h', commandes: 156 },
  { hour: '14h', commandes: 203 },
  { hour: '16h', commandes: 178 },
  { hour: '18h', commandes: 134 },
  { hour: '20h', commandes: 87 },
  { hour: '22h', commandes: 43 }
];

const Analytics = () => {
  const [selectedPeriod, setSelectedPeriod] = useState("6months");
  const [selectedTab, setSelectedTab] = useState("overview");

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Analytics & Rapports</h1>
            <p className="text-muted-foreground">Analysez les performances et tendances de votre plateforme</p>
          </div>
          <div className="flex gap-3">
            <Select value={selectedPeriod} onValueChange={setSelectedPeriod}>
              <SelectTrigger className="w-40">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="7days">7 derniers jours</SelectItem>
                <SelectItem value="30days">30 derniers jours</SelectItem>
                <SelectItem value="3months">3 derniers mois</SelectItem>
                <SelectItem value="6months">6 derniers mois</SelectItem>
                <SelectItem value="1year">1 an</SelectItem>
              </SelectContent>
            </Select>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Exporter
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <RefreshCw className="h-4 w-4" />
              Actualiser
            </Button>
          </div>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Taux de conversion</p>
                  <p className="text-2xl font-bold text-primary">78.5%</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingUp className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+3.2% vs mois dernier</span>
                  </div>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <TrendingUp className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Satisfaction moyenne</p>
                  <p className="text-2xl font-bold text-green-600">4.7/5</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Star className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+0.2 vs mois dernier</span>
                  </div>
                </div>
                <div className="p-3 bg-green-500 rounded-lg">
                  <Star className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-500/5 to-orange-500/10 border-orange-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Temps de réponse moyen</p>
                  <p className="text-2xl font-bold text-orange-600">15 min</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Clock className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">-2 min vs mois dernier</span>
                  </div>
                </div>
                <div className="p-3 bg-orange-500 rounded-lg">
                  <Clock className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-blue-500/5 to-blue-500/10 border-blue-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Taux de rétention</p>
                  <p className="text-2xl font-bold text-blue-600">85.2%</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Users className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+1.8% vs mois dernier</span>
                  </div>
                </div>
                <div className="p-3 bg-blue-500 rounded-lg">
                  <Users className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Analytics Tabs */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab}>
          <TabsList className="grid w-full grid-cols-4">
            <TabsTrigger value="overview">Vue d'ensemble</TabsTrigger>
            <TabsTrigger value="users">Utilisateurs</TabsTrigger>
            <TabsTrigger value="services">Services</TabsTrigger>
            <TabsTrigger value="geography">Géographie</TabsTrigger>
          </TabsList>

          <TabsContent value="overview" className="space-y-6">
            {/* Revenue and Orders Chart */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle>Évolution du chiffre d'affaires</CardTitle>
                </CardHeader>
                <CardContent>
                  <ResponsiveContainer width="100%" height={300}>
                    <AreaChart data={monthlyData}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="month" />
                      <YAxis />
                      <Tooltip formatter={(value) => [`${value.toLocaleString()} FCFA`, 'Revenus']} />
                      <Area type="monotone" dataKey="revenus" stroke="#065b32" fill="#065b32" fillOpacity={0.1} />
                    </AreaChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Commandes par mois</CardTitle>
                </CardHeader>
                <CardContent>
                  <ResponsiveContainer width="100%" height={300}>
                    <BarChart data={monthlyData}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="month" />
                      <YAxis />
                      <Tooltip />
                      <Bar dataKey="commandes" fill="#10b981" />
                    </BarChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>
            </div>

            {/* Hourly Activity */}
            <Card>
              <CardHeader>
                <CardTitle>Activité par heure</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width="100%" height={250}>
                  <LineChart data={hourlyData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="hour" />
                    <YAxis />
                    <Tooltip />
                    <Line type="monotone" dataKey="commandes" stroke="#065b32" strokeWidth={3} />
                  </LineChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="users" className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle>Croissance des utilisateurs</CardTitle>
                </CardHeader>
                <CardContent>
                  <ResponsiveContainer width="100%" height={300}>
                    <LineChart data={monthlyData}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="month" />
                      <YAxis />
                      <Tooltip />
                      <Line type="monotone" dataKey="clients" stroke="#065b32" strokeWidth={2} name="Clients" />
                      <Line type="monotone" dataKey="prestataires" stroke="#10b981" strokeWidth={2} name="Prestataires" />
                    </LineChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Segmentation des utilisateurs</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <div className="flex justify-between mb-2">
                        <span className="text-sm">Nouveaux utilisateurs</span>
                        <span className="text-sm font-medium">68%</span>
                      </div>
                      <Progress value={68} className="h-2" />
                    </div>
                    <div>
                      <div className="flex justify-between mb-2">
                        <span className="text-sm">Utilisateurs récurrents</span>
                        <span className="text-sm font-medium">32%</span>
                      </div>
                      <Progress value={32} className="h-2" />
                    </div>
                    <div>
                      <div className="flex justify-between mb-2">
                        <span className="text-sm">Utilisateurs actifs</span>
                        <span className="text-sm font-medium">85%</span>
                      </div>
                      <Progress value={85} className="h-2" />
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="services" className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle>Répartition des services</CardTitle>
                </CardHeader>
                <CardContent>
                  <ResponsiveContainer width="100%" height={300}>
                    <PieChart>
                      <Pie
                        data={serviceData}
                        cx="50%"
                        cy="50%"
                        labelLine={false}
                        label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                        outerRadius={80}
                        fill="#8884d8"
                        dataKey="value"
                      >
                        {serviceData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Pie>
                      <Tooltip />
                    </PieChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle>Performance par service</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {serviceData.map((service, index) => (
                      <div key={index} className="flex items-center justify-between p-3 border rounded-lg">
                        <div className="flex items-center gap-3">
                          <div 
                            className="w-4 h-4 rounded-full" 
                            style={{ backgroundColor: service.color }}
                          ></div>
                          <span className="font-medium">{service.name}</span>
                        </div>
                        <div className="text-right">
                          <p className="font-semibold">{service.value}%</p>
                          <p className="text-xs text-muted-foreground">du total</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="geography" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Répartition géographique</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {regionData.map((region, index) => (
                    <div key={index} className="p-4 border rounded-lg hover:shadow-md transition-shadow">
                      <div className="flex items-center gap-2 mb-3">
                        <MapPin className="h-4 w-4 text-primary" />
                        <h3 className="font-semibold">{region.region}</h3>
                      </div>
                      <div className="space-y-2">
                        <div className="flex justify-between">
                          <span className="text-sm text-muted-foreground">Clients</span>
                          <span className="font-medium">{region.clients}</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm text-muted-foreground">Prestataires</span>
                          <span className="font-medium">{region.prestataires}</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm text-muted-foreground">Commandes</span>
                          <span className="font-medium text-primary">{region.commandes}</span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </PageLayout>
  );
};

export default Analytics;