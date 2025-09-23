import { useState, useEffect } from "react";
import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft, MapPin, Filter, Search } from "lucide-react";
import { services, Service } from "@/data/services";
import ServiceCard from "@/components/ServiceCard";

const ServiceSearch = () => {
  const { serviceId } = useParams();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const serviceType = searchParams.get('type');
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedService, setSelectedService] = useState<Service | null>(null);
  const [mockProviders, setMockProviders] = useState<any[]>([]);

  useEffect(() => {
    const service = services.find(s => s.id === serviceId);
    setSelectedService(service || null);
    
    // Simuler des prestataires
    setMockProviders([
      { id: 1, name: "Jean Dupont", rating: 4.8, distance: 1.2, eta: 10, price: "25€/h" },
      { id: 2, name: "Marie Laurent", rating: 4.9, distance: 2.1, eta: 15, price: "30€/h" },
      { id: 3, name: "Ahmed Benali", rating: 4.7, distance: 0.8, eta: 8, price: "28€/h" },
    ]);
  }, [serviceId]);

  const handleViewMap = () => {
    navigate(`/map/${serviceId}`);
  };

  if (!selectedService) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <p>Service non trouvé</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="bg-gradient-hero text-white p-4 sticky top-0 z-10">
        <div className="flex items-center gap-3 mb-4">
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
            <p className="text-white/80 text-sm">
              {serviceType === 'domicile' ? '🏠 À domicile' : '🏢 En présence'} • {selectedService.category}
            </p>
          </div>
          <Button
            onClick={handleViewMap}
            variant="secondary"
            size="sm"
            className="bg-success hover:bg-success/90"
          >
            <MapPin className="h-4 w-4 mr-1" />
            Carte
          </Button>
        </div>

        {/* Search Bar */}
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher dans votre zone..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10 bg-white/10 border-white/20 text-white placeholder:text-white/60"
          />
          <Button
            size="icon"
            variant="ghost"
            className="absolute right-1 top-1/2 transform -translate-y-1/2 text-white hover:bg-white/20"
          >
            <Filter className="h-4 w-4" />
          </Button>
        </div>
      </div>

      {/* Stats Bar */}
      <div className="bg-muted p-4">
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            {mockProviders.length} prestataires trouvés
          </p>
          <Badge variant="secondary" className="bg-success/10 text-success border-success/20">
            🟢 En ligne
          </Badge>
        </div>
      </div>

      {/* Providers List */}
      <div className="p-4 space-y-4">
        {mockProviders.map((provider) => (
          <div key={provider.id} className="animate-slide-up">
            <ServiceCard
              service={{
                ...selectedService,
                name: provider.name,
                description: `⭐ ${provider.rating} • ${provider.price} • ${provider.distance}km`
              }}
              showActions={true}
            />
          </div>
        ))}

        {/* Quick Actions */}
        <div className="fixed bottom-4 left-4 right-4 bg-card rounded-lg shadow-primary p-4 border">
          <div className="flex gap-2">
            <Button 
              onClick={handleViewMap}
              className="flex-1 bg-gradient-primary hover:opacity-90"
            >
              <MapPin className="h-4 w-4 mr-2" />
              Voir sur la carte
            </Button>
            <Button variant="outline" className="border-success text-success hover:bg-success hover:text-white">
              Filtrer
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ServiceSearch;