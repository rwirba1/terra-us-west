pipeline {
    agent  { label 'node' } 

    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['init', 'plan', 'apply', 'destroy'], description: 'Select Terraform Action')
    }

    stages {
        stage('Terraform Init, Apply, or Destroy') {
            steps {
                script {
                    switch (params.TERRAFORM_ACTION ) {
                       case 'init':
                           echo "Running Terraform Init"
                           sh 'terraform init'
                           break
                       case 'plan':
                           echo "Running Terraform plan"
                           sh 'terraform plan'
                           break                         
                        case 'apply':   
                            echo "Running Terraform Apply"
                            sh 'terraform apply --auto-approve'
                            break
                        case 'destroy':
                            echo "Running Terraform Destroy"
                            sh 'terraform destroy --auto-approve'
                            break
                        default:    
                            error "Invalid Terraform action selected"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Execution completed'
        }
        success {
            echo 'Successfully executed Terraform action'
        }
        failure {
            echo 'Terraform action failed'
        }
    }
}
