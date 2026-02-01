package com.attendence.Attendance.constants;

public enum Roles {

    ROLE_ADMIN("Admin"),
    ROLE_STUDENT("Student"),
    ROLE_EMPLOYEE("Employee"),
    ROLE_PLAYER("Player"),
    ROLE_COACH("Coach"),
    ROLE_LEAD("Lead");

    private final String displayName;

    Roles(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
