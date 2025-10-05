pipeline {
  agent {
    kubernetes {
      label 'node-lts-erbium'
      defaultContainer 'node'
    }
  }

  parameters {
    string(name: 'BUILD_VERSION', description: 'The version to build')
  }

  environment {
    PROJECT = 'learninglocker'
    MAIN_BRANCH = 'master'
    SOURCE_DIRECTORY = 'api'
    DOCKER_REGISTRY = 'harbor.dltv.ac.th'
    REGISTRY_CREDENTIALS = 'registry-credentials'
  }

  stages {
    // stage('Install') {
    //   when {
    //     anyOf {
    //       changeRequest target: MAIN_BRANCH
    //       branch MAIN_BRANCH
    //     }
    //   }
    //   steps {
    //     sh "npm_config_build_from_source=true yarn install --ignore-engines --frozen-lockfile"
    //   }
    // }

    // stage('Build') {
    //   when {
    //     anyOf {
    //       changeRequest target: MAIN_BRANCH
    //       branch MAIN_BRANCH
    //     }
    //   }
    //   steps {
    //     sh "yarn build-api-server"
    //   }
    // }

    // stage('Lint') {
    //   when {
    //     anyOf {
    //       changeRequest target: MAIN_BRANCH
    //       branch MAIN_BRANCH
    //     }
    //   }
    //   steps {
    //     sh "yarn lint-ci"
    //   }
    // }

    // stage('Test') {
    //   when {
    //     anyOf {
    //       changeRequest target: MAIN_BRANCH
    //       branch MAIN_BRANCH
    //     }
    //   }
    //   steps {
    //     sh "yarn test"
    //   }
    // }

    stage("Build") {
      when { 
        branch MAIN_BRANCH
      }
      steps {
        script {
          def SERVICES = ['api', 'ui', 'worker']
          for (int i = 0; i < SERVICES.size(); i++) {
            def SERVICE = SERVICES[i]
            def DOCKER_IMAGE = "${DOCKER_REGISTRY}/${PROJECT}/${SERVICE}"

            stage("Build docker image - ${SERVICE}") {
              steps {
                container('dind') {
                  sh "docker build -t ${DOCKER_IMAGE}:${params.BUILD_VERSION} -f ${SERVICE}/Dockerfile ."
                }
              }
            }

            stage("Publish docker image - ${SERVICE}") {
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
  }
}
