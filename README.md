## docker-template
This is a GitHub template repo for creating Docker images using GitHub Actions. It is for those who quickly want to build a Docker image for a repo, such as a project that doesn't have a Docker image yet, or doesn't follow the best practices for Docker images.

## Features
- Fast multi-architecture support (arm64, amd64) using matrix builds
- Automated Docker image builds, running on a cron schedule
- GitHub Release and tag whenever a new version is available for renovate purposes
- Fully in public domain, see LICENSE file

## Usage
1. Click the "Use this template" button to create a new repository from this template.
2. Update the `Dockerfile` to build your desired Docker image.
3. Update the `docker-build.yml` file (in particular, the `USERNAME` and `REPO` variables to the desired repository you want to track).
