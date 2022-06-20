TARGET_ARCH=$1

other_archs=(aarch64 alpha arm armeb cris i386 m68k microblaze microblazeel mips mips64 \
    mips64el mipsel mipsn32 mipsn32el or32 ppc ppc64 ppc64abi32 ppc64le s390x sh4 sh4eb \
    sparc sparc32plus sparc64 unicore32 x86_64)

is_support=0
for i in ${other_archs[*]}; do
    if [ w"$TARGET_ARCH" == w"$i" ]
    then
      is_support=1
      break
    fi
done

if [ $is_support -eq 0 ]
then
  echo "unsupport arch: $TARGET_ARCH"
  exit
else
  echo "build target arch: $TARGET_ARCH"
fi

image_lists=`docker images --format  "{{.Repository}}:{{.Tag}}"`
for i in $image_lists
do
  if [ w"$i" == "waflplusplus/aflplusplus:latest" ]
  then
    cur_cmmtid=`docker run -it --rm aflplusplus/aflplusplus:latest git rev-parse --short HEAD | tr -d '\r'`
    echo "rename the tag: aflplusplus/aflplusplus:$cur_cmmtid"
    docker tag aflplusplus/aflplusplus:latest aflplusplus/aflplusplus:$cur_cmmtid
    docker rmi aflplusplus/aflplusplus:latest
    break
  fi
done
docker pull aflplusplus/aflplusplus:latest
cur_cmmtid=`docker run -it --rm aflplusplus/aflplusplus:latest git rev-parse --short HEAD | tr -d '\r'`

echo "The current commit id is" $cur_cmmtid

# build images with privileged mode
# docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure'
docker buildx use insecure-builder
docker buildx build --allow security.insecure .\
 --build-arg TARGET_ARCH=$TARGET_ARCH \
 -o type=docker  --platform linux/amd64 \
 -t yourbutterfly/aflplusplus-other-arch:${cur_cmmtid}_${TARGET_ARCH}

# docker buildx rm insecure-builder
