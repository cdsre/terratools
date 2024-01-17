FROM golang:1.22rc1-bookworm

# set time to follow GB DST
RUN ln -sf /usr/share/zoneinfo/GB /etc/localtime

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    software-properties-common=0.96.20.2-2 \
    gnupg=2.2.12-1+deb10u2 \
    curl=7.64.0-4+deb10u6 \
    jq=1.5+dfsg-2+b1 \
    unzip=6.0-23+deb10u2 && \
    apt-get clean && rm -rf "/var/lib/apt/lists/*"

# Install terraform and add hashicorp repo
ARG TERRAFORM_VERSION=1.5.5-1
ARG VAULT_VERSION=1.14.1-1
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install --no-install-recommends -y terraform="${TERRAFORM_VERSION}" vault="${VAULT_VERSION}" && \
    apt-get clean && rm -rf "/var/lib/apt/lists/*"

# This is added due to an known issue with vault https://github.com/hashicorp/vault/issues/10924
RUN setcap -r /usr/bin/vault

# Install Terragrunt - You can get the latest release from https://github.com/gruntwork-io/terragrunt/releases
# Set the ARG variables
ARG TERRAGRUNT_VERSION="v0.54.12"
ARG TERRAGRUNT_SHA256="70fe63eaee52f47f0b4b84b2e35c3e7071f214adab58c810ef052d4f1eb87d53"
ARG TERRAGRUNT_LOCATION="/usr/local/bin/terragrunt"
ARG DOWNLOADED_FILE="/tmp/terragrunt_linux_amd64"

# Download the file and verify checksum
RUN curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" -o "${DOWNLOADED_FILE}" && \
    CALCULATED_SHA256=$(sha256sum "${DOWNLOADED_FILE}" | awk '{print $1}') && \
    if [ "${CALCULATED_SHA256}" != "${TERRAGRUNT_SHA256}" ]; then  \
      echo "Checksum verification failed. The downloaded file may be corrupted or modified.";  \
      exit 1;  \
    fi && \
    mv "${DOWNLOADED_FILE}" "${TERRAGRUNT_LOCATION}" && \
    chmod ugo+x "${TERRAGRUNT_LOCATION}"

# create an app user so not to run as root and set the GO path
ARG USER=terraform
ARG GROUP=terraform
RUN groupadd -g 8256 "${GROUP}" && useradd --create-home -u 8256 -g 8256 "${USER}"
USER "${USER}"
WORKDIR "/home/${USER}"

ENTRYPOINT [""]
CMD ["/bin/bash"]