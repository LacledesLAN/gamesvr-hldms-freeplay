FROM scratch AS BUILDER

COPY ./sourcemod.linux /output/hl1mp/

COPY ./sourcemod-configs /output/hl1mp/

COPY --chown=HLDMS:root ./dist /output/

FROM lacledeslan/gamesvr-hldms

HEALTHCHECK NONE

ARG BUILD_NODE=unspecified
ARG GIT_REVISION=unspecified

LABEL architecture="amd64" \
    com.lacledeslan.build-node="$BUILD_NODE" \
    maintainer="Laclede's LAN <contact@lacledeslan.com>" \
    org.opencontainers.image.description="LL Half-Life Deathmatch Source Dedicated Freeplay Server" \
    org.opencontainers.image.revision="$GIT_REVISION" \
    org.opencontainers.image.source="https://github.com/LacledesLAN/gamesvr-hldms-freeplay" \
    org.opencontainers.image.vendor="Laclede's LAN"

COPY --chown=HLDMS:root --from=BUILDER ./output /app/

# UPDATE USERNAME & ensure permissions
RUN usermod -l HLDMSFreeplay HLDMS && \
    chmod +x /app/ll-tests/*.sh;

USER HLDMSFreeplay

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
