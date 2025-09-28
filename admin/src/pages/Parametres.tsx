import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Parametres = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Paramètres</h1>
          <p className="text-muted-foreground">Configurez votre plateforme</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Configuration système</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface de paramètres en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Parametres;
