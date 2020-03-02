pipeline {
  agent any
  stages {
    stage('infra') {
      steps {
        git(url: 'https://github.com/cjm95/practice.git', credentialsId: 'cjm95')
      }
    }

    stage('init') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform init -lock=false /var/lib/jenkins/workspace/practice_master'''
      }
    }

    stage('apply') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master'''
      }
    }

    stage('destroy') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
terraform destroy -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master'''
      }
    }

  }
}