pipeline {
  agent {
    kubernetes {
      label 'node-lts-erbium'
      defaultContainer 'node'
    }
  }

  parameters {
    string(name: 'BUILD_VERSION', description: 'The version to build')
    choice(name: 'SERVICE', choices: ['api', 'ui', 'worker'], description: 'The service to build')
  }

  environment {
    PROJECT = 'learninglocker'
    MAIN_BRANCH = 'master'
    DOCKER_REGISTRY = 'harbor.dltv.ac.th'
    DOCKER_IMAGE = "${DOCKER_REGISTRY}/${PROJECT}/${params.SERVICE}"
    REGISTRY_CREDENTIALS = 'registry-credentials'
  }

  stages {
    stage("Build docker image") {
      when {
        branch MAIN_BRANCH
      }
      steps {
        container('dind') {
          sh "docker build -t ${DOCKER_IMAGE}:${params.BUILD_VERSION} -f ${params.SERVICE}/Dockerfile ."
        }
      }
    }

    stage("Publish docker image") {
      when {
        branch MAIN_BRANCH
      }
      steps {
        container('dind') {
          script {
            docker.withRegistry("https://${DOCKER_REGISTRY}", REGISTRY_CREDENTIALS) {
              sh "docker push -a ${DOCKER_IMAGE}"
            }
          }
        }
      }
    }
  }
}
