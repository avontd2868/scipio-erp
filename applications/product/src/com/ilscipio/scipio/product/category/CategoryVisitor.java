package com.ilscipio.scipio.product.category;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.GenericValue;

/**
 * Versatile visitor interface for {@link CategoryTraverser}.
 * @see CategoryTraverser
 */
public interface CategoryVisitor {

    void pushCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) throws CategoryTraversalException;
    
    void popCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) throws CategoryTraversalException;
    
    void visitCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) throws CategoryTraversalException;

    void visitProduct(GenericValue product, List<GenericValue> trailCategories, int physicalDepth) throws CategoryTraversalException;

    public static abstract class CommonCategoryVisitor implements CategoryVisitor {
        @Override public void pushCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) { ; }
        @Override public void popCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) { ; }
        @Override public void visitCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) { ; }
        @Override public void visitProduct(GenericValue product, List<GenericValue> trailCategories, int physicalDepth) { ; }
    }

    public static class LoggingCategoryVisitor extends CommonCategoryVisitor {
        public static final String module = LoggingCategoryVisitor.class.getName();
                
        protected List<String> trailIds = new ArrayList<>();
        protected String lastId = null;
        

        @Override
        public void pushCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) {
            trailIds.add(productCategory.getString("productCategoryId"));
        }
        
        @Override
        public void popCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) {
            trailIds.remove(trailIds.size() - 1);
        }
        
        @Override
        public void visitCategory(GenericValue productCategory, List<GenericValue> trailCategories, int physicalDepth) {
            Debug.logInfo(getTrailPrefix() + productCategory.get("productCategoryId") + " [category]", module); 
        }

        @Override
        public void visitProduct(GenericValue product, List<GenericValue> trailCategories, int physicalDepth) {
            Debug.logInfo(getTrailPrefix() + product.get("productId") + " [product]", module); 
        }

        protected String getTrailPrefix() {
            if (trailIds.isEmpty()) return "/";
            else return "/" + StringUtils.join(trailIds, "/") + "/";
        }
    }
}