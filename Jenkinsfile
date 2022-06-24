pipeline{
    agent any
    tools{
        jdk 'jdk11'
        maven 'maven'
    }
    environment{
        PROJECT_NM="FitHealth"
        PROJECT_OWNER="VIV Richards"
    }
    parameters{
        string name: 'TARGET_HOST', defaultValue: 'agentDefault'
        string name: 'SOURCE_BRANCH',  defaultValue: 'main'
        choice choices: ['DEV', 'TEST','RFS', 'PROD'], name: 'ENVIRONMENT'
    }
    stages{
        stage("pull git code"){
             steps {
                  echo "Polling from code git for project ${PROJECT_NM} of ${PROJECT_OWNER}"
                  git(url: 'https://github.com/vikingsvivek/fithealth.git',credentialsId: 'vikingsvivek', branch: params.SOURCE_BRANCH)
             }
        }
        stage("Build"){
            steps {
                 sh '''
                     echo "Doing code build for $ENVIRONMENT and host $TARGET_HOST"
                    mvn clean verify
                 '''
             }
        }
        stage("Unit test"){
             steps {
                  echo "Run unit Tests"
             }
        }
         stage("Push Artifact"){
             steps {
                
                input(
                        id: 'confirmPush',
                        message: "Do You want to push the artifact?",
                        submitter: "vagrant",
                        parameters: [string(name:'ARTIFACTORY_URL', defaultValue: 'http://jcrnode.com', description: 'Artifactory to push')]
                    )
                  echo ("Deploying Artifact to REPO:"+ params.ARTIFACTORY_URL)
             }
           
        }
    }
    post {
        success {
           echo "Build ran successfully"
        }
    }
}
