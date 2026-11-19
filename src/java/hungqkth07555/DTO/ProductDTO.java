package DTO;

import java.sql.Timestamp;

public class ProductDTO {

    private int deviceId;
    private int variantId;
    private String modelName;
    private String capacityValue;
    private String colorName;
    private String hexCode;
    private String modelNumber;
    private String sku;
    private String imei;
    private String serialNumber;
    private String originCountry;
    private String status;
    private String coverImage;

    private double price;
    private double baseNewPrice;
    private double savingsAmount;

    private String certCode;
    private double overallScore;
    private String qualityTier;
    private int batteryHealth;
    private int chargeCycles;
    private boolean originalBattery;
    private boolean batteryWarning;

    private boolean allOriginalParts;
    private int warrantyMonths;
    private String warrantyPackageName;
    private String cosmeticCondition;
    private String screenSize;
    private String chipset;
    private String ram;
    private String cameraSpecs;
    private int batteryCapacityMah;

    public ProductDTO() {
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getCapacityValue() {
        return capacityValue;
    }

    public void setCapacityValue(String capacityValue) {
        this.capacityValue = capacityValue;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public String getHexCode() {
        return hexCode;
    }

    public void setHexCode(String hexCode) {
        this.hexCode = hexCode;
    }

    public String getModelNumber() {
        return modelNumber;
    }

    public void setModelNumber(String modelNumber) {
        this.modelNumber = modelNumber;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getImei() {
        return imei;
    }

    public void setImei(String imei) {
        this.imei = imei;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getOriginCountry() {
        return originCountry;
    }

    public void setOriginCountry(String originCountry) {
        this.originCountry = originCountry;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getBaseNewPrice() {
        return baseNewPrice;
    }

    public void setBaseNewPrice(double baseNewPrice) {
        this.baseNewPrice = baseNewPrice;
    }

    public double getSavingsAmount() {
        return savingsAmount;
    }

    public void setSavingsAmount(double savingsAmount) {
        this.savingsAmount = savingsAmount;
    }

    public String getCertCode() {
        return certCode;
    }

    public void setCertCode(String certCode) {
        this.certCode = certCode;
    }

    public double getOverallScore() {
        return overallScore;
    }

    public void setOverallScore(double overallScore) {
        this.overallScore = overallScore;
    }

    public String getQualityTier() {
        return qualityTier;
    }

    public void setQualityTier(String qualityTier) {
        this.qualityTier = qualityTier;
    }

    public int getBatteryHealth() {
        return batteryHealth;
    }

    public void setBatteryHealth(int batteryHealth) {
        this.batteryHealth = batteryHealth;
    }

    public int getChargeCycles() {
        return chargeCycles;
    }

    public void setChargeCycles(int chargeCycles) {
        this.chargeCycles = chargeCycles;
    }

    public boolean isOriginalBattery() {
        return originalBattery;
    }

    public void setOriginalBattery(boolean originalBattery) {
        this.originalBattery = originalBattery;
    }

    public boolean isBatteryWarning() {
        return batteryWarning;
    }

    public void setBatteryWarning(boolean batteryWarning) {
        this.batteryWarning = batteryWarning;
    }

    public boolean isAllOriginalParts() {
        return allOriginalParts;
    }

    public void setAllOriginalParts(boolean allOriginalParts) {
        this.allOriginalParts = allOriginalParts;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    public String getWarrantyPackageName() {
        return warrantyPackageName;
    }

    public void setWarrantyPackageName(String warrantyPackageName) {
        this.warrantyPackageName = warrantyPackageName;
    }

    public String getCosmeticCondition() {
        return cosmeticCondition;
    }

    public void setCosmeticCondition(String cosmeticCondition) {
        this.cosmeticCondition = cosmeticCondition;
    }

    public String getScreenSize() {
        return screenSize;
    }

    public void setScreenSize(String screenSize) {
        this.screenSize = screenSize;
    }

    public String getChipset() {
        return chipset;
    }

    public void setChipset(String chipset) {
        this.chipset = chipset;
    }

    public String getRam() {
        return ram;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public String getCameraSpecs() {
        return cameraSpecs;
    }

    public void setCameraSpecs(String cameraSpecs) {
        this.cameraSpecs = cameraSpecs;
    }

    public int getBatteryCapacityMah() {
        return batteryCapacityMah;
    }

    public void setBatteryCapacityMah(int batteryCapacityMah) {
        this.batteryCapacityMah = batteryCapacityMah;
    }

    // Các lớp dữ liệu phụ trợ thay cho Map để tránh lỗi cú pháp khi copy
    public static class SearchHistoryItem {

        private int searchId;
        private String keyword;
        private String filters;
        private Timestamp createdAt;

        public int getSearchId() {
            return searchId;
        }

        public void setSearchId(int searchId) {
            this.searchId = searchId;
        }

        public String getKeyword() {
            return keyword;
        }

        public void setKeyword(String keyword) {
            this.keyword = keyword;
        }

        public String getFilters() {
            return filters;
        }

        public void setFilters(String filters) {
            this.filters = filters;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }
    }

    public static class VariantItem {

        private int variantId;
        private String label;

        public int getVariantId() {
            return variantId;
        }

        public void setVariantId(int variantId) {
            this.variantId = variantId;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }
    }

    public static class StockNotificationItem {

        private String modelName;
        private String capacity;
        private String color;
        private String tier;
        private String status;
        private Timestamp createdAt;

        public String getModelName() {
            return modelName;
        }

        public void setModelName(String modelName) {
            this.modelName = modelName;
        }

        public String getCapacity() {
            return capacity;
        }

        public void setCapacity(String capacity) {
            this.capacity = capacity;
        }

        public String getColor() {
            return color;
        }

        public void setColor(String color) {
            this.color = color;
        }

        public String getTier() {
            return tier;
        }

        public void setTier(String tier) {
            this.tier = tier;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }
    }

    public static class PriceStatItem {

        private String groupLabel;
        private int deviceCount;
        private double minPrice;
        private double avgPrice;
        private double maxPrice;
        private double avgSavings;

        public String getGroupLabel() {
            return groupLabel;
        }

        public void setGroupLabel(String groupLabel) {
            this.groupLabel = groupLabel;
        }

        public int getDeviceCount() {
            return deviceCount;
        }

        public void setDeviceCount(int deviceCount) {
            this.deviceCount = deviceCount;
        }

        public double getMinPrice() {
            return minPrice;
        }

        public void setMinPrice(double minPrice) {
            this.minPrice = minPrice;
        }

        public double getAvgPrice() {
            return avgPrice;
        }

        public void setAvgPrice(double avgPrice) {
            this.avgPrice = avgPrice;
        }

        public double getMaxPrice() {
            return maxPrice;
        }

        public void setMaxPrice(double maxPrice) {
            this.maxPrice = maxPrice;
        }

        public double getAvgSavings() {
            return avgSavings;
        }

        public void setAvgSavings(double avgSavings) {
            this.avgSavings = avgSavings;
        }
    }

    public static class SupportTicketItem {

        private int ticketId;
        private String subject;
        private String message;
        private String supportType;
        private String status;
        private Timestamp createdAt;

        public int getTicketId() {
            return ticketId;
        }

        public void setTicketId(int ticketId) {
            this.ticketId = ticketId;
        }

        public String getSubject() {
            return subject;
        }

        public void setSubject(String subject) {
            this.subject = subject;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getSupportType() {
            return supportType;
        }

        public void setSupportType(String supportType) {
            this.supportType = supportType;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }
    }

    public static class ComplaintItem {

        private int complaintId;
        private Integer deviceId;
        private String imei;
        private String complaintType;
        private String content;
        private String status;
        private String resolutionNote;
        private Timestamp createdAt;

        public int getComplaintId() {
            return complaintId;
        }

        public void setComplaintId(int complaintId) {
            this.complaintId = complaintId;
        }

        public Integer getDeviceId() {
            return deviceId;
        }

        public void setDeviceId(Integer deviceId) {
            this.deviceId = deviceId;
        }

        public String getImei() {
            return imei;
        }

        public void setImei(String imei) {
            this.imei = imei;
        }

        public String getComplaintType() {
            return complaintType;
        }

        public void setComplaintType(String complaintType) {
            this.complaintType = complaintType;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getResolutionNote() {
            return resolutionNote;
        }

        public void setResolutionNote(String resolutionNote) {
            this.resolutionNote = resolutionNote;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }
    }
}
