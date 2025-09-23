import { useState, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Search, MapPin, Filter, Bell, User, Menu } from "lucide-react";
import { services, serviceCategories, Service } from "@/data/services";
import ServiceCard from "@/components/ServiceCard";
import WelcomeModal from "@/components/WelcomeModal";
import servicesHero from "@/assets/services-hero.jpg";

const Index = () => {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("all");

  const filteredServices = useMemo(() => {
    let filtered = services;
    
    if (selectedCategory !== "all") {
      filtered = filtered.filter(service => service.category === selectedCategory);
    }
    
    if (searchQuery) {
      filtered = filtered.filter(service => 
        service.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        service.description.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }
    
    return filtered;
  }, [searchQuery, selectedCategory]);

  const handleServiceClick = (service: Service) => {
    navigate(`/service/${service.id}`);
  };

  const categories = [
    { key: "all", label: "Tous", count: services.length },
    ...Object.entries(serviceCategories).map(([key, label]) => ({
      key: label,
      label: label.split(" ")[0],
      count: services.filter(s => s.category === label).length
    }))
  ];

  return (
    <div className="min-h-screen bg-background">
      <WelcomeModal />
      
      {/* Header */}
      <div className="bg-gradient-hero text-white relative overflow-hidden">
        <div className="absolute inset-0 opacity-20">
          <img src={servicesHero} alt="" className="w-full h-full object-cover" />
        </div>
        
        <div className="relative z-10 p-4 pt-8">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className="text-2xl font-bold mb-1">Bonjour ! 👋</h1>
              <p className="text-white/80 text-sm">Trouvez le service qu'il vous faut</p>
            </div>
            <div className="flex gap-2">
              <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                <Bell className="h-5 w-5" />
              </Button>
              <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                <User className="h-5 w-5" />
              </Button>
              <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                <Menu className="h-5 w-5" />
              </Button>
            </div>
          </div>

          {/* Search Bar */}
          <div className="relative mb-4">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Rechercher un service..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 bg-white/95 border-0 text-foreground placeholder:text-muted-foreground"
            />
          </div>

          {/* Location */}
          <div className="flex items-center gap-2 text-white/80 text-sm mb-2">
            <MapPin className="h-4 w-4" />
            <span>Dakar, Sénégal</span>
            <Button variant="ghost" size="sm" className="text-white hover:bg-white/20 p-1 h-auto">
              Changer
            </Button>
          </div>
        </div>
      </div>

      {/* Categories */}
      <div className="p-4 bg-background sticky top-0 z-10 border-b">
        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {categories.slice(0, 6).map((category) => (
            <Badge
              key={category.key}
              variant={selectedCategory === category.key ? "default" : "outline"}
              className={`cursor-pointer whitespace-nowrap transition-all hover:scale-105 ${
                selectedCategory === category.key 
                  ? "bg-gradient-primary text-white border-0" 
                  : "hover:border-primary hover:text-primary"
              }`}
              onClick={() => setSelectedCategory(category.key === "all" ? "all" : category.key)}
            >
              {category.label} ({category.count})
            </Badge>
          ))}
          <Button variant="ghost" size="sm" className="text-primary hover:bg-primary/10">
            <Filter className="h-4 w-4" />
          </Button>
        </div>
      </div>

      {/* Stats Bar */}
      <div className="px-4 py-3 bg-muted/50">
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            {filteredServices.length} services disponibles
          </p>
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 bg-online rounded-full animate-pulse" />
            <span className="text-sm text-success font-medium">247 prestataires en ligne</span>
          </div>
        </div>
      </div>

      {/* Services Grid */}
      <div className="p-4 pb-20">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredServices.map((service, index) => (
            <div 
              key={service.id} 
              className="animate-slide-up"
              style={{ animationDelay: `${index * 0.1}s` }}
            >
              <ServiceCard
                service={service}
                onClick={() => handleServiceClick(service)}
              />
            </div>
          ))}
        </div>

        {filteredServices.length === 0 && (
          <div className="text-center py-12">
            <div className="text-6xl mb-4">🔍</div>
            <h3 className="text-lg font-semibold mb-2">Aucun service trouvé</h3>
            <p className="text-muted-foreground">Essayez avec d'autres mots-clés</p>
          </div>
        )}
      </div>

      {/* Floating Action Button */}
      <div className="fixed bottom-6 right-6">
        <Button 
          size="icon"
          onClick={() => navigate('/map/general')}
          className="w-14 h-14 rounded-full bg-gradient-primary shadow-glow hover:scale-110 transition-transform animate-float"
        >
          <MapPin className="h-6 w-6" />
        </Button>
      </div>
    </div>
  );
};

export default Index;
