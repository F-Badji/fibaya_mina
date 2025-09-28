import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Geographie = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Géographie</h1>
          <p className="text-muted-foreground">Gérez les zones géographiques et la couverture</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Carte de couverture</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface géographique en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Geographie;
