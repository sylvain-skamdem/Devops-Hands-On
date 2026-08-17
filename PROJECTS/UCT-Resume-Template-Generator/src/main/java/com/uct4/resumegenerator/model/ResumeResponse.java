package com.uct4.resumegenerator.model;

import java.util.List;

public record ResumeResponse(
        String candidateName,
        String professionalTitle,
        String template,
        String headline,
        String location,
        String phoneNumber,
        String educationLevel,
        List<String> sections,
        List<WorkExperience> workExperiences,
        List<Education> educations,
        List<Certification> certifications,
        List<String> hobbies,
        String generatedAt
) {
}