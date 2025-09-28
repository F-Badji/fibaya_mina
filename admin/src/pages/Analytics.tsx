import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Analytics = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Analytics</h1>
          <p className="text-muted-foreground">Analysez les performances de votre plateforme</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Tableau de bord analytique</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface d'analytics en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Analytics;
