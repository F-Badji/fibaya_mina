import { useParams, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Home, Users } from "lucide-react";
import { services } from "@/data/services";

const ServiceTypeSelection = () => {
  const { serviceId } = useParams();
  const navigate = useNavigate();
  
  const selectedService = services.find(s => s.id === serviceId);

  if (!selectedService) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <p>Service non trouvé</p>
      </div>
    );
  }

  const handleServiceType = (type: 'domicile' | 'presence') => {
    navigate(`/service/${serviceId}/providers?type=${type}`);
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="bg-gradient-hero text-white p-4 sticky top-0 z-10">
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
            <h1 className="text-xl font-bold">{selectedService.name}</h1>
            <p className="text-white/80 text-sm">Choisissez votre préférence</p>
          </div>
        </div>
      </div>

      {/* Service Image */}
      <div className="relative h-48 overflow-hidden">
        {selectedService.image && (
          <img 
            src={selectedService.image} 
            alt={selectedService.name}
            className="w-full h-full object-cover"
          />
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-background/90 to-transparent" />
        <div className="absolute bottom-4 left-4 right-4 text-center">
          <div className="text-4xl mb-2">{selectedService.icon}</div>
          <p className="text-muted-foreground">{selectedService.description}</p>
        </div>
      </div>

      {/* Service Type Options */}
      <div className="p-6 space-y-4">
        <h2 className="text-lg font-semibold text-center mb-8">
          Comment souhaitez-vous recevoir ce service ?
        </h2>
        
        <div className="space-y-4">
          {/* À domicile */}
          <Button
            onClick={() => handleServiceType('domicile')}
            className="w-full h-20 bg-gradient-primary hover:opacity-90 flex-col gap-2 animate-slide-up"
            style={{ animationDelay: '0.1s' }}
          >
            <Home className="h-6 w-6" />
            <div className="text-center">
              <div className="font-semibold">À domicile</div>
              <div className="text-xs opacity-90">Le prestataire vient chez vous</div>
            </div>
          </Button>

          {/* En présence */}
          <Button
            onClick={() => handleServiceType('presence')}
            variant="outline"
            className="w-full h-20 border-2 border-success text-success hover:bg-success hover:text-white flex-col gap-2 animate-slide-up"
            style={{ animationDelay: '0.2s' }}
          >
            <Users className="h-6 w-6" />
            <div className="text-center">
              <div className="font-semibold">En présence</div>
              <div className="text-xs opacity-90">Vous vous rendez chez le prestataire</div>
            </div>
          </Button>
        </div>

        {/* Info */}
        <div className="mt-8 p-4 bg-muted rounded-lg animate-slide-up" style={{ animationDelay: '0.3s' }}>
          <p className="text-sm text-muted-foreground text-center">
            ⚡ Trouvez des prestataires disponibles près de vous en quelques secondes
          </p>
        </div>
      </div>
    </div>
  );
};

export default ServiceTypeSelection;