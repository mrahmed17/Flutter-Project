package com.mrahmed.HRandPayrollManagementSystem.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "users")
public class User implements UserDetails, Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

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

    @JsonDeserialize(keyUsing = Salary.LeaveTypeKeyDeserializer.class)
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "user_leave_balance", joinColumns = @JoinColumn(name = "user_id"))
    @MapKeyColumn(name = "leave_type")
    @Column(name = "remaining_days")
    private Map<LeaveType, Integer> leaveBalance = new HashMap<>();

    @NotBlank(message = "Profile photo path is required")
    private String profilePhoto;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "Role is required")
    private Role role;

    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER)
    @JsonIgnore
    private List<Attendance> attendances;


//    JWT Start from here
    @Column(nullable = false)
    private boolean active;

    @Column()
    private boolean isLock;

    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER)
    @JsonIgnore
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
//        return true;  // NirjashBro
//        return isLock;  // Sir
        return !isLock;  // bigBro
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return active;
    }

    public User(Long id) {
        this.id = id;
    }

}
