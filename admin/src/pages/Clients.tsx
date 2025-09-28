import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Clients = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Gestion des Clients</h1>
          <p className="text-muted-foreground">Gérez tous vos clients et leurs informations</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Liste des Clients</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface de gestion des clients en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Clients;
