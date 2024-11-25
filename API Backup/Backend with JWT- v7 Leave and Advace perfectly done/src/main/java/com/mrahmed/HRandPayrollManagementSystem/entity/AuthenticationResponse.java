package com.mrahmed.HRandPayrollManagementSystem.entity;

import lombok.AllArgsConstructor;
import lombok.*;
import lombok.NoArgsConstructor;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AuthenticationResponse {

    private String token;
    private String message;
    private User user;

    public AuthenticationResponse(String message) {
        this.message = message;
    }

}
