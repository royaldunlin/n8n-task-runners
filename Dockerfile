FROM n8nio/runners:latest

USER root

# Install JS deps into the JavaScript task runner workspace
RUN cd /opt/runners/task-runner-javascript && pnpm add osmtogeojson polygon-clipping axios luxon

# Runner launcher config
COPY --chown=runner:runner n8n-task-runners.json /etc/n8n-task-runners.json
RUN chmod 644 /etc/n8n-task-runners.json

USER runner
