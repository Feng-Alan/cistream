
-  docker image build command

`$docker build --no-cache -t <imageName> :<imageTag> --file <dockerFile> .`

example:

$docker build --no-cache -t apolloauto/apollo:v5.8 --file dev.x86_64.dockerfile .

- crosstool prepared

docker image build depend on crosstool integration for nh code build, please do operation as below:

`$cd <buildPath> #dev.x86_64.dockerfile file catalog`

`$wget http://inspurobject.navinfo.com:8009/nh-build/crosstool/crosstool-20250214.zip`

`$unzip crosstool-20250214.zip`

`$rm -rf crosstool-20250214.zip`

- image download
`docker pull "XXXX.XXXX.com/XXX-dev/auto:v5.8"`

- image push
docker tag myapp:latest yourusername/myapp:latest
docker login --username XXX --password XXXXX XXXX.XXXXX.com
docker push yourusername/myapp:latest

