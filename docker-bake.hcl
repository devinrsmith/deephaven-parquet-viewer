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

// Allows CI to set this
// https://github.com/docker/metadata-action?tab=readme-ov-file#bake-definition
target "docker-metadata-action" {}

target "deephaven-parquet-viewer" {
    inherits = ["docker-metadata-action"]
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
