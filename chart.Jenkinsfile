pipeline {
  agent {
    kubernetes {
      label 'helm'
      defaultContainer 'helm'
    }
  }

  parameters {
    choice(name: 'CHART_NAME', choices: ['api', 'ui', 'worker'], description: 'Chart name')
  }

  environment {
    PROJECT = 'learninglocker-charts'
    MAIN_BRANCH = 'master'
    CHARTS_DIRECTORY = "charts"
    DOCKER_REGISTRY = 'harbor.dltv.ac.th'
    REGISTRY_CREDENTIALS = 'registry-credentials'
    CHART_REPOSITORY = "oci://${DOCKER_REGISTRY}/${PROJECT}"
  }

  options {
    timestamps()
    timeout(time: 1, unit: 'HOURS')
  }

  stages {
    stage('Lint') {
      when {
        anyOf {
          changeRequest target: MAIN_BRANCH
          branch MAIN_BRANCH
        }
      }
      steps {
        dir(CHARTS_DIRECTORY) {
          sh """
          helm lint ${params.CHART_NAME}
          """
        }
      }
    }

    stage('Package') {
      when {
        anyOf {
          changeRequest target: MAIN_BRANCH
          branch MAIN_BRANCH
        }
      }
      steps {
        dir(CHARTS_DIRECTORY) {
          sh """
          helm package ${params.CHART_NAME}
          """
        }
      }
    }

    stage('Push') {
      when { 
        branch MAIN_BRANCH
      }
      steps {
        dir(CHARTS_DIRECTORY) {
          script {
            docker.withRegistry("https://${DOCKER_REGISTRY}", REGISTRY_CREDENTIALS) {
              chartVersion = sh(script: "yq e '.version' ${params.CHART_NAME}/Chart.yaml", returnStdout: true).trim()
              sh "helm push ${params.CHART_NAME}-${chartVersion}.tgz ${CHART_REPOSITORY}"
            }
          }
        }
      }
    }
  }
}
