import { ReactNode } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface StatsCardProps {
  title: string;
  value: string | number;
  change?: string;
  changeType?: "positive" | "negative" | "neutral";
  icon: ReactNode;
  variant?: "default" | "success" | "warning" | "danger";
  gradient?: boolean;
}

export function StatsCard({
  title,
  value,
  change,
  changeType = "neutral",
  icon,
  variant = "default",
  gradient = false
}: StatsCardProps) {
  const getVariantClasses = () => {
    switch (variant) {
      case "success":
        return "border-green-500/20 bg-gradient-to-br from-green-500/5 to-green-500/10";
      case "warning":
        return "border-orange-500/20 bg-gradient-to-br from-orange-500/5 to-orange-500/10";
      case "danger":
        return "border-red-500/20 bg-gradient-to-br from-red-500/5 to-red-500/10";
      default:
        return gradient 
          ? "border-primary/20 bg-gradient-to-br from-primary/5 to-primary/10"
          : "border-border";
    }
  };

  const getIconBgClass = () => {
    switch (variant) {
      case "success":
        return "bg-green-500 text-white";
      case "warning":
        return "bg-orange-500 text-white";
      case "danger":
        return "bg-red-500 text-white";
      default:
        return "bg-primary text-primary-foreground";
    }
  };

  const getChangeColor = () => {
    switch (changeType) {
      case "positive":
        return "text-green-600";
      case "negative":
        return "text-red-600";
      default:
        return "text-muted-foreground";
    }
  };

  return (
    <Card className={cn(
      "transition-all duration-300 hover:shadow-lg hover:-translate-y-1",
      getVariantClasses()
    )}>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium text-muted-foreground">
          {title}
        </CardTitle>
        <div className={cn(
          "p-2 rounded-lg",
          getIconBgClass()
        )}>
          {icon}
        </div>
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold text-foreground mb-1">
          {value}
        </div>
        {change && (
          <p className={cn("text-xs", getChangeColor())}>
            {change}
          </p>
        )}
      </CardContent>
    </Card>
  );
}
