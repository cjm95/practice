pipeline {
  agent any
  stages {
    stage('Git cloning') {
      steps {
        git(url: 'https://github.com/cjm95/practice.git', credentialsId: 'cjm95')
      }
    }

    stage('Init') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform init -lock=false /var/lib/jenkins/workspace/practice_master'''
      }
    }

    stage('Apply') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master'''
      }
    }

    stage('Check') {
      steps {
        sh '''cd /var/lib/jenkins/workspace/
terraform output -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master'''
      }
    }

  }
}