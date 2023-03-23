FROM rust:1.67 AS builder

COPY . /checker-compile
WORKDIR /checker-compile

RUN cargo build --release

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /lira-checker
COPY --from=builder /checker-compile/target/release/lira-checker /lira-checker/checker

RUN groupadd --system checker && useradd --system checker --gid checker && chown -R checker:checker /lira-checker
USER checker:checker

WORKDIR /lira-checker
CMD ["./checker"]