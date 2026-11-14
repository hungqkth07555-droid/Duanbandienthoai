package DTO;

import java.sql.Timestamp;
import java.util.List;

public class DeviceDetailDTO extends ProductDTO {

    private int ticketId;
    private String chargingTech;
    private String biometricsType;
    private String coverageTerms;

    private List<ComponentCheck> componentChecks;
    private List<InspectionDetail> inspectionDetails;
    private List<PriceHistoryItem> priceHistory;
    private List<ReviewItem> reviews;
    private List<QuestionItem> deviceQuestions;

    public DeviceDetailDTO() {
        super();
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public String getChargingTech() {
        return chargingTech;
    }

    public void setChargingTech(String chargingTech) {
        this.chargingTech = chargingTech;
    }

    public String getBiometricsType() {
        return biometricsType;
    }

    public void setBiometricsType(String biometricsType) {
        this.biometricsType = biometricsType;
    }

    public String getCoverageTerms() {
        return coverageTerms;
    }

    public void setCoverageTerms(String coverageTerms) {
        this.coverageTerms = coverageTerms;
    }

    public List<ComponentCheck> getComponentChecks() {
        return componentChecks;
    }

    public void setComponentChecks(List<ComponentCheck> componentChecks) {
        this.componentChecks = componentChecks;
    }

    public List<InspectionDetail> getInspectionDetails() {
        return inspectionDetails;
    }

    public void setInspectionDetails(List<InspectionDetail> inspectionDetails) {
        this.inspectionDetails = inspectionDetails;
    }

    public List<PriceHistoryItem> getPriceHistory() {
        return priceHistory;
    }

    public void setPriceHistory(List<PriceHistoryItem> priceHistory) {
        this.priceHistory = priceHistory;
    }

    public List<ReviewItem> getReviews() {
        return reviews;
    }

    public void setReviews(List<ReviewItem> reviews) {
        this.reviews = reviews;
    }

    public List<QuestionItem> getDeviceQuestions() {
        return deviceQuestions;
    }

    public void setDeviceQuestions(List<QuestionItem> deviceQuestions) {
        this.deviceQuestions = deviceQuestions;
    }

    public static class ComponentCheck {

        private String partName;
        private boolean isOriginal;
        private boolean isGenuineReplaced;
        private String icloudStatus;
        private String simLockStatus;
        private String blacklistedCheck;
        private String proofImageUrl;
        private Timestamp inspectionDate;

        public String getPartName() {
            return partName;
        }

        public void setPartName(String partName) {
            this.partName = partName;
        }

        public boolean getIsOriginal() {
            return isOriginal;
        }

        public boolean isOriginal() {
            return isOriginal;
        }

        public void setOriginal(boolean isOriginal) {
            this.isOriginal = isOriginal;
        }

        public boolean getIsGenuineReplaced() {
            return isGenuineReplaced;
        }

        public boolean isGenuineReplaced() {
            return isGenuineReplaced;
        }

        public void setGenuineReplaced(boolean isGenuineReplaced) {
            this.isGenuineReplaced = isGenuineReplaced;
        }

        public String getIcloudStatus() {
            return icloudStatus;
        }

        public void setIcloudStatus(String icloudStatus) {
            this.icloudStatus = icloudStatus;
        }

        public String getSimLockStatus() {
            return simLockStatus;
        }

        public void setSimLockStatus(String simLockStatus) {
            this.simLockStatus = simLockStatus;
        }

        public String getBlacklistedCheck() {
            return blacklistedCheck;
        }

        public void setBlacklistedCheck(String blacklistedCheck) {
            this.blacklistedCheck = blacklistedCheck;
        }

        public String getProofImageUrl() {
            return proofImageUrl;
        }

        public void setProofImageUrl(String proofImageUrl) {
            this.proofImageUrl = proofImageUrl;
        }

        public Timestamp getInspectionDate() {
            return inspectionDate;
        }

        public void setInspectionDate(Timestamp inspectionDate) {
            this.inspectionDate = inspectionDate;
        }
    }

    public static class InspectionDetail {

        private String checkItem;
        private String resultStatus;
        private String gradeValue;
        private String notes;
        private Timestamp inspectionDate;
        private String inspectorName;

        public String getCheckItem() {
            return checkItem;
        }

        public void setCheckItem(String checkItem) {
            this.checkItem = checkItem;
        }

        public String getResultStatus() {
            return resultStatus;
        }

        public void setResultStatus(String resultStatus) {
            this.resultStatus = resultStatus;
        }

        public String getGradeValue() {
            return gradeValue;
        }

        public void setGradeValue(String gradeValue) {
            this.gradeValue = gradeValue;
        }

        public String getNotes() {
            return notes;
        }

        public void setNotes(String notes) {
            this.notes = notes;
        }

        public Timestamp getInspectionDate() {
            return inspectionDate;
        }

        public void setInspectionDate(Timestamp inspectionDate) {
            this.inspectionDate = inspectionDate;
        }

        public String getInspectorName() {
            return inspectorName;
        }

        public void setInspectorName(String inspectorName) {
            this.inspectorName = inspectorName;
        }
    }

    public static class PriceHistoryItem {

        private double suggestedSellingPrice;
        private double actualSellingPrice;
        private double marketAdjustment;
        private Timestamp changedAt;

        public double getSuggestedSellingPrice() {
            return suggestedSellingPrice;
        }

        public void setSuggestedSellingPrice(double suggestedSellingPrice) {
            this.suggestedSellingPrice = suggestedSellingPrice;
        }

        public double getActualSellingPrice() {
            return actualSellingPrice;
        }

        public void setActualSellingPrice(double actualSellingPrice) {
            this.actualSellingPrice = actualSellingPrice;
        }

        public double getMarketAdjustment() {
            return marketAdjustment;
        }

        public void setMarketAdjustment(double marketAdjustment) {
            this.marketAdjustment = marketAdjustment;
        }

        public Timestamp getChangedAt() {
            return changedAt;
        }

        public void setChangedAt(Timestamp changedAt) {
            this.changedAt = changedAt;
        }
    }

    public static class ReviewItem {

        private String fullName;
        private int overallRating;
        private int qcAccuracyRating;
        private int batteryPostUseRating;
        private String comment;
        private String reviewImageUrl;
        private Timestamp createdAt;

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public int getOverallRating() {
            return overallRating;
        }

        public void setOverallRating(int overallRating) {
            this.overallRating = overallRating;
        }

        public int getQcAccuracyRating() {
            return qcAccuracyRating;
        }

        public void setQcAccuracyRating(int qcAccuracyRating) {
            this.qcAccuracyRating = qcAccuracyRating;
        }

        public int getBatteryPostUseRating() {
            return batteryPostUseRating;
        }

        public void setBatteryPostUseRating(int batteryPostUseRating) {
            this.batteryPostUseRating = batteryPostUseRating;
        }

        public String getComment() {
            return comment;
        }

        public void setComment(String comment) {
            this.comment = comment;
        }

        public String getReviewImageUrl() {
            return reviewImageUrl;
        }

        public void setReviewImageUrl(String reviewImageUrl) {
            this.reviewImageUrl = reviewImageUrl;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }
    }

    public static class QuestionItem {

        private String fullName;
        private String message;
        private String status;
        private Timestamp createdAt;

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
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
}
