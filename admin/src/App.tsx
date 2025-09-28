import { Toaster } from "@/components/ui/toaster";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Index from "./pages/Index";
import Clients from "./pages/Clients";
import Prestataires from "./pages/Prestataires";
import Finances from "./pages/Finances";
import Analytics from "./pages/Analytics";
import Notifications from "./pages/Notifications";
import Securite from "./pages/Securite";
import Geographie from "./pages/Geographie";
import Parametres from "./pages/Parametres";
import NotFound from "./pages/NotFound";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <Toaster />
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Index />} />
        <Route path="/clients" element={<Clients />} />
        <Route path="/prestataires" element={<Prestataires />} />
        <Route path="/finances" element={<Finances />} />
        <Route path="/analytics" element={<Analytics />} />
        <Route path="/notifications" element={<Notifications />} />
        <Route path="/securite" element={<Securite />} />
        <Route path="/geographie" element={<Geographie />} />
        <Route path="/parametres" element={<Parametres />} />
        {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  </QueryClientProvider>
);

export default App;