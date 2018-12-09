FROM alpine:3.8

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.
ENV ALPINE_GLIBC_BASE_URL="https://github.com/yangxuan8282/alpine-pkg-glibc/releases/download" \
    ALPINE_GLIBC_PACKAGE_VERSION="2.27-r0"

ENV ALPINE_GLIBC_PACKAGE_VERSION_FILE="${ALPINE_GLIBC_PACKAGE_VERSION}"
ENV ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION_FILE.apk" \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION_FILE.apk" \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION_FILE.apk" \
    JAVA_VERSION=8 \
    JAVA_UPDATE=192 \ 
    JAVA_BUILD=12 \ 
    JAVA_PATH=750e1c8617c5452694857ad95c3ee230 \ 
    JAVA_HOME="/usr/lib/jvm/default-jvm" \
    LANG=C.UTF-8

RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME"  \
         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --allow-untrusted --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    apk del glibc-i18n && \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm  "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache --virtual=build-dependencies wget ca-certificates unzip 
    # && \
    # cd /tmp && \
    # wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" "https://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-arm32-vfp-hflt.tar.gz" && \
    # cd /tmp && tar -xzf "jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-arm32-vfp-hflt.tar.gz" && \
    # mkdir -p "/usr/lib/jvm" && \
    # mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" && \
    # ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    # ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    # rm -rf "$JAVA_HOME/"*src.zip && \
    # wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
    #     "https://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION}/jce_policy-${JAVA_VERSION}.zip" && \
    # unzip -jo -d "${JAVA_HOME}/jre/lib/security" "jce_policy-${JAVA_VERSION}.zip" && \
    # rm "${JAVA_HOME}/jre/lib/security/README.txt" && \
    # apk del build-dependencies && \
    # rm "/tmp/"* && \
    # echo 'public class Main { public static void main(String[] args) { System.out.println("Java code is running fine!"); } }' > Main.java && \
    # javac Main.java && \
    # java Main && \
    # rm -r "/tmp/"*