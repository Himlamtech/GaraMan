package com.garaman.service;

import com.garaman.entity.Service;
import com.garaman.entity.SparePart;
import java.util.*;

public class SearchService {

    public static class SearchResult {
        private List<Service> services;
        private List<SparePart> spareParts;

        public SearchResult(List<Service> services, List<SparePart> spareParts) {
            this.services = services;
            this.spareParts = spareParts;
        }

        public List<Service> getServices() {
            return services;
        }

        public List<SparePart> getSpareParts() {
            return spareParts;
        }

        public boolean isEmpty() {
            return (services == null || services.isEmpty()) &&
                    (spareParts == null || spareParts.isEmpty());
        }
    }

    private com.garaman.dao.impl.ServiceDAOImpl serviceDAO = new com.garaman.dao.impl.ServiceDAOImpl();
    private com.garaman.dao.impl.SparePartDAOImpl partDAO = new com.garaman.dao.impl.SparePartDAOImpl();

    public SearchResult search(String keyword) {
        return search(keyword, "all");
    }

    public SearchResult search(String keyword, String type) {
        if (keyword == null || keyword.trim().length() < 2) {
            return new SearchResult(new ArrayList<>(), new ArrayList<>());
        }

        List<Service> services = new ArrayList<>();
        List<SparePart> parts = new ArrayList<>();

        keyword = keyword.trim();

        // Search based on type filter
        if (type == null || type.equals("all") || type.equals("services")) {
            services = serviceDAO.searchByName(keyword);
        }

        if (type == null || type.equals("all") || type.equals("parts")) {
            parts = partDAO.searchByName(keyword);
        }

        return new SearchResult(services, parts);
    }

    public Service getServiceDetails(int serviceId) {
        return serviceDAO.getById(serviceId);
    }

    public SparePart getPartDetails(int partId) {
        return partDAO.getById(partId);
    }
}
