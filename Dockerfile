FROM eclipse-temurin:20.0.1_9-jdk-alpine@sha256:15e3e204c41383dd2424730a1e1c8da3315ba2cf6f4be3cb0873b76d2e56e622 AS builder

ARG SPRING_PROFILES_ACTIVE
ARG APP_PORT
ARG DB_PORT
ARG ROOT_USERNAME
ARG ROOT_PASSWORD

WORKDIR /build

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN ./mvnw dependency:go-offline

COPY src src

RUN ./mvnw clean package -DskipTests -P${SPRING_PROFILES_ACTIVE} \
    -DAPP_PORT=${APP_PORT} -DDB_PORT=${DB_PORT} -DROOT_USERNAME=${ROOT_USERNAME} -DROOT_PASSWORD=${ROOT_PASSWORD}

RUN cp /build/target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

FROM eclipse-temurin:20.0.1_9-jre-alpine@sha256:9e0e03b2d3222f54a7a222cd2bd16301d1653be508b84d62487383bb7e420be2

ARG SPRING_PROFILES_ACTIVE
ENV SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}

WORKDIR /app

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk --no-cache add shadow && \
    addgroup -S spring &&  \
    adduser -S spring -G spring && \
    usermod -a -G spring root && \
    mkdir logs

COPY --from=builder /build/dependencies/ ./
COPY --from=builder /build/spring-boot-loader/ ./
COPY --from=builder /build/snapshot-dependencies/ ./
COPY --from=builder /build/application/ ./

RUN chown -R spring:spring /app

USER spring:spring
ENTRYPOINT ["java","-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}","org.springframework.boot.loader.JarLauncher"]