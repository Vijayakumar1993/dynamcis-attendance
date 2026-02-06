package com.attendence.Attendance.exception;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalUploadExceptionHandler {

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public String handleFileSizeExceeded(MaxUploadSizeExceededException ex,
                                         RedirectAttributes model,
                                         HttpServletRequest request) {

        model.addFlashAttribute("error_msg",
                "File size must be less than or equal to 1 MB");

        String referer = request.getHeader("Referer");

        return "redirect:" + referer;
    }
}
