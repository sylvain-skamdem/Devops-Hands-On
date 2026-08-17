package com.uct4.resumegenerator.api;

import com.uct4.resumegenerator.model.ResumeRequest;
import com.uct4.resumegenerator.model.ResumeResponse;
import com.uct4.resumegenerator.service.ResumeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/resumes")
@Tag(name = "Resume Generator", description = "Create resume previews and inspect template options.")
public class ResumeController {

    private final ResumeService resumeService;

    public ResumeController(ResumeService resumeService) {
        this.resumeService = resumeService;
    }

    @GetMapping("/templates")
    @Operation(summary = "List templates", description = "Returns the resume templates supported by the service.")
    public List<String> templates() {
        return resumeService.availableTemplates();
    }

    @PostMapping("/preview")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generate resume preview", description = "Builds a structured resume preview from candidate details.")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Preview generated",
                    content = @Content(schema = @Schema(implementation = ResumeResponse.class))),
            @ApiResponse(responseCode = "400", description = "Invalid request payload", content = @Content)
    })
    public ResumeResponse preview(@Valid @RequestBody ResumeRequest request) {
        return resumeService.buildResume(request);
    }
}