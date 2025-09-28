import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Notifications = () => {
  return (
    <PageLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Notifications</h1>
          <p className="text-muted-foreground">Gérez les notifications système</p>
        </div>
        
        <Card>
          <CardHeader>
            <CardTitle>Centre de notifications</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">Interface de notifications en cours de développement...</p>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default Notifications;
