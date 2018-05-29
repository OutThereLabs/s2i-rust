
FROM openshift/base-centos7

ENV RUST_VERSION=nightly-2018-05-14 \
    CARGO_HOME=$HOME/.cargo \
    PATH=$HOME/.cargo/bin:$PATH

LABEL io.k8s.description="Platform for building Rust Applications" \
     io.k8s.display-name="Rust nightly-2018-05-14" \
     io.openshift.expose-services="8000:http" \
     io.openshift.tags="rust" \
     io.openshift.s2i.assemble-input-files="/opt/app-root/src/target/release"

RUN set -x \
    && yum install -y file \
    && curl -sSf https://static.rust-lang.org/rustup.sh > /tmp/rustup.sh \
    && chmod +x /tmp/rustup.sh \
    && /tmp/rustup.sh  --disable-sudo --yes --revision="nightly-2018-05-14" \
    && rm /tmp/rustup.sh \
    && yum clean all -y

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way
COPY ./s2i/bin/ /usr/libexec/s2i
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001
CMD ["usage"]
