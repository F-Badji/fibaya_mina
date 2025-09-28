import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Securite = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Sécurité</h1>
          <p className="text-muted-foreground">Gérez la sécurité de votre plateforme</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Centre de sécurité</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface de sécurité en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Securite;
