package com.mrahmed.HRandPayrollManagementSystem.util;

/**
 * @Project: Backend with JWT- v5 Upgrading
 * @Author: M. R. Ahmed
 * @Created at: 11/17/2024
 */
public class UrlConstants {

    // Base URL for the application
    public static final String BASE_URL = "http://localhost:8080";

    // Register Admin URL
    public static final String REGISTER_ADMIN_URL = BASE_URL + "/register/admin";

    // Register Manager URL
    public static final String REGISTER_MANAGER_URL = BASE_URL + "/register/manager";

    // Register Employee URL
    public static final String REGISTER_EMPLOYEE_URL = BASE_URL + "/register/employee";

   // Activation URL
    public static final String ACTIVATION_URL = BASE_URL + "/activate/";

    // Password reset URL
    public static final String RESET_PASSWORD_URL = BASE_URL + "/reset-password?token=";

    // Forgot password URL
    public static final String FORGOT_PASSWORD_URL = BASE_URL + "/forgot-password";

    // JWT Authentication URL (for login)
    public static final String AUTHENTICATE_URL = BASE_URL + "/authenticate";

    // Register URL (for registration)
    public static final String REGISTER_URL = BASE_URL + "/register";

    // Other URLs you may use (e.g., user profile, logout, etc.)
    public static final String PROFILE_URL = BASE_URL + "/profile";
    public static final String LOGOUT_URL = BASE_URL + "/logout";
}
