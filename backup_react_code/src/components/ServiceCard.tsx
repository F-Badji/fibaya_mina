import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { MapPin, Clock, Phone, MessageCircle } from "lucide-react";
import { Service } from "@/data/services";

interface ServiceCardProps {
  service: Service;
  onClick?: () => void;
  showActions?: boolean;
}

const ServiceCard = ({ service, onClick, showActions = false }: ServiceCardProps) => {
  return (
    <Card className="group cursor-pointer transition-all duration-300 hover:shadow-primary hover:scale-[1.02] border-border/50 overflow-hidden">
      <CardContent className="p-0">
        {service.image && (
          <div className="relative overflow-hidden h-32">
            <img 
              src={service.image} 
              alt={service.name}
              className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-primary/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            <Badge className="absolute top-2 right-2 bg-success text-white border-0">
              Disponible
            </Badge>
          </div>
        )}
        
        <div className="p-4">
          <div className="flex items-center gap-3 mb-2">
            <div className="text-2xl">{service.icon}</div>
            <div>
              <h3 className="font-semibold text-primary group-hover:text-success transition-colors">
                {service.name}
              </h3>
              <p className="text-sm text-muted-foreground">{service.category}</p>
            </div>
          </div>
          
          <p className="text-sm text-muted-foreground mb-3 line-clamp-2">
            {service.description}
          </p>

          {showActions && (
            <div className="space-y-3">
              <div className="flex items-center gap-4 text-sm text-muted-foreground">
                <div className="flex items-center gap-1">
                  <MapPin className="h-4 w-4 text-success" />
                  <span>2.5 km</span>
                </div>
                <div className="flex items-center gap-1">
                  <Clock className="h-4 w-4 text-primary" />
                  <span>15 min</span>
                </div>
              </div>
              
              <div className="flex gap-2">
                <Button size="sm" className="flex-1 bg-gradient-primary hover:opacity-90">
                  <MapPin className="h-4 w-4 mr-1" />
                  Voir carte
                </Button>
                <Button size="sm" variant="outline" className="border-success text-success hover:bg-success hover:text-white">
                  <Phone className="h-4 w-4" />
                </Button>
                <Button size="sm" variant="outline" className="border-primary text-primary hover:bg-primary hover:text-white">
                  <MessageCircle className="h-4 w-4" />
                </Button>
              </div>
            </div>
          )}
          
          {!showActions && (
            <Button 
              onClick={onClick}
              className="w-full bg-gradient-primary hover:opacity-90 transition-all duration-300 hover:scale-[1.02]"
            >
              Trouver un prestataire
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
};

export default ServiceCard;