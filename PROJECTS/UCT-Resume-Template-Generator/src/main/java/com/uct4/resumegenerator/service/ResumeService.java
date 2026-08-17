package com.uct4.resumegenerator.service;

import com.uct4.resumegenerator.model.ResumeRequest;
import com.uct4.resumegenerator.model.ResumeResponse;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.List;

@Service
public class ResumeService {

    public List<String> availableTemplates() {
        return List.of("modern", "minimal", "executive");
    }

    public ResumeResponse buildResume(ResumeRequest request) {
        String template = request.template() == null || request.template().isBlank()
                ? "modern"
                : request.template().trim().toLowerCase();

        List<String> sections = List.of(
                "Summary: " + request.summary(),
                "Skills: " + String.join(", ", request.skills()),
                "Experience: " + String.join(" | ", request.experienceHighlights())
        );

        String headline = request.professionalTitle() + " | " + request.fullName();

        return new ResumeResponse(
                request.fullName(),
                request.professionalTitle(),
                template,
                headline,
                request.location(),
                request.phoneNumber(),
                request.educationLevel(),
                sections,
                request.workExperiences(),
                request.educations(),
                request.certifications(),
                request.hobbies(),
                OffsetDateTime.now().toString()
        );
    }
}