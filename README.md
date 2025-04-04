# lab-sita

name: Common CI
on:
  workflow_call:
    inputs:
      component_name:
        required: true
        type: string
      app_type:
        required: true
        type: string
jobs:
  Download-Dependencies-Docker-Build:
    runs-on: self-hosted
    steps:
      - name: Check out repository code
        uses: actions/checkout@v4
      - name: Download Dependencies
        run: |
          if [ ${{inputs.app_type}} == nodejs ]; then
            npm install
          elif [ ${{inputs.app_type}} == maven ]; then
            export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.14.0.7-2.el9.x86_64
            export PATH=$JAVA_HOME/bin:$PATH
            /usr/share/maven/bin/mvn package
          fi
          docker build -t 633788536644.dkr.ecr.us-east-1.amazonaws.com/${{inputs.component_name}}:${GITHUB_SHA} .
