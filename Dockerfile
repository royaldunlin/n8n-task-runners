# Bring in apk tooling (workaround for images that may not include it)
FROM alpine:3.22 AS alpine
# (Nothing else needed; we just copy apk + libapk)

FROM n8nio/runners:latest

USER root

# Ensure apk exists (safe even if it already exists in the base image)
COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

# Install robust SVG rasterization + basic fonts
# - rsvg-convert comes from librsvg-utils
# - fonts help when SVGs reference common font families
RUN apk add --no-cache \
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
