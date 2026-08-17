# Resume Generator Service

A Spring Boot microservice that generates structured resume previews via a REST API, served alongside a browser-based UI. Packaged as a WAR for deployment to an external Tomcat 10+ server.

## Stack

| Layer | Technology |
|---|---|
| Language | Java 25 (LTS) |
| Framework | Spring Boot 3.5.13 |
| Build tool | Maven 3.9+ |
| API docs | springdoc-openapi (Swagger UI) |
| Testing | JUnit 5 / MockMvc |
| Frontend | Vanilla HTML/CSS/JS (served as static resource) |

## Prerequisites

- JDK 25
- Maven 3.9+
- Apache Tomcat 10.1+ (kept **outside** the project folder)

## Build

```bash
mvn clean package -DskipTests
```

WAR output:

```
target/resume-generator-service.war
```

## Deploy to Tomcat (Linux)

```bash
export JAVA_HOME=/path/to/jdk-25
export CATALINA_HOME=/path/to/apache-tomcat-10.1.x

cp target/resume-generator-service.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/startup.sh
```

Once started, the app is available at:

```
http://<your-server>:8080/resume-generator-service/
```

> To run Tomcat on port 80 without root, use a reverse proxy (nginx/Apache) or set `port="80"` in `$CATALINA_HOME/conf/server.xml` and run Tomcat as a privileged service.

## Web UI

Open the browser UI to fill in candidate details and generate a resume preview:

```
http://<your-server>:8080/resume-generator-service/index.html
```

Features:
- Live resume preview (right panel updates on generate)
- Dynamic rows for Work Experience, Education, and Certifications
- Download resume as **HTML**, **PDF** (browser print), or **Word (.doc)**

## API Endpoints

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/v1/resumes/templates` | List available templates |
| `POST` | `/api/v1/resumes/preview` | Generate a resume preview |

### POST `/api/v1/resumes/preview` — full request example

```json
{
  "fullName": "Alex Johnson",
  "professionalTitle": "Senior Java Engineer",
  "summary": "Builds scalable APIs for career products.",
  "skills": ["Java", "Spring Boot", "Docker"],
  "experienceHighlights": ["Designed resume parsing service", "Reduced API latency by 35%"],
  "template": "modern",
  "location": "Austin, TX",
  "phoneNumber": "+1 (512) 555-0100",
  "hobbies": ["Reading", "Hiking"],
  "workExperiences": [
    { "title": "Software Engineer", "company": "Acme Corp", "startDate": "Jan 2020", "endDate": "Present" }
  ],
  "educations": [
    { "degree": "B.Sc. Computer Science", "institution": "MIT", "startYear": "2016", "endYear": "2020" }
  ],
  "certifications": [
    { "name": "AWS Solutions Architect", "provider": "Amazon Web Services", "obtainDate": "Mar 2023", "expirationDate": "Mar 2026" }
  ]
}
```

Available templates: `modern`, `minimal`, `executive`

## OpenAPI / Swagger UI

- Swagger UI: `http://localhost:8080/resume-generator-service/swagger-ui.html`
- OpenAPI JSON: `http://localhost:8080/resume-generator-service/api-docs`

## Run Tests

```bash
mvn test
```

Three tests are included: list templates, generate preview, reject invalid payload.

## Project Structure

| Path | Role |
|---|---|
| `pom.xml` | Maven build descriptor — dependencies, Java version, WAR packaging |
| `.gitignore` | Excludes build output, IDE files, secrets, and server runtimes from git |
| `README.md` | Project documentation (this file) |
| `src/main/java/com/uct4/resumegenerator/` | Root Java package |
| `ResumeGeneratorApplication.java` | Spring Boot entry point; extends `SpringBootServletInitializer` for WAR deployment |
| `api/ResumeController.java` | REST controller — exposes `GET /templates` and `POST /preview` endpoints |
| `model/ResumeRequest.java` | Validated input record — all fields a client sends to generate a resume |
| `model/ResumeResponse.java` | Output record — structured resume data returned to the client |
| `model/Certification.java` | Nested record — certification name, provider, obtained date, expiration date |
| `model/Education.java` | Nested record — degree, institution, start year, end year |
| `model/WorkExperience.java` | Nested record — job title, company, start date, end date |
| `service/ResumeService.java` | Business logic — builds the `ResumeResponse` from the incoming `ResumeRequest` |
| `src/main/resources/application.properties` | Spring Boot configuration — app name, Swagger UI path, API docs path |
| `src/main/resources/static/index.html` | Browser UI — two-panel form + live preview with download buttons (HTML/PDF/Word) |
| `src/test/java/.../api/ResumeControllerTest.java` | Integration tests — list templates, generate preview, reject invalid payload |