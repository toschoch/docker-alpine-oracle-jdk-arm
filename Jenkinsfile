node('docker') {
    stage('Checkout') {
        checkout scm
        try { 
            env.VERSION = gitVersion()
            echo "Version = ${env.VERSION}"
            env.ISTAG = isTag()
            echo "Tag = ${env.ISTAG}"
        }
        catch(Exception e) {
            echo "could not read git version! Make sure that you do not make a shallow clone only..."
        }
    }

    stage('Image Name') {
        withCredentials([
            usernamePassword(credentialsId: 'docker public', 
            usernameVariable: 'USERNAME', 
            passwordVariable: 'PASSWORD')]) {
            def imageName = "${USERNAME}/alpine-oracle-jdk-arm"
            env.DOCKERIMAGENAME = (env.ISTAG=="true") ? "${imageName}:${env.VERSION}" : "${imageName}"
        }
        echo "Docker Image = ${env.DOCKERIMAGENAME}"
    }
    
    stage('Build Image') {
        def builtImage = docker.build(env.DOCKERIMAGENAME,".")
    }

    stage('Push Image') {
        docker.withRegistry('','docker public') {
            def builtImage = docker.build(env.DOCKERIMAGENAME,".")
            builtImage.push()
        }
    }
}

def getCommit() {
    return sh(script: 'git rev-parse HEAD', returnStdout: true)?.trim()
}

def gitDescription() {
    return sh(script: "git describe --tags --long --dirty", returnStdout: true)?.trim()
}

def gitVersion() {
    desc = gitDescription()
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
    desc = gitDescription()
    parts = desc.split('-')
    assert parts.size() in [3, 4]
    dirty = (parts.size() == 4)
    tag = parts[0]
    count = parts[1]
    sha = parts[2]
    return (count == '0' && !dirty)
}