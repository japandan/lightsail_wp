#!/bin/bash
sudo yum install awscli
echo create keys in lightsail console for API use
echo know your aws_access_key & aws_secret_access_key 
echo output=json
echo region=ap-northeast-1
aws configure
echo the following command will create new server from a snapshot
cat <<EOF >rebuild.sh
#!/bin/bash
aws lightsail create-instances-from-snapshot \
    --instance-snapshot-name www.datos.asia-20191226 \
    --instance-names www.datos.asia \
    --availability-zone ap-northeast-1a \
    --bundle-id micro_2_0
EOF
echo run script "bash rebuild.sh"
cat rebuild.sh
