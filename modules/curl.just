# module for downloading files with curl
download url:
    @curl \
        --silent \
        --location {{ url }} \
        --remote-name \
        --output-dir /tmp

