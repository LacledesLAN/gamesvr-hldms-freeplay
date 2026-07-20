FROM scratch AS builder

COPY ./sourcemod.linux /output/hl1mp/

COPY ./sourcemod-configs /output/hl1mp/

COPY --chown=HLDMS:root ./dist /output/


#---------------------------------
FROM lacledeslan/gamesvr-hldms

ARG BUILD_DATE=unspecified \
    BUILD_NODE=unspecified \
    GIT_REVISION=unspecified

HEALTHCHECK NONE

LABEL architecture="amd64" \
      com.lacledeslan.build-node="$BUILD_NODE" \
      maintainer="Laclede's LAN <contact@lacledeslan.com>" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.description="LL Half-Life Deathmatch Source Dedicated Freeplay Server" \
      org.opencontainers.image.revision="$GIT_REVISION" \
      org.opencontainers.image.source="https://github.com/LacledesLAN/gamesvr-hldms-freeplay" \
      org.opencontainers.image.vendor="Laclede's LAN"

COPY --chown=HLDMS:root --from=builder ./output /app/

# UPDATE USERNAME & ensure permissions
RUN usermod -l HLDMSFreeplay HLDMS && \
    chmod +x /app/ll-tests/*.sh;

USER HLDMSFreeplay

WORKDIR /app

CMD ["/bin/bash"]
