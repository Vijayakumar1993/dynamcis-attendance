package com.attendence.Attendance.configuration;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.AuthoritiesRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.time.LocalDate;
import java.util.Base64;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Configuration
public class Configurer implements WebMvcConfigurer {

    private static final Logger log = LoggerFactory.getLogger(Configurer.class);
    @Value("${spring.datasource.url}")
    private String url;
    @Value("${spring.datasource.username}")
    private String username;
    @Value("${spring.datasource.password}")
    private String password;

    @Autowired
    private LoginRepositary loginRepositary;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private Utility utility;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new HandlerInterceptor() {
            @Override
            public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
                String baseUrl = request.getScheme() + "://" +
                        request.getServerName() + ":" +
                        request.getServerPort();
                HttpSession session = request.getSession();
                session.setAttribute("baseUrl", baseUrl);
                Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
                String userLoginId = authentication.getName();
                session.setAttribute("util", utility);
                List<Users> users = loginRepositary.findByUsername(userLoginId);
                if (users.size() > 0) {
                    Users user = users.get(0);
                    session.setAttribute("userLogin", user.getCustomerId());
                    session.setAttribute("Base64UtilEncoder", Base64.getEncoder());
                    session.setAttribute("authorities", authentication.getAuthorities()
                            .stream()
                            .map(GrantedAuthority::getAuthority)
                            .collect(Collectors.toSet()));
                }
                return true;
            }
        });
    }

    @Bean
    public JdbcUserDetailsManager userDetailsManager() {
        return new JdbcUserDetailsManager(DataSourceBuilder.create()
                .url(url)
                .username(username)
                .password(password)
                .build());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity security) throws Exception {
        return security
                .csrf(httpSecurityCsrfConfigurer -> httpSecurityCsrfConfigurer.disable())
                .authorizeHttpRequests(authorizationManagerRequestMatcherRegistry
                        -> authorizationManagerRequestMatcherRegistry
                        // 1. Public resources
                        .requestMatchers("/css/**", "/images/**", "/login").permitAll()

                        // 2. STUDENT-only
                        .requestMatchers(
                                "/person/student",
                                "/attendance/**",
                                "/lead-management/**",
                                "/lookup/**"
                        ).hasAnyRole("ADMIN","STUDENT","EMPLOYEE")

                        // 3. PLAYER-only
                        .requestMatchers("/person").hasAnyRole("ADMIN","PLAYER")

                        // 4. Shared access (COACH, STUDENT, ADMIN, PLAYER)
                        .requestMatchers(
                                "/customer/viewCustomer/**",
                                "/customer/editCustomer/**",
                                "/customer/addCustomer",
                                "/documents/**"
                        ).hasAnyRole("COACH", "STUDENT", "ADMIN", "PLAYER")

                        // 5. COACH-only
                        .requestMatchers(
                                "/competition/display/**",
                                "/control/coachDashboard",
                                "/competition/enrollCompetition/**",
                                "/competition/rejectCompetition/**",
                                "/competition/revokeCompetition/**",
                                "/teams/viewTeam/**",
                                "/teams/selection/**",
                                "/teams/viewTeams",
                                "/fixtureGateway/createTeamCompCustomer",
                                "/fixture/createPlayer"
                        ).hasAnyRole("ADMIN","COACH")

                        // 6. ADMIN-only (MUST BE LAST before anyRequest)
                        .requestMatchers(
                                "/control/**",
                                "/customer/**",
                                "/authorities/**",
                                "/attendance/**",
                                "/competition/**",
                                "/settings/**",
                                "/financials/**",
                                "/fixture/**",
                                "/lookup/**",
                                "/matches/**",
                                "/payment/**",
                                "/reports/**",
                                "/fixtureGateway/**",
                                "/teams/**",
                                "/login/createLogin/**"
                        ).hasRole("ADMIN")
                        .anyRequest().authenticated())
                .formLogin(log -> log
                        .loginPage("/login")
                        .loginProcessingUrl("/doLogin")
                        .failureHandler((request, response, exception) -> {
                            request.getSession().setAttribute("errorMessage", "Invalid username or password");
                            response.sendRedirect("/login");
                        }).successHandler((HttpServletRequest request, HttpServletResponse response, Authentication authentication) -> {
                            Set<String> roles =
                                    AuthorityUtils.authorityListToSet(authentication.getAuthorities());
                            if (roles.contains("ROLE_ADMIN")) {
                                response.sendRedirect("/control");
                            } else if (roles.contains("ROLE_PLAYER")) {
                                response.sendRedirect("/person");
                            } else if (roles.contains("ROLE_COACH")) {
                                response.sendRedirect("/control/coachDashboard");
                            } else if (roles.contains("ROLE_STUDENT")) {
                                response.sendRedirect("/person/student");
                            } else {
                                response.sendRedirect("/access-denied");
                            }
                        })
                        .permitAll())
                .httpBasic(Customizer.withDefaults())
                .logout(httpSecurityLogoutConfigurer -> httpSecurityLogoutConfigurer
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login")
                        .permitAll())
                .build();
    }

    @Bean
    public CommandLineRunner initRunner(AuthoritiesRepositary authoritiesRepositary, LoginRepositary repositary, PasswordEncoder encoder) {
        return args -> {
            List<Users> users = repositary.findByUsername("admin");
            if (users.size() <= 0) {
                Customer admin = new Customer("admin", "no_reply@gmail.com", "000000");
                admin.setJoiningDate(LocalDate.now());
                admin.setStatus("ACTIVE");
                admin.setGender("male");
                admin.setWeight(0f);
                admin.setPack("28");
                customerRepostitary.save(admin);
                Users users1 = new Users("admin", encoder.encode("admin"), true);
                users1.setCustomerId(customerRepostitary.findByNameContaining("admin").get(0));
                Authorities adminAuthorities = new Authorities("admin", Roles.ROLE_ADMIN, admin);
                repositary.save(users1);
                authoritiesRepositary.save(adminAuthorities);
            }
        };
    }
}
