package com.attendence.Attendance.model;

import java.util.ArrayList;
import java.util.List;

public class UploadResult {

    public int successCount;
    public int failureCount;
    public List<UploadError> errors = new ArrayList<>();

    public void incrementSuccess() {
        successCount++;
    }

    public void addError(UploadError error) {
        failureCount++;
        errors.add(error);
    }

    @Override
    public String toString() {
        return "UploadResult{" +
                "successCount=" + successCount +
                ", failureCount=" + failureCount +
                ", errors=" + errors +
                '}';
    }
}
