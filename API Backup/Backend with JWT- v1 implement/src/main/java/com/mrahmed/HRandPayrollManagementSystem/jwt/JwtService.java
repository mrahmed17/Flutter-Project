package com.mrahmed.HRandPayrollManagementSystem.jwt;

import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.TokenRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.function.Function;

@Service
public class JwtService {

    @Autowired
    private TokenRepository tokenRepository;

    private final String SECREAT_KEY = "d169552a202ace4ed9b31a326df08atamim3e197a10213030f7c4be596ba99b6";

//    private Claims extractAllClaims(String token) {
//        return Jwts
//                .parser()
//                .verifyWith(getSigninKey())
//                .build()
//                .parseSignedClaims(token)
//                .getPayload();
//
//    }

    private Claims extractAllClaims(String token) {
        return Jwts
                .parser()
                .setSigningKey(getSigninKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }


    // Gets the signing key for HMAC SHA encryption
    private SecretKey getSigninKey() {
        byte[] keyBytes = Decoders.BASE64URL.decode(SECREAT_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }


    // Generates JWT token with the user's email and role
    public String generateToken(User user) {
        return Jwts
                .builder()
                .setSubject(user.getEmail())  // Sets the email as the subject
                .claim("role", user.getRole())  // Adds the user's role to the token payload
                .setIssuedAt(new Date(System.currentTimeMillis()))  // Sets the issue time
                .setExpiration(new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000))  // Sets expiration to 24 hours
                .signWith(getSigninKey())  // Signs the token with the secret key
                .compact();  // Builds and compacts the token into a string
    }


    // Extracts username from JWT token
    public String extractUsername(String token) {

        return extractClaim(token, Claims::getSubject);
    }

    // Extracts expiration date from the token
    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
    // Checks if the token is expired
    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }


    // Validates whether the token is valid for a given user
    public boolean isValid(String token, UserDetails user) {
        String username = extractUsername(token);

        // Check if the token is valid and not expired
        boolean validToken = tokenRepository
                .findByToken(token)
                .map(t -> !t.isLoggedOut())
                .orElse(false);

        return (username.equals(user.getUsername())) && !isTokenExpired(token) && validToken;
    }

    // Extracts a specific claim from the token's claims
    public <T> T extractClaim(String token, Function<Claims, T> resolver) {
        Claims claims = extractAllClaims(token);
        return resolver.apply(claims);
    }

    // Extracts the user's role from the token
    public String extractUserRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }


}
