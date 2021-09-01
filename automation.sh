s3_bucket="upgrad-anubhav"
myname="anubhav"
echo "Updating the packages"
run_sudo=$(sudo apt update -y)
echo "$run_sudo"

echo "installing apache2"
install_apache2=$(sudo apt install apache2 -y)
echo "$install_apache2"

echo "Starting apache2...."
sudo systemctl start apache2


echo "Check if Apache2 is running or not"
if sudo systemctl status apache2 | grep "active (running)"; then
    echo "Apache2 service running"
else
    echo "Apache2 service not running"
fi

timestamp="$(date '+%d%m%Y-%H%M%S')"
filename="/tmp/${myname}-httpd-logs-${timestamp}.tar"


echo "Creating Tar file "

tar -cf ${filename} $( find /var/log/apache2/ -name "*.log")

echo "uploading to S3"
aws s3 cp ${filename} s3://${s3_bucket}/${filename}

echo "uploading to S3 done"