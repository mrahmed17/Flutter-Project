package com.mrahmed.HRandPayrollManagementSystem.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.Collection;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "users")
public class User implements UserDetails, Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotBlank(message = "Full name is required")
    @Size(max = 100, message = "Full name can have a maximum of 100 characters")
    private String name;

    @Email(message = "Email should be valid")
    @NotBlank(message = "Email is required")
    @Column(unique = true, nullable = false)
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password should have at least 6 characters")
    @Column(nullable = false)
    private String password;

    @NotBlank(message = "Cell number is required")
    @Pattern(regexp = "^[+]?[0-9]{10,15}$", message = "Contact must be a valid phone number")
    @Column(unique = true)
    private String cell;

    @NotBlank(message = "Address is required")
    private String address;

    @Past(message = "Date of Birth must be a past date")
    private LocalDate dateOfBirth;

    @Pattern(regexp = "^(Male|Female|Other)$", message = "Gender must be Male, Female, or Other")
    private String gender;

    @PositiveOrZero(message = "Basic salary cannot be negative")
    private double basicSalary;

    @PastOrPresent(message = "Joined date cannot be in the future")
    private LocalDate joinedDate;

    @Column(nullable = false)
    private boolean active;

    @Column()
    private boolean isLock;

    @NotBlank(message = "Profile photo path is required")
    private String profilePhoto;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "Role is required")
    private Role role;


    public User(String name, String email, String password, String cell, String address, String gender, LocalDate dateOfBirth, double basicSalary, LocalDate joinedDate, boolean active, boolean isLock, String profilePhoto, Role role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.cell = cell;
        this.address = address;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.basicSalary = basicSalary;
        this.joinedDate = joinedDate;
        this.active = active;
        this.isLock = isLock;
        this.profilePhoto = profilePhoto;
        this.role = role;
    }


//    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
//    @JsonIgnore
//    private List<Attendance> attendances;

    @OneToMany(mappedBy = "user")
    private List<Token> tokens;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
//        return UserDetails.super.isAccountNonLocked();
        return true;  // Nirjash
//        return isLock;  // Sir
    }

    @Override
    public boolean isCredentialsNonExpired() {
//        return UserDetails.super.isCredentialsNonExpired();
        return true;
    }

    @Override
    public boolean isEnabled() {
//        return UserDetails.super.isEnabled();
        return active;
    }

}
