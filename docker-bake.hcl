group "default" {
    targets = [
        "deephaven-parquet-viewer"
    ]
}

group "release" {
    targets = [
        "deephaven-parquet-viewer-release"
    ]
}

variable "REPO_PREFIX" {
    default = ""
}

variable "IMAGE_NAME" {
    default = "deephaven-parquet-viewer"
}

variable "CACHE_PREFIX" {
    default = "deephaven-parquet-viewer-"
}

target "deephaven-parquet-viewer" {
    tags = [
        "${REPO_PREFIX}${IMAGE_NAME}:latest"
    ]
}

target "deephaven-parquet-viewer-release" {
    inherits = [ "deephaven-parquet-viewer" ]
    cache-from = [ "type=gha,scope=${CACHE_PREFIX}deephaven-parquet-viewer" ]
    cache-to = [ "type=gha,mode=max,scope=${CACHE_PREFIX}deephaven-parquet-viewer" ]
    platforms = [ "linux/amd64", "linux/arm64" ]
}
