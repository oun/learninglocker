pipeline {
  agent {
    kubernetes {
      label 'node-lts-erbium'
      defaultContainer 'node'
    }
  }

  parameters {
    string(name: 'BUILD_VERSION', defaultValue: '1.0.0', description: 'The version to build')
  }

  environment {
    PROJECT = 'learninglocker'
    SERVICES = ['api', 'ui', 'worker']
    MAIN_BRANCH = 'master'
    SOURCE_DIRECTORY = 'api'
    DOCKER_REGISTRY = 'harbor.dltv.ac.th'
    REGISTRY_CREDENTIALS = 'registry-credentials'
    IMAGE_TAG = params.BUILD_VERSION
  }

  stages {
    stage('Install') {
      when {
        anyOf {
          changeRequest target: MAIN_BRANCH
          branch MAIN_BRANCH
        }
      }
      steps {
        sh "yarn install"
      }
    }

    stage('Build') {
      when {
        anyOf {
          changeRequest target: MAIN_BRANCH
          branch MAIN_BRANCH
        }
      }
      steps {
        sh "yarn build-api-server"
      }
    }

    stage('Lint') {
      when {
        anyOf {
          changeRequest target: MAIN_BRANCH
          branch MAIN_BRANCH
        }
      }
      steps {
        sh "yarn lint-ci"
      }
    }

    stage('Test') {
      when {
        anyOf {
          changeRequest target: MAIN_BRANCH
          branch MAIN_BRANCH
        }
      }
      steps {
        sh "yarn test"
      }
    }

    script {
      for (int i = 0; i < SERVICES.size(); i++) {
        def SERVICE = SERVICES[i]
        def DOCKER_IMAGE = "${DOCKER_REGISTRY}/${PROJECT}/${SERVICE}"
        
        stage("Build docker image - ${SERVICE}") {
          when { 
            branch MAIN_BRANCH
          }
          steps {
            container('dind') {
              sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -f ${SERVICE}/Dockerfile ."
            }
          }
        }

        stage("Publish docker image - ${SERVICE}") {
          when { 
            branch MAIN_BRANCH
          }
          steps {
            container('dind') {
              docker.withRegistry("https://${DOCKER_REGISTRY}", REGISTRY_CREDENTIALS) {
                sh "docker push -a ${DOCKER_IMAGE}"
              }
            }
          }
        }
      }
    }
  }
}
