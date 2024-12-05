// package com.example.industria.config;

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// import org.springframework.security.crypto.password.NoOpPasswordEncoder;
// import org.springframework.security.web.SecurityFilterChain;
// import com.example.industria.services.CustomUserDetailsService;

// @Configuration
// @EnableWebSecurity
// public class SecurityConfig {

//     private final CustomUserDetailsService userDetailsService;

//     public SecurityConfig(CustomUserDetailsService userDetailsService) {
//         this.userDetailsService = userDetailsService;
//     }

//     @Bean
//     public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//         http.authorizeHttpRequests(auth -> auth
//                 .requestMatchers("/","/login", "/css/**").permitAll()
//                 .anyRequest().authenticated())
//                 .formLogin(form -> form
//                         .loginPage("/login")
//                         .permitAll());

//         return http.build();
//     }
// }
