scriptLocation=$(pwd)

yum install maven -y

useradd roboshop

mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

cd /app

unzip /tmp/shipping.zip

cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

cp "${scriptLocation}"/files/shipping.service /etc/systemd/system/shipping.service

systemctl daemon-reload

systemctl enable shipping

systemctl start shipping

yum install mysql -y

mysql_secure_installation --set-root-pass RoboShop@1

mysql -h 172.31.6.48 -uroot -pRoboShop@1 </app/schema/shipping.sql


