# What is docker sftp ?

This image allow accessing named volume content through SSH.

# How to use this image

This image expose a SSH port on network and wait for connection of sftp user. It will validate authentication with keys fetch from github.

## Environment Variables

### `GITHUB_ORG`

Github organization to fetch teams from, use comma as separator and don't include spaces.

### `GITHUB_TEAM`

Teams to grant access to this container, use comma as separator and don't include spaces.

### `GITHUB_TOKEN`

Github personal access token to fetch keys. Should have `admin:org/read:org` and `admin:public_key/read:public_key` checked. Again, don't include spaces.

### `GITHUB_USERS`

Comma separated list of github login to grant access to this container. Again, don't include spaces.

### `SFTP_UID`

Numeric UID to use when accessing named volume. This UID should match the one use in container that share same named volume.
