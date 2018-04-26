FROM docker:18.04.0-ce

COPY /copy/*.sh /

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /cidsDistribution

LABEL maintainer="Jean-Michel Ruiz <jean.ruiz@cismet.de>"