pipeline {
    agent any

    triggers {
       pollSCM('* * * * *')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('rkcy-dockerhub')
    }

    stages {
      stage("Compile") {
        steps {
            sh "./gradlew compileJava"
        }
       }

      stage("Unit test") {
          steps {
              sh "./gradlew test"
          }
        }

       stage("Code coverage") {
         steps {
         sh "./gradlew jacocoTestReport"
         publishHTML(target: [
           reportDir: 'build/reports/jacoco/test/html',
           reportFiles: 'index.html',
           reportName: "JaCoCo Report"
         ])
         sh "./gradlew jacocoTestCoverageVerification"
         }
       }

       stage("Static code analysis") {
        steps {
         sh "./gradlew checkstyleMain"
        }
       }

       stage("Package") {
        steps {
          sh "./gradlew build"
         }
       }

       stage("Docker build") {
        steps {
          sh "docker build -t rkcy/calculator ."
        }
       }

      stage('Docker Login') {
         steps {
            sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
         }
      }

      stage('Docker Push') {
        steps {
          sh 'docker push rkcy/calculator:latest'
        }
      }
    }

  post {
    always {
      sh 'docker logout'
    }
  }
}