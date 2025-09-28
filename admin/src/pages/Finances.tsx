import { useState } from "react";
import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { 
  CreditCard, TrendingUp, TrendingDown, DollarSign, Wallet, 
  Download, Filter, RefreshCw, AlertTriangle, CheckCircle, Clock 
} from "lucide-react";

const mockTransactions = [
  {
    id: "TRX001",
    type: "Commission",
    client: "Aminata Diallo",
    prestataire: "Ibrahima Diop",
    service: "Plomberie",
    amount: 25000,
    commission: 2500,
    paymentMethod: "Orange Money",
    status: "Validé",
    date: "2024-03-16 14:30"
  },
  {
    id: "TRX002",
    type: "Paiement",
    client: "Ousmane Fall",
    prestataire: "Moussa Ndiaye",
    service: "Électricité",
    amount: 18500,
    commission: 1850,
    paymentMethod: "Wave",
    status: "En cours",
    date: "2024-03-16 12:15"
  },
  {
    id: "TRX003",
    type: "Remboursement",
    client: "Fatou Sarr",
    prestataire: "Awa Sy",
    service: "Ménage",
    amount: 15000,
    commission: -1500,
    paymentMethod: "Free Money",
    status: "Échoué",
    date: "2024-03-16 09:45"
  }
];

const mockWallets = [
  {
    prestataire: "Ibrahima Diop",
    service: "Plomberie",
    balance: 156000,
    pendingPayouts: 23000,
    totalEarnings: 2340000,
    lastPayout: "2024-03-15"
  },
  {
    prestataire: "Moussa Ndiaye", 
    service: "Électricité",
    balance: 89000,
    pendingPayouts: 15000,
    totalEarnings: 1890000,
    lastPayout: "2024-03-14"
  },
  {
    prestataire: "Khadija Mbaye",
    service: "Coiffure",
    balance: 45000,
    pendingPayouts: 8000,
    totalEarnings: 567000,
    lastPayout: "2024-03-10"
  }
];

