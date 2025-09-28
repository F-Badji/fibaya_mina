import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { ArrowLeft, Phone, MessageCircle, Clock, MapPin, Navigation, ShoppingCart, Home, Building2 } from "lucide-react";
import { services } from "@/data/services";

const MapView = () => {
  const { serviceId } = useParams();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const serviceType = searchParams.get('type');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedType, setSelectedType] = useState(serviceType || '');
  const selectedService = services.find(s => s.id === serviceId);

  // Mock provider data
  const mockProvider = {
    name: "Jean Dupont",
    rating: 4.8,
    distance: 1.2,
    eta: 8,
    price: "25€/h",
    phone: "+33123456789"
  };

  const handleTypeSelection = (type: string) => {
    setSelectedType(type);
    setIsDialogOpen(false);
    // Ici on peut ajouter la logique pour traiter la commande
  };

  return (
    <div className="min-h-screen bg-background relative">
      {/* Header */}
      <div className="bg-gradient-hero text-white p-4 relative z-20">
        <div className="flex items-center gap-3">
          <Button 
            variant="ghost" 
            size="icon"
            onClick={() => navigate(-1)}
            className="text-white hover:bg-white/20"
          >
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <div className="flex-1">
            <h1 className="text-lg font-bold">{selectedService?.name}</h1>
            <p className="text-white/80 text-sm">Prestataire à proximité</p>
          </div>
          <Badge className="bg-success text-white border-0">
            En ligne
          </Badge>
        </div>
      </div>

      {/* Map Mockup */}
      <div className="relative h-96 bg-gradient-to-br from-muted to-muted/50">
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-center text-muted-foreground">
            <MapPin className="h-12 w-12 mx-auto mb-2 text-primary" />
            <p className="text-sm">Carte de géolocalisation</p>
            <p className="text-xs">Intégration Maps à venir</p>
          </div>
        </div>

        {/* Provider Location Pin */}
        <div className="absolute top-24 left-1/2 transform -translate-x-1/2 animate-bounce">
          <div className="bg-success w-6 h-6 rounded-full border-2 border-white shadow-lg flex items-center justify-center">
            <div className="w-2 h-2 bg-white rounded-full" />
          </div>
        </div>

        {/* User Location Pin */}
        <div className="absolute bottom-24 right-16 animate-pulse">
          <div className="bg-primary w-6 h-6 rounded-full border-2 border-white shadow-lg flex items-center justify-center">
            <div className="w-2 h-2 bg-white rounded-full" />
          </div>
        </div>

        {/* Route Line Mockup */}
        <div className="absolute top-32 left-1/2 w-32 h-24 border-2 border-dashed border-success/60 rounded-lg transform -translate-x-6" />
      </div>

      {/* Provider Info Card */}
      <div className="p-4 relative z-10 -mt-6">
        <Card className="shadow-primary animate-slide-up">
          <CardContent className="p-4">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-12 h-12 bg-gradient-primary rounded-full flex items-center justify-center text-white text-xl">
                {selectedService?.icon}
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-lg">{mockProvider.name}</h3>
                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                  <span>⭐ {mockProvider.rating}</span>
                  <span>•</span>
                  <span>{mockProvider.price}</span>
                </div>
              </div>
              <Badge className="bg-online text-white border-0 animate-pulse-glow">
                🟢 En ligne
              </Badge>
            </div>

            <div className="grid grid-cols-2 gap-4 mb-4">
              <div className="text-center p-3 bg-muted rounded-lg">
                <MapPin className="h-5 w-5 mx-auto mb-1 text-success" />
                <p className="text-sm font-medium">{mockProvider.distance} km</p>
                <p className="text-xs text-muted-foreground">Distance</p>
              </div>
              <div className="text-center p-3 bg-muted rounded-lg">
                <Clock className="h-5 w-5 mx-auto mb-1 text-primary" />
                <p className="text-sm font-medium">{mockProvider.eta} min</p>
                <p className="text-xs text-muted-foreground">Temps d'arrivée</p>
              </div>
            </div>

            {/* Countdown Timer */}
            <div className="bg-gradient-primary text-white p-3 rounded-lg mb-4 text-center">
              <div className="text-2xl font-bold animate-pulse">07:42</div>
              <p className="text-sm text-white/80">Temps restant estimé</p>
            </div>

            <div className="grid grid-cols-2 gap-2 mb-4">
              <Button className="bg-success hover:bg-success/90">
                <Phone className="h-4 w-4 mr-2" />
                Appel gratuit
              </Button>
              <Button variant="outline" className="border-primary text-primary hover:bg-primary hover:text-white">
                <MessageCircle className="h-4 w-4 mr-2" />
                Message
              </Button>
            </div>

            {/* Commander Button with Dialog */}
            <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
              <DialogTrigger asChild>
                <Button className="w-full bg-gradient-primary hover:opacity-90 shadow-primary text-lg py-3">
                  <ShoppingCart className="h-5 w-5 mr-2" />
                  Commander maintenant
                </Button>
              </DialogTrigger>
              <DialogContent className="sm:max-w-md bg-card border-0 shadow-2xl">
                <DialogHeader>
                  <DialogTitle className="text-center text-xl font-bold text-primary mb-4">
                    Choisissez votre option
                  </DialogTitle>
                </DialogHeader>
                <div className="space-y-3">
                  <Button
                    onClick={() => handleTypeSelection('domicile')}
                    variant="outline"
                    className="w-full h-16 border-success text-success hover:bg-success hover:text-white transition-all duration-300 transform hover:scale-105"
                  >
                    <div className="flex items-center justify-center gap-3">
                      <Home className="h-6 w-6" />
                      <div className="text-left">
                        <div className="font-semibold">À domicile</div>
                        <div className="text-sm opacity-80">Le prestataire vient chez vous</div>
                      </div>
                    </div>
                  </Button>
                  <Button
                    onClick={() => handleTypeSelection('presence')}
                    variant="outline"
                    className="w-full h-16 border-primary text-primary hover:bg-primary hover:text-white transition-all duration-300 transform hover:scale-105"
                  >
                    <div className="flex items-center justify-center gap-3">
                      <Building2 className="h-6 w-6" />
                      <div className="text-left">
                        <div className="font-semibold">En présence</div>
                        <div className="text-sm opacity-80">Vous vous rendez chez le prestataire</div>
                      </div>
                    </div>
                  </Button>
                </div>
              </DialogContent>
            </Dialog>
          </CardContent>
        </Card>
      </div>

      {/* Bottom Actions */}
      <div className="fixed bottom-4 left-4 right-4 flex gap-2">
        <Button 
          variant="outline" 
          size="icon"
          className="bg-background border-muted-foreground/20 hover:bg-muted"
        >
          <Navigation className="h-4 w-4" />
        </Button>
        {selectedType && (
          <Badge className="bg-success/10 text-success border-success/20 px-3 py-1">
            {selectedType === 'domicile' ? '🏠 À domicile' : '🏢 En présence'}
          </Badge>
        )}
      </div>
    </div>
  );
};

export default MapView;