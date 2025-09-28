import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Finances = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Gestion Financière</h1>
          <p className="text-muted-foreground">Suivez les revenus et les transactions</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Tableau de bord financier</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface financière en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Finances;
