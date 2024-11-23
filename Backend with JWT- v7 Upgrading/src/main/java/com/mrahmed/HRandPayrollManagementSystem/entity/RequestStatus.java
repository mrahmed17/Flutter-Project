package com.mrahmed.HRandPayrollManagementSystem.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum RequestStatus {
    APPROVED,
    PENDING,
    REJECTED;

    @JsonCreator
    public static RequestStatus fromString(String value) {
        return RequestStatus.valueOf(value.toUpperCase());
    }

    @JsonValue
    public String toJson() {
        return this.name();
    }

}
