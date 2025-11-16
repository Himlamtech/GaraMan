package com.garaman.service;

import com.garaman.dao.ServiceDAO;
import com.garaman.dao.ServiceDAOImpl;
import com.garaman.dao.PartDAO;
import com.garaman.dao.PartDAOImpl;
import com.garaman.model.Service;
import com.garaman.model.Part;

import java.util.ArrayList;
import java.util.List;

/**
 * Service Layer: SearchService
 * Business logic for searching services and parts
 */
public class SearchService {

    private ServiceDAO serviceDAO;
    private PartDAO partDAO;

    public SearchService() {
        this.serviceDAO = new ServiceDAOImpl();
        this.partDAO = new PartDAOImpl();
    }

    /**
     * Search services/parts by keyword and type
     *
     * @param keyword Search keyword (optional)
     * @param type    "service", "part" or "all"
     * @return SearchResult containing services and parts
     */
    public SearchResult search(String keyword, String type) {
        SearchResult result = new SearchResult();

        boolean searchServices = type == null || "all".equalsIgnoreCase(type) || "service".equalsIgnoreCase(type);
        boolean searchParts = type == null || "all".equalsIgnoreCase(type) || "part".equalsIgnoreCase(type);

        if (searchServices) {
            result.services = (keyword == null || keyword.trim().isEmpty())
                    ? serviceDAO.getAll()
                    : serviceDAO.search(keyword.trim());
        }

        if (searchParts) {
            result.parts = (keyword == null || keyword.trim().isEmpty())
                    ? partDAO.getAll()
                    : partDAO.search(keyword.trim());
        }

        return result;
    }

    /**
     * Inner class to hold search results
     */
    public static class SearchResult {
        private List<Service> services = new ArrayList<>();
        private List<Part> parts = new ArrayList<>();

        public List<Service> getServices() {
            return services;
        }

        public List<Part> getParts() {
            return parts;
        }

        public boolean hasResults() {
            return !services.isEmpty() || !parts.isEmpty();
        }
    }
}
