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

    stage('Vpc,Subnet') {
      steps {
        sh '''cd /var/lib/jenkins/workspace
./key.sh
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master/Vpc,Subnet'''
      }
    }

    stage('IGW,NAT') {
      steps {
        sh '''cd /var/lib/jenkins/workspace/
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master/IGW,NAT'''
      }
    }

    stage('Route Table') {
      steps {
        sh '''cd /var/lib/jenkins/workspace/
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master/Route Table'''
      }
    }

    stage('ACL') {
      steps {
        sh '''cd /var/lib/jenkins/workspace/
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master/ACL'''
      }
    }

    stage('Security Group') {
      steps {
        sh '''cd /var/lib/jenkins/workspace/
terraform apply -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master/Security Group'''
      }
    }

    stage('Destroy') {
      steps {
        sh '''cd /var/lib/jenkins/workspace/
terraform destroy -auto-approve -lock=false -var-file=var.json /var/lib/jenkins/workspace/practice_master/Destroy'''
      }
    }

  }
}