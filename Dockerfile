FROM n8nio/runners:2.4.4

USER root

# Install JS deps into the JavaScript task runner workspace
RUN cd /opt/runners/task-runner-javascript && pnpm add osmtogeojson polygon-clipping axios

# Runner launcher config
COPY --chown=runner:runner n8n-task-runners.json /etc/n8n-task-runners.json
RUN chmod 644 /etc/n8n-task-runners.json

USER runner
