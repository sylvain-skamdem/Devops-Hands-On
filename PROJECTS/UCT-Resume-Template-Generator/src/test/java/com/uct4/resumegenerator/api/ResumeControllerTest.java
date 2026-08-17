package com.uct4.resumegenerator.api;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class ResumeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldListTemplates() throws Exception {
        mockMvc.perform(get("/api/v1/resumes/templates"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0]").value("modern"))
                .andExpect(jsonPath("$[1]").value("minimal"));
    }

    @Test
    void shouldGenerateResumePreview() throws Exception {
        String payload = """
                {
                  "fullName": "Alex Johnson",
                  "professionalTitle": "Senior Java Engineer",
                  "summary": "Builds scalable APIs for career products.",
                  "skills": ["Java", "Spring Boot", "OpenAPI"],
                  "experienceHighlights": ["Designed resume parsing service", "Reduced API latency by 35%"],
                  "template": "executive"
                }
                """;

        mockMvc.perform(post("/api/v1/resumes/preview")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(payload))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.candidateName").value("Alex Johnson"))
                .andExpect(jsonPath("$.template").value("executive"))
                .andExpect(jsonPath("$.sections[1]").value("Skills: Java, Spring Boot, OpenAPI"));
    }

    @Test
    void shouldRejectInvalidPayload() throws Exception {
        String payload = """
                {
                  "fullName": "",
                  "professionalTitle": "",
                  "summary": "",
                  "skills": [],
                  "experienceHighlights": []
                }
                """;

        mockMvc.perform(post("/api/v1/resumes/preview")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(payload))
                .andExpect(status().isBadRequest());
    }
}