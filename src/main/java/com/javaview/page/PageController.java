package com.javaview.page;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PageController {

    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }

    // POST /login and POST /logout are handled by Spring Security (see SecurityConfig)
    @GetMapping("/login")
    public String login(@RequestParam(required = false) String error,
                        Authentication authentication,
                        CsrfToken csrf,
                        Model model) {

        if (authentication != null) {
            return "redirect:/secured";
        }
        model.addAttribute("csrf", csrf);
        model.addAttribute("error", error != null);
        return "login";
    }

    @GetMapping("/secured")
    public String secured(Authentication authentication, CsrfToken csrf, Model model) {

        List<String> authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .toList();

        model.addAttribute("csrf", csrf);
        model.addAttribute("authorities", authorities);
        return "secured";
    }
}
