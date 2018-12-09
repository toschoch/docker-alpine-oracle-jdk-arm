def gitVersion() {
    desc = sh(script: "git describe --tags --long --dirty", returnStdout: true)?.trim()
    parts = desc.split('-')
    assert parts.size() in [3, 4]
    dirty = (parts.size() == 4)
    tag = parts[0]
    count = parts[1]
    sha = parts[2]
    if (count == '0' && !dirty) {
        return tag
    }
    return sprintf( '%1$s.dev%2$s+%3$s', [tag, count, sha.substring(1)])
}

def isTag() {
    commit = getCommit()
    if (commit) {
        desc = sh(script: "git describe --tags --long ${commit}", returnStdout: true)?.trim()
        match = desc =~ /.+-[0-9]+-g[0-9A-Fa-f]{6,}$/
        result = !match
        match = null
        return result
    }
    return false
}

node('docker') {
    stage('Checkout') {
        checkout scm
    }
    
    stage('Build Image') {
        withCredentials([
            usernamePassword(credentialsId: 'docker public', 
            usernameVariable: 'USERNAME', 
            passwordVariable: 'PASSWORD')]) {
            def builtImage = docker.build("${USERNAME}/docker-alpine-oracle-jdk-arm",".")
        }
    }

    stage('Push Image') {
        when { tag "release-*" }
        docker.withRegistry('https://hub.docker.com/','docker public') {
            builtImage.push()
        }
    }
}
