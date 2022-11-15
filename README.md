# dehydrated

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/dehydrated/status.svg)](https://drone.owncloud.com/owncloud-ops/dehydrated/)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/dehydrated)

Custom container image for Dehydrated.

## Ports

## Volumes

- /opt/app/dehydrated/conf.d
- /opt/app/dehydrated/conf
- /opt/app/dehydrated/data

## Environment Variables

```Shell
DEHYDRATED_CA=https://acme-v02.api.letsencrypt.org/directory
DEHYDRATED_CONTACT_EMAIL=le@example.com
DEHYDRATED_IP_VERSION=4
DEHYDRATED_RENEW_DAYS=30
DEHYDRATED_PRIVATE_KEY_RENEW=yes
DEHYDRATED_PRIVATE_KEY_ROLLOVER=no
DEHYDRATED_KEY_ALGO=prime256v1
DEHYDRATED_OCSP_MUST_STAPLE=no
DEHYDRATED_OCSP_FETCH=no
DEHYDRATED_AUTO_CLEANUP=no
DEHYDRATED_API=auto
```

## Build

```Shell
docker build -f Dockerfile -t dehydrated:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/dehydrated/blob/main/LICENSE) file for details.
