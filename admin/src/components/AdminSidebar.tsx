import { useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import {
  LayoutDashboard,
  Users,
  UserCheck,
  CreditCard,
  BarChart3,
  Bell,
  Shield,
  Map,
  Settings,
  ChevronDown,
  ChevronRight
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const menuItems = [
  {
    title: "Dashboard",
    url: "/",
    icon: LayoutDashboard,
  },
  {
    title: "Gestion Utilisateurs",
    icon: Users,
    subItems: [
      { title: "Clients", url: "/clients", icon: Users },
      { title: "Prestataires", url: "/prestataires", icon: UserCheck },
    ],
  },
  {
    title: "Finances",
    url: "/finances",
    icon: CreditCard,
  },
  {
    title: "Analytics",
    url: "/analytics",
    icon: BarChart3,
  },
  {
    title: "Notifications",
    url: "/notifications",
    icon: Bell,
  },
  {
    title: "Sécurité",
    url: "/securite",
    icon: Shield,
  },
  {
    title: "Géographie",
    url: "/geographie",
    icon: Map,
  },
  {
    title: "Paramètres",
    url: "/parametres",
    icon: Settings,
  },
];

interface AdminSidebarProps {
  collapsed: boolean;
  onToggle: () => void;
}

export function AdminSidebar({ collapsed, onToggle }: AdminSidebarProps) {
  const location = useLocation();
  const currentPath = location.pathname;
  const [expandedGroups, setExpandedGroups] = useState<string[]>(["Gestion Utilisateurs"]);

  const isActive = (path: string) => currentPath === path;
  const isGroupExpanded = (title: string) => expandedGroups.includes(title);
  
  const toggleGroup = (title: string) => {
    setExpandedGroups(prev => 
      prev.includes(title) 
        ? prev.filter(g => g !== title)
        : [...prev, title]
    );
  };

  const getNavClasses = (isActive: boolean) =>
    cn(
      "w-full justify-start transition-all duration-200 px-3 py-2 rounded-md text-sm font-medium flex items-center gap-3",
      isActive 
        ? "bg-primary text-primary-foreground shadow-md" 
        : "hover:bg-primary/10 text-muted-foreground hover:text-primary"
    );

  return (
    <div className={cn(
      "border-r border-border bg-gradient-to-b from-card to-secondary/20 flex flex-col h-screen transition-all duration-300",
      collapsed ? "w-16" : "w-64"
    )}>
      {/* Header */}
      <div className="p-4 border-b border-border">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center">
            <span className="text-primary-foreground font-bold text-sm">F</span>
          </div>
          {!collapsed && (
            <div>
              <h2 className="font-bold text-primary">FIBAYA</h2>
              <p className="text-xs text-muted-foreground">Admin Panel</p>
            </div>
          )}
        </div>
      </div>

      <div className="flex-1 px-2 py-4 overflow-y-auto">
        <div className="space-y-1">
          {menuItems.map((item) => (
            <div key={item.title}>
              {item.subItems ? (
                // Group with sub-items
                <div>
                  <button
                    onClick={() => toggleGroup(item.title)}
                    className={cn(
                      "w-full justify-between text-muted-foreground hover:text-primary hover:bg-primary/10 flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-all duration-200",
                      collapsed && "justify-center"
                    )}
                  >
                    <div className="flex items-center gap-3">
                      <item.icon className="h-4 w-4" />
                      {!collapsed && <span>{item.title}</span>}
                    </div>
                    {!collapsed && (
                      isGroupExpanded(item.title) ? 
                        <ChevronDown className="h-4 w-4" /> : 
                        <ChevronRight className="h-4 w-4" />
                    )}
                  </button>
                  
                  {isGroupExpanded(item.title) && !collapsed && (
                    <div className="ml-6 mt-1 space-y-1">
                      {item.subItems.map((subItem) => (
                        <NavLink
                          key={subItem.title}
                          to={subItem.url}
                          className={getNavClasses(isActive(subItem.url))}
                        >
                          <subItem.icon className="h-4 w-4" />
                          <span>{subItem.title}</span>
                        </NavLink>
                      ))}
                    </div>
                  )}
                </div>
              ) : (
                // Single item
                <NavLink
                  to={item.url}
                  className={getNavClasses(isActive(item.url))}
                >
                  <item.icon className="h-4 w-4" />
                  {!collapsed && <span>{item.title}</span>}
                </NavLink>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
