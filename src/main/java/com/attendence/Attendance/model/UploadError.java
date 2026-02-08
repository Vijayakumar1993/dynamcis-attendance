package com.attendence.Attendance.model;
public class UploadError {

    public int rowNumber;
    public String field;
    public String value;
    public String message;

    public UploadError(int rowNumber, String field, String value, String message) {
        this.rowNumber = rowNumber;
        this.field = field;
        this.value = value;
        this.message = message;
    }

    public int getRowNumber() {
        return rowNumber;
    }

    public void setRowNumber(int rowNumber) {
        this.rowNumber = rowNumber;
    }

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "UploadError{" +
                "rowNumber=" + rowNumber +
                ", field='" + field + '\'' +
                ", value='" + value + '\'' +
                ", message='" + message + '\'' +
                '}';
    }
}
