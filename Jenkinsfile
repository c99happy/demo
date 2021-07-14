pipeline {
    agent any
    tools{
        maven "maven3.8.1"
    }

    options{
           //超过5分钟没有构建完成会退出
        timeout(time:30,unit:'MINUTES')
        //保持构建最大个数
        buildDiscarder(logRotator(numToKeepStr:'5'))
    }
    environment{
        WORKSPACE_1='${WORKSPACE}'
        WORKSPACE_t='${JENKINS_HOME}/workspace/${JOB_HOME}'
        repo_code_dir='/usr/local/src/${artifactId}/${VERSION}'
    }

    stages {
        stage('拉取代码') {
            when {
                expression{
                  return ("${DEPLOY}" == "upgrade")
                }
            }
            steps {
                echo "${URL}"
                // Get some code from a GitHub repository
                git credentialsId: 'github', url: "${PROJECT_URL}",branch: "${BRANCH}"
            }
        }
        stage('测试代码') {
            when {
                expression{
                  return ("${DEPLOY}" == "upgrade")
                }
            }
            steps {
                sh "mvn org.jacoco:jacoco-maven-plugin:prepare-agent clean test"
                junit '**/target/surefire-reports/*.xml'
                jacoco changeBuildStatus: true, maximumLineCoverage: '30'
            }
        }
        stage('打包服务') {
           when {
                expression{
                  return ("${DEPLOY}" == "upgrade")
                }
            }
            steps {
                sh "mvn clean package -Dmaven.test.skip=true"
            }
        }
        stage('移至代码仓库') {
            when {
                expression{
                  return ("${DEPLOY}" == "upgrade")
                }
            }
            steps {
                sh "mkdir -p ${repo_code_dir}"
                sh "cp ${WORKSPACE_1}/target/${artifactId}-${VERSION}.jar ${repo_code_dir}"
                sh "cp ${WORKSPACE_1}/target/classes/stop.sh ${repo_code_dir}"
                sh "cp ${WORKSPACE_1}/target/classes/startup.sh ${repo_code_dir}"
            }
        }
         stage('发布服务|回滚') {
                steps {
                    script {
                        for(ip in ts_ips.tokenize(',')){
                            sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ip} 'rm -rf /usr/local/src/${artifactId}/latest/*}'"
                            sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ip} 'mkdir -p /usr/local/src/${artifactId}/latest/conf'"
                            sh "sshpass -p ${ts_pwd} scp -P ${ts_port} ${repo_code_dir}/${artifactId}-${VERSION}.jar ${ts_user}@${ip}:/usr/local/src/${artifactId}/latest/"
                            sh "sshpass -p ${ts_pwd} scp -P ${ts_port} ${repo_code_dir}/startup.sh ${ts_user}@${ip}:/usr/local/src/${artifactId}/latest/"
                            sh "sshpass -p ${ts_pwd} scp -P ${ts_port} ${repo_code_dir}/stop.sh ${ts_user}@${ip}:/usr/local/src/${artifactId}/latest/"
                        }
                    }
                }
          }
          stage('启动服务') {
            steps {
               script {
                   for(ip in ts_ips.tokenize(',')){
                       sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ip} 'chmod 775 /usr/local/src/${artifactId}/latest/stop.sh'"
                       sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ip} '/usr/local/src/${artifactId}/latest/stop.sh'"
                       sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ip} 'chmod 775 /usr/local/src/${artifactId}/latest/startup.sh'"
                       sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ip} '/usr/local/src/${artifactId}/latest/startup.sh'"
                   }
               }
          }
        }
    }
}
