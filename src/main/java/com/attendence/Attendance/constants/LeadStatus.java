package com.attendence.Attendance.constants;
public enum LeadStatus {

    NEW(30),
    CONTACTED(31),
    FOLLOW_UP(32),
    INTERESTED(33),
    CONVERTED(34),
    LOST(35);

    private final long code;

    LeadStatus(int code) {
        this.code = code;
    }

    public long getCode() {
        return code;
    }

    // Optional: reverse lookup (very useful)
    public static LeadStatus fromCode(int code) {
        for (LeadStatus s : values()) {
            if (s.code == code) {
                return s;
            }
        }
        throw new IllegalArgumentException("Invalid LeadStatus code: " + code);
    }
}

