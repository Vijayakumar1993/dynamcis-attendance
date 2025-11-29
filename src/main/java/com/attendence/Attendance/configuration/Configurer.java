package com.attendence.Attendance.configuration;

import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.AuthoritiesRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import freemarker.ext.beans.BeansWrapperBuilder;
import freemarker.template.TemplateHashModel;
import jakarta.annotation.PostConstruct;
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
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.time.LocalDate;
import java.util.List;
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
                List<Users> users = loginRepositary.findByUsername(userLoginId);
                if(users.size()>0){
                    Users user  = users.get(0);
                    Customer customer = customerRepostitary.findById(user.getCustomerId()).get();
                    session.setAttribute("userLogin",customer);
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
    public JdbcUserDetailsManager userDetailsManager(){
        return new JdbcUserDetailsManager(DataSourceBuilder.create()
                .url(url)
                .username(username)
                .password(password)
                .build());
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity security) throws Exception {
       return security
               .csrf(httpSecurityCsrfConfigurer -> httpSecurityCsrfConfigurer.disable())
                .authorizeHttpRequests(authorizationManagerRequestMatcherRegistry
                        -> authorizationManagerRequestMatcherRegistry
                        .requestMatchers("/attendance/createAttendance").hasRole("USER")
                        .requestMatchers("/attendance/addAttendance").hasRole("USER")
                        .requestMatchers("/attendance/removeSingleAttendance/**").hasRole("USER")
                        .requestMatchers("/customer/viewCustomer/**").hasRole("USER")
                        .requestMatchers("/login/updateLogin/**").hasRole("USER")
                        .requestMatchers("/login/updateLoginSetup").hasRole("USER")
                        .requestMatchers("/").hasRole("ADMIN")
                        .requestMatchers("/attendance/**").hasRole("ADMIN")
                        .requestMatchers("/customer/**").hasRole("ADMIN")
                        .requestMatchers("/payment/**").hasRole("ADMIN")
                        .requestMatchers("/login/**").hasRole("ADMIN")
                        .anyRequest().authenticated())
               .formLogin(log->log
                       .loginProcessingUrl("/login")
                       .loginProcessingUrl("/doLogin")
                       .defaultSuccessUrl("/")
                       .permitAll())
               .logout(httpSecurityLogoutConfigurer -> httpSecurityLogoutConfigurer
                       .logoutUrl("/logout")
                       .logoutSuccessUrl("/login")
                       .permitAll())
               .build();
    }

    @Bean
    public CommandLineRunner initRunner(AuthoritiesRepositary authoritiesRepositary, LoginRepositary repositary, PasswordEncoder encoder){
        return args -> {
            List<Users> users = repositary.findByUsername("admin");
            if(users.size()<=0){
                Customer admin = new Customer("admin", "no_reply@gmail.com", "000000");
                admin.setJoiningDate(LocalDate.now());
                admin.setStatus("ACTIVE");
                admin.setGender("male");
                customerRepostitary.save(admin);
                Users users1 = new Users("admin", encoder.encode("admin"),true);
                users1.setCustomerId(customerRepostitary.findByNameContaining("admin").get(0).getId());
                Authorities authorities = new Authorities("admin","ROLE_USER",admin.getId());
                Authorities adminAuthorities = new Authorities("admin","ROLE_ADMIN",admin.getId());
                repositary.save(users1);
                authoritiesRepositary.save(authorities);
                authoritiesRepositary.save(adminAuthorities);
            }
        };
    }
}
