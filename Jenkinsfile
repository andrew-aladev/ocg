pipeline {
    agent { docker { image "puchuu/test-compression_i686-gentoo-linux-musl:latest" } }
    stages {
        stage("ci_test") {
            when {
                branch "master"
            }
            steps {
                dir("/mnt/data") {
                    sh "scripts/test-images/ci_test.sh"
                }
            }
        }
    }
}
