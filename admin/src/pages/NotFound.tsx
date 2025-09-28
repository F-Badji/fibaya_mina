import { PageLayout } from "@/components/PageLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { Home } from "lucide-react";

const NotFound = () => {
  const navigate = useNavigate();

  return (
    <PageLayout>
      <div className="flex items-center justify-center min-h-[60vh]">
        <Card className="w-full max-w-md">
          <CardHeader className="text-center">
            <CardTitle className="text-6xl font-bold text-muted-foreground">404</CardTitle>
            <h2 className="text-2xl font-semibold">Page non trouvée</h2>
          </CardHeader>
          <CardContent className="text-center space-y-4">
            <p className="text-muted-foreground">
              La page que vous recherchez n'existe pas ou a été déplacée.
            </p>
            <Button onClick={() => navigate("/")} className="gap-2">
              <Home className="h-4 w-4" />
              Retour à l'accueil
            </Button>
          </CardContent>
        </Card>
      </div>
    </PageLayout>
  );
};

export default NotFound;