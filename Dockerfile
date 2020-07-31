FROM openshift/base-centos7

ENV CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.45.1

LABEL io.k8s.description="Platform for building Rust Applications" \
     io.k8s.display-name="Rust 1.45.1" \
     io.openshift.expose-services="8000:http" \
     io.openshift.tags="rust" \
     io.openshift.s2i.assemble-input-files="/opt/app-root/src/target/release"

RUN set -eux; \
    yum install -y file openssl-devel; \
    curl https://static.rust-lang.org/rustup/archive/1.21.1/x86_64-unknown-linux-gnu/rustup-init -sSf > /tmp/rustup-init.sh; \
    echo "ad1f8b5199b3b9e231472ed7aa08d2e5d1d539198a15c5b1e53c746aad81d27b  /tmp/rustup-init.sh" | sha256sum -c -; \
    chmod +x /tmp/rustup-init.sh; \
    /tmp/rustup-init.sh -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    chmod -R a+w $CARGO_HOME; \
    rm /tmp/rustup-init.sh; \
    yum clean all -y

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way
COPY ./s2i/bin/ /usr/libexec/s2i

# This default user is created in the openshift/base-centos7 image
USER 1001
CMD ["usage"]
