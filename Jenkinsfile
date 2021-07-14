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
            steps {
                  // Get some code from a GitHub repository
                  git credentialsId: 'github', url: 'git@github.com:c99happy/demo.git',branch: "${BRANCH}"
            }
        }

        stage('打包服务') {
            steps {
                sh "mvn clean package -Dmaven.test.skip=true"
            }
        }
        stage('移至代码仓库') {
            steps {
                sh "mkdir -p ${repo_code_dir}"
                sh "cp ${WORKSPACE_1}/target/${artifactId}-${VERSION}.jar ${repo_code_dir}"
                sh "cp ${WORKSPACE_1}/target/classes/stop.sh ${repo_code_dir}"
                sh "cp ${WORKSPACE_1}/target/classes/startup.sh ${repo_code_dir}"
            }
        }
         stage('发布服务') {
                steps {
                    sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ts_ip} 'rm -rf /usr/local/src/${artifactId}/latest/*'"
                    sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ts_ip} 'mkdir -p /usr/local/src/${artifactId}/latest/*'"
                    sh "sshpass -p ${ts_pwd} scp -P ${ts_port} ${repo_code_dir}/${artifactId}-${VERSION}.jar ${ts_user}@${ts_ip}:/usr/local/src/${artifactId}/latest/"
                    sh "sshpass -p ${ts_pwd} scp -P ${ts_port} ${repo_code_dir}/startup.sh ${ts_user}@${ts_ip}:/usr/local/src/${artifactId}/latest/"
                    sh "sshpass -p ${ts_pwd} scp -P ${ts_port} ${repo_code_dir}/stop.sh ${ts_user}@${ts_ip}:/usr/local/src/${artifactId}/latest/"
                }
          }
          stage('启动服务') {
            steps {
               sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ts_ip} 'chmod 775 /usr/local/src/${artifactId}/latest/stop.sh'"
               sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ts_ip} '/usr/local/src/${artifactId}/latest/stop.sh'"
               sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ts_ip} 'chmod 775 /usr/local/src/${artifactId}/latest/startup.sh'"
               sh "sshpass -p ${ts_pwd} ssh -p ${ts_port} ${ts_user}@${ts_ip} '/usr/local/src/${artifactId}/latest/startup.sh'"

          }
        }
    }
}
