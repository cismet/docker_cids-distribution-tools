#!bin/sh
CMD=$1; shift; PARAMS=$@
# ---
case "${CMD}" in

  prepareExt)
    /prepareExt.sh ${PARAMS}
  ;;

  buildImage)
    /buildImage.sh ${PARAMS}
  ;;
    
  updateDistribution)
    /updateDistribution.sh ${PARAMS}
  ;;

  *)
    echo "Usage: $0 { prepareExt <cids-distribution-image> | buildImage | updateDistribution <release-version> }"
    exit 1
  ;;
esac