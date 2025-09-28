import { useState, useEffect } from "react";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";
import heroImage from "@/assets/services-hero.jpg";

const WelcomeModal = () => {
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    const hasSeenWelcome = localStorage.getItem("fibaya-welcome-seen");
    if (!hasSeenWelcome) {
      setTimeout(() => setIsOpen(true), 500);
    }
  }, []);

  const handleClose = () => {
    setIsOpen(false);
    localStorage.setItem("fibaya-welcome-seen", "true");
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogContent className="max-w-2xl p-0 overflow-hidden border-0 bg-gradient-hero">
        <div className="relative">
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-4 right-4 z-10 text-white hover:bg-white/20"
            onClick={handleClose}
          >
            <X className="h-4 w-4" />
          </Button>
          
          <div className="relative overflow-hidden">
            <img 
              src={heroImage} 
              alt="Services Fibaya" 
              className="w-full h-64 object-cover opacity-90"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-primary-dark/80 to-transparent" />
          </div>
          
          <div className="p-8 text-white text-center">
            <h2 className="text-3xl font-bold mb-4 animate-slide-up">
              Bienvenue sur <span className="text-success">Fibaya</span>
            </h2>
            <p className="text-lg text-white/90 mb-6 animate-slide-up">
              Trouvez les meilleurs prestataires de services près de chez vous en quelques clics !
            </p>
            <div className="grid grid-cols-3 gap-4 mb-6 text-sm">
              <div className="animate-scale-in">
                <div className="w-12 h-12 bg-success rounded-full mx-auto mb-2 flex items-center justify-center text-xl">
                  📍
                </div>
                <p>Géolocalisation</p>
              </div>
              <div className="animate-scale-in" style={{ animationDelay: "0.1s" }}>
                <div className="w-12 h-12 bg-success rounded-full mx-auto mb-2 flex items-center justify-center text-xl">
                  💬
                </div>
                <p>Messages gratuits</p>
              </div>
              <div className="animate-scale-in" style={{ animationDelay: "0.2s" }}>
                <div className="w-12 h-12 bg-success rounded-full mx-auto mb-2 flex items-center justify-center text-xl">
                  ⏱️
                </div>
                <p>Temps réel</p>
              </div>
            </div>
            <Button 
              onClick={handleClose}
              className="bg-success hover:bg-success/90 text-white px-8 py-3 text-lg transition-spring hover:scale-105"
            >
              Commencer maintenant
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default WelcomeModal;