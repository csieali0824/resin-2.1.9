package dateCodeRule.dto;

import java.util.LinkedList;
import java.util.List;

public class DateCodeDto {
    private String device = "";
    private String dateCode = "";
    private String remarks = "";
    private String marking = "";
    private String markingDesc = "";
    private String creationDate = "";
    private String uploadBy = "";
    private String modifyBy = "";
    private String updateDate = "";
    private String dateCodeRange = "";
    private String prodGroup = "";
    private String year = "";
    private String yyww = "";
    private String errMsg = "";
    private List errorList = new LinkedList();

    public String getDevice() {
        return device;
    }

    public void setDevice(String device) {
        this.device = device;
    }

    public String getDateCode() {
        return dateCode;
    }

    public void setDateCode(String dateCode) {
        this.dateCode = dateCode;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getMarking() {
        return marking;
    }

    public void setMarking(String marking) {
        this.marking = marking;
    }

    public String getMarkingDesc() {
        return markingDesc;
    }

    public void setMarkingDesc(String markingDesc) {
        this.markingDesc = markingDesc;
    }

    public String getProdGroup() {
        return prodGroup;
    }

    public void setProdGroup(String prodGroup) {
        this.prodGroup = prodGroup;
    }

    public String getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(String creationDate) {
        this.creationDate = creationDate;
    }

    public String getUploadBy() {
        return uploadBy;
    }

    public void setUploadBy(String uploadBy) {
        this.uploadBy = uploadBy;
    }

    public String getModifyBy() {
        return modifyBy;
    }

    public void setModifyBy(String modifyBy) {
        this.modifyBy = modifyBy;
    }

    public String getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(String updateDate) {
        this.updateDate = updateDate;
    }

    public String getErrMsg() {
        return errMsg;
    }

    public void setErrMsg(String errMsg) {
        this.errMsg = errMsg;
    }

    public List getErrorList() {
        return errorList;
    }

    public void setErrorList(List errorList) {
        this.errorList = errorList;
    }

    public String getDateCodeRange() {
        return dateCodeRange;
    }

    public void setDateCodeRange(String dateCodeRange) {
        this.dateCodeRange = dateCodeRange;
    }

    public String getYyww() {
        return yyww;
    }

    public void setYyww(String yyww) {
        this.yyww = yyww;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }
}
