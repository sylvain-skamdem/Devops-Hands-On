package com.uct4.resumegenerator.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public record ResumeRequest(
        @NotBlank String fullName,
        @NotBlank String professionalTitle,
        @NotBlank String summary,
        @NotEmpty List<@NotBlank String> skills,
        @NotEmpty List<@NotBlank String> experienceHighlights,
        String template,
        String location,
        String phoneNumber,
        String educationLevel,
        List<WorkExperience> workExperiences,
        List<Education> educations,
        List<Certification> certifications,
        List<String> hobbies
) {
}