const Finances = () => {
  const [selectedTab, setSelectedTab] = useState("overview");

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "Validé":
        return <Badge className="bg-green-100 text-green-800 border-green-200">Validé</Badge>;
      case "En cours":
        return <Badge className="bg-orange-100 text-orange-800 border-orange-200">En cours</Badge>;
      case "Échoué":
        return <Badge className="bg-red-100 text-red-800 border-red-200">Échoué</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getPaymentMethodBadge = (method: string) => {
    const colors = {
      "Orange Money": "bg-orange-100 text-orange-800 border-orange-200",
      "Wave": "bg-blue-100 text-blue-800 border-blue-200", 
      "Free Money": "bg-purple-100 text-purple-800 border-purple-200",
      "Mixx by Yas": "bg-green-100 text-green-800 border-green-200"
    };
    return <Badge className={colors[method] || "bg-gray-100 text-gray-800"}>{method}</Badge>;
  };

  const totalRevenue = mockTransactions.reduce((sum, t) => sum + t.amount, 0);
  const totalCommissions = mockTransactions.reduce((sum, t) => sum + t.commission, 0);
  const totalPendingPayouts = mockWallets.reduce((sum, w) => sum + w.pendingPayouts, 0);

  return (
    <PageLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Gestion Financière</h1>
            <p className="text-muted-foreground">Supervisez tous les paiements, commissions et portefeuilles</p>
          </div>
          <div className="flex gap-3">
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Rapport financier
            </Button>
            <Button className="gap-2 bg-primary hover:bg-primary/90">
              <RefreshCw className="h-4 w-4" />
              Synchroniser
            </Button>
          </div>
        </div>

        {/* Financial Overview Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Chiffre d'affaires</p>
                  <p className="text-2xl font-bold text-primary">{totalRevenue.toLocaleString()} FCFA</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingUp className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+12.5% ce mois</span>
                  </div>
                </div>
                <div className="p-3 bg-primary rounded-lg">
                  <DollarSign className="h-5 w-5 text-primary-foreground" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-green-500/5 to-green-500/10 border-green-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Commissions FIBAYA</p>
                  <p className="text-2xl font-bold text-green-600">{totalCommissions.toLocaleString()} FCFA</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingUp className="h-3 w-3 text-green-600" />
                    <span className="text-xs text-green-600">+8.3% ce mois</span>
                  </div>
                </div>
                <div className="p-3 bg-green-500 rounded-lg">
                  <CreditCard className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-orange-500/5 to-orange-500/10 border-orange-500/20">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Paiements en attente</p>
                  <p className="text-2xl font-bold text-orange-600">{totalPendingPayouts.toLocaleString()} FCFA</p>
                  <div className="flex items-center gap-1 mt-1">
                    <Clock className="h-3 w-3 text-orange-600" />
                    <span className="text-xs text-orange-600">23 en attente</span>
                  </div>
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
                  <p className="text-sm text-muted-foreground">Transactions échouées</p>
                  <p className="text-2xl font-bold text-red-600">5</p>
                  <div className="flex items-center gap-1 mt-1">
                    <AlertTriangle className="h-3 w-3 text-red-600" />
                    <span className="text-xs text-red-600">Nécessite action</span>
                  </div>
                </div>
                <div className="p-3 bg-red-500 rounded-lg">
                  <AlertTriangle className="h-5 w-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Payment Methods Performance */}
        <Card>
          <CardHeader>
            <CardTitle>Performance des moyens de paiement</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-3 h-3 bg-orange-500 rounded-full"></div>
                  <span className="font-medium">Orange Money</span>
                </div>
                <p className="text-2xl font-bold">45%</p>
                <p className="text-sm text-muted-foreground">des transactions</p>
              </div>
              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                  <span className="font-medium">Wave</span>
                </div>
                <p className="text-2xl font-bold">32%</p>
                <p className="text-sm text-muted-foreground">des transactions</p>
              </div>
              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-3 h-3 bg-purple-500 rounded-full"></div>
                  <span className="font-medium">Free Money</span>
                </div>
                <p className="text-2xl font-bold">18%</p>
                <p className="text-sm text-muted-foreground">des transactions</p>
              </div>
              <div className="p-4 border rounded-lg">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                  <span className="font-medium">Mixx by Yas</span>
                </div>
                <p className="text-2xl font-bold">5%</p>
                <p className="text-sm text-muted-foreground">des transactions</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Tabs for different views */}
        <Tabs value={selectedTab} onValueChange={setSelectedTab}>
          <TabsList>
            <TabsTrigger value="overview">Vue d'ensemble</TabsTrigger>
            <TabsTrigger value="transactions">Transactions</TabsTrigger>
            <TabsTrigger value="wallets">Portefeuilles</TabsTrigger>
            <TabsTrigger value="payouts">Virements</TabsTrigger>
          </TabsList>

          <TabsContent value="transactions" className="space-y-4">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle>Transactions récentes</CardTitle>
                  <Button variant="outline" className="gap-2">
                    <Filter className="h-4 w-4" />
                    Filtrer
                  </Button>
                </div>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Transaction</TableHead>
                      <TableHead>Client - Prestataire</TableHead>
                      <TableHead>Service</TableHead>
                      <TableHead>Montant</TableHead>
                      <TableHead>Commission</TableHead>
                      <TableHead>Méthode</TableHead>
                      <TableHead>Statut</TableHead>
                      <TableHead>Date</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {mockTransactions.map((transaction) => (
                      <TableRow key={transaction.id}>
                        <TableCell>
                          <div>
                            <p className="font-medium">{transaction.id}</p>
                            <p className="text-sm text-muted-foreground">{transaction.type}</p>
                          </div>
                        </TableCell>
                        <TableCell>
                          <div>
                            <p className="text-sm">{transaction.client}</p>
                            <p className="text-sm text-muted-foreground">→ {transaction.prestataire}</p>
                          </div>
                        </TableCell>
                        <TableCell>{transaction.service}</TableCell>
                        <TableCell>
                          <span className="font-semibold">{transaction.amount.toLocaleString()} FCFA</span>
                        </TableCell>
                        <TableCell>
                          <span className={`font-semibold ${transaction.commission > 0 ? 'text-green-600' : 'text-red-600'}`}>
                            {transaction.commission > 0 ? '+' : ''}{transaction.commission.toLocaleString()} FCFA
                          </span>
                        </TableCell>
                        <TableCell>
                          {getPaymentMethodBadge(transaction.paymentMethod)}
                        </TableCell>
                        <TableCell>
                          {getStatusBadge(transaction.status)}
                        </TableCell>
                        <TableCell>
                          <span className="text-sm">{transaction.date}</span>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="wallets" className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>Portefeuilles des prestataires</CardTitle>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Prestataire</TableHead>
                      <TableHead>Service</TableHead>
                      <TableHead>Solde disponible</TableHead>
                      <TableHead>En attente</TableHead>
                      <TableHead>Total gagné</TableHead>
                      <TableHead>Dernier virement</TableHead>
                      <TableHead>Actions</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {mockWallets.map((wallet, index) => (
                      <TableRow key={index}>
                        <TableCell>
                          <p className="font-medium">{wallet.prestataire}</p>
                        </TableCell>
                        <TableCell>{wallet.service}</TableCell>
                        <TableCell>
                          <span className="font-semibold text-primary">
                            {wallet.balance.toLocaleString()} FCFA
                          </span>
                        </TableCell>
                        <TableCell>
                          <span className="font-semibold text-orange-600">
                            {wallet.pendingPayouts.toLocaleString()} FCFA
                          </span>
                        </TableCell>
                        <TableCell>
                          <span className="font-semibold">
                            {wallet.totalEarnings.toLocaleString()} FCFA
                          </span>
                        </TableCell>
                        <TableCell>{wallet.lastPayout}</TableCell>
                        <TableCell>
                          <div className="flex gap-2">
                            <Button size="sm" variant="outline">
                              Virer
                            </Button>
                            <Button size="sm" variant="outline">
                              Historique
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
        </Tabs>
      </div>
    </PageLayout>
  );
};

export default Finances;