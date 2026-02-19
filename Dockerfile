# Stage 0: provide apk tooling + libs (workaround when base image lacks apk)
FROM alpine:3.22 AS alpine

# Stage 1: your custom runner
FROM n8nio/runners:latest

USER root

# If the base image doesn't have apk, copy it in (safe even if it already exists)
COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

# Install robust SVG rasterizer + basic fonts
# rsvg-convert is in librsvg-utils
RUN /sbin/apk add --no-cache \
  librsvg \
  librsvg-utils \
  cairo \
  pango \
  fontconfig \
  ttf-dejavu

# Your existing JS deps
RUN cd /opt/runners/task-runner-javascript && \
  pnpm add @turf/turf osmtogeojson polygon-clipping axios luxon markdown-it

# Runner launcher config
COPY --chown=runner:runner n8n-task-runners.json /etc/n8n-task-runners.json
RUN chmod 644 /etc/n8n-task-runners.json

USER runner
