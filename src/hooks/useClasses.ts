import { useState, useEffect } from "react";
import { classService } from "../services/classService";
import type { GetClassesParams } from "../services/classService";
import type { Class } from "../types/class.types";

export const useClasses = (params?: GetClassesParams) => {
  const [classes, setClasses] = useState<Class[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [pagination, setPagination] = useState({
    page: 1,
    limit: 10,
    total: 0,
    totalPages: 0,
  });

  const loadClasses = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await classService.getAll(params);
      setClasses(response.data.classes);
      setPagination(response.data.pagination);
    } catch (err: any) {
      setError(err.message || "Failed to load classes");
      console.error("Load classes error:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadClasses();
  }, [params?.page, params?.limit, params?.status]);

  const refresh = () => {
    loadClasses();
  };

  return {
    classes,
    loading,
    error,
    pagination,
    refresh,
  };
};

export const useClass = (id: number) => {
  const [classData, setClassData] = useState<Class | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const loadClass = async () => {
      try {
        setLoading(true);
        setError(null);
        const response = await classService.getById(id);
        setClassData(response.data);
      } catch (err: any) {
        setError(err.message || "Failed to load class");
        console.error("Load class error:", err);
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      loadClass();
    }
  }, [id]);

  return {
    classData,
    loading,
    error,
  };
};
