# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs freetype fontconfig --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all && \
    rpm --root /mnt/rootfs -e --nodeps setup

FROM quay.io/keycloak/keycloak:latest
COPY --from=ubi-micro-build /mnt/rootfs /
COPY ./target/keycloak-captcha-0.0.1-SNAPSHOT-jar-with-dependencies.jar /opt/keycloak/providers
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
# ENV HTTPS_PROXY=http://10.222.60.83:3128
# ENV HTTP_PROXY=http://10.222.60.83:3128
CMD ["start-dev"]