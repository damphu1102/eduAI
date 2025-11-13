import React from "react";
import { useTranslation } from "../hooks/useTranslation";

const Home: React.FC = () => {
  const { t } = useTranslation();

  return (
    <section className="flex flex-col items-center justify-center min-h-screen p-4">
      <h1 className="text-4xl font-bold mb-4">{t("welcomeToMeke")}</h1>
      <p className="text-lg text-gray-600 mb-8">{t("startBuilding")}</p>
    </section>
  );
};

export default Home;
