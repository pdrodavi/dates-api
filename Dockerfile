# STAGE 1: Build com Maven
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Diretório de trabalho
WORKDIR /app

# Copia pom e fontes
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw .
COPY src/ src/

# Build da aplicação
RUN mvn clean package -DskipTests

# STAGE 2: Runtime leve
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copia o JAR da build anterior
COPY --from=build /app/target/*.jar app.jar

# Porta exposta pela API
EXPOSE 8080

# Inicialização da app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
