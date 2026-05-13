# CI/CD Demo

Demo project for testing, building, and publishing a simple Node.js Hello World app using Docker and CI/CD.

## Project Overview

This project contains a simple `app.js` file, a `test.js` file, and a `Dockerfile`.

The CI/CD pipeline runs the test first. If the test passes, it builds a Docker image and pushes the image to Docker Hub.

## Project Structure

```text

ci-cd-demo/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── Dockerfile
├── README.md
├── app.js
├── package-lock.json
├── package.json
└── test.js
