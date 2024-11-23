package com.mrahmed.HRandPayrollManagementSystem.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum LeaveType {
    SICK,
    UNPAID,
    RESERVE;

//    @JsonCreator
//    public static LeaveType fromString(String key) {
//        if (key == null) {
//            return null;
//        }
//        return LeaveType.valueOf(key.toUpperCase());
//    }


    @JsonCreator
    public static LeaveType fromString(String value) {
        return LeaveType.valueOf(value.toUpperCase());
    }

    @JsonValue
    public String toJson() {
        return this.name();
    }

}

