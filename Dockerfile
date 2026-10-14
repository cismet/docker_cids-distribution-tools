FROM docker:29

COPY /copy/*.sh /

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /cidsDistribution

LABEL maintainer="Jean-Michel Ruiz <jean.ruiz@cismet.de>"