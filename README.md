# CyberLAB 詳細步驟

## Lab 1:

#### 1. 切換到 Dockerfile 目錄

```bash
cd /home/user/Desktop/demo/dvwa
```

#### 2. Run Docker image

```bash
docker build -t cyberlab .
docker run -v $(pwd)/mount:/tmp/mount -p 80:80 -it cyberlab /bin/bash
```
or 

```bash
docker run -v $(pwd)/mount:/tmp/mount -p 80:80 -it zet235/cyberlab2022:dvwa /bin/bash
```

啟動 web server 
```bash
/tmp/start.sh
```
## Lab 2: ModSecurity


#### 1. 安裝 ModSecurity

安裝前更新一下

```bash
apt update
```

安裝需要的 lib

```bash
apt install -y libapache2-mod-security2
```

切換到安裝目錄

```bash
cd /etc/modsecurity
```

複製推薦設定檔

```bash
cp modsecurity.conf-recommended modsecurity.conf
```

修改設定檔案 `modsecurity.conf`

```bash
vim modsecurity.conf
```

SecRuleEngine 設定為 On

```
SecRuleEngine On
```

#### 2. 自訂規則

```bash
vim /usr/share/modsecurity-crs/rules/REQUEST-1001-DEMO.conf
```

在新增的 `REQUEST-1001-DEMO.conf` 寫入

```
SecRule ARGS "@rx <script>" "id:00123,deny,status:404"
```

修改設定檔案 `security2.conf`

```bash
vim /etc/apache2/mods-enabled/security2.conf
```

把自建的規則加入清單
```
IncludeOptional /usr/share/modsecurity-crs/rules/REQUEST-1001-DEMO.conf
```

註解掉預設規則
```
# IncludeOptional /usr/share/modsecurity-crs/*.load
```

#### 3. 移除版本資訊

修改設定檔案 `security.conf`

```bash
vim /etc/apache2/conf-enabled/security.conf
```

ServerSignature 改成 `off` ServerTokens 改成 `Prod`

```
ServerSignature Off
ServerTokens Prod
```

## Lab 3: NAXSI

#### 1. 安裝 nginx + naxsi

建立安裝目錄

```bash
mkdir /tmp/nginx_naxsi && cd /tmp/nginx_naxsi
```

下載 nginx

```bash
wget http://nginx.org/download/nginx-1.21.6.tar.gz
```

解壓 nginx

```bash
tar -xvzf nginx-1.21.6.tar.gz
```

下載 naxsi

```bash
wget https://github.com/nbs-system/naxsi/archive/refs/tags/1.3.zip -O naxsi-1.3.zip
```

解壓 naxsi

```bash
unzip naxsi-1.3.zip
```

安裝前更新一下

```bash
apt update
```

安裝需要的 lib

```bash
apt install -y libpcre3-dev libssl-dev unzip build-essential daemon libxml2-dev libxslt1-dev libgd-dev libgeoip-dev
```

切換到 nginx 目錄

```bash
cd /tmp/nginx_naxsi/nginx-1.21.6
```

開始安裝

```bash
./configure --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-RFWPEB/nginx-1.21.6=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --add-module=../naxsi-1.3/naxsi_src/ --sbin-path=/usr/sbin/nginx --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-mail=dynamic --with-mail_ssl_module
```

```bash
make && make install
```

```bash
mkdir /var/lib/nginx/ && mkdir /var/lib/nginx/body
```

#### 2. 設置核心規則

```bash
cp /tmp/nginx_naxsi/naxsi-1.3/naxsi_config/naxsi_core.rules /etc/nginx/naxsi_core.rules
```

#### 3. 建立錯誤頁面

```
vim /var/www/html/error.html
```

在新增的 `error.html` 寫入

```htmlmixed
<html>
<head>
<title>Blocked By NAXSI</title>
</head>
<body>
<div style="text-align: center">
<h1>Malicious Request</h1><hr><p>This Request Has Been Blocked By NAXSI.</p>
</div>
</body>
</html>
```

#### 4. 設定 proxy server (apache)

修改 `000-default.conf`
```bash
vim /etc/apache2/sites-available/000-default.conf
```

VirtualHost 改為 8080

```
VirtualHost *:8080
```

修改 ports.conf

```
vim /etc/apache2/ports.conf
```

Listen 改為 `8080`

```
Listen 8080
```

#### 5. 設定 proxy server (nginx)

```
vim /etc/nginx/nginx.conf
```

nginx.conf

```
    server {
        location / {
            # root   html;
            # index  index.html index.htm;
            include /etc/nginx/naxsi.rules;
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
    }}
```

#### 6. 自訂基本規則

```bash
vim /etc/nginx/naxsi.rules
```

在新增的 `naxsi.rules` 寫入

```
SecRulesEnabled;

DeniedUrl "/error.html";

## Check Naxsi rules
CheckRule "$SQL >= 90" BLOCK;
CheckRule "$XSS >= 90" BLOCK;
```

#### 7. 自訂核心規則

修改 `naxsi_core.rules`

```
vim /etc/nginx/naxsi_core.rules
```

新增一筆規則, 並註解掉其他規則

```
MainRule "msg:demo " " rx:<script>"  "mz:ARGS " "s:$XSS:100" id:00123;
```

修改設定檔 `nginx.conf`

```
vim /etc/nginx/nginx.conf
```

在 `nginx.conf` 中新增一筆規則引用

```
http {
    include       mime.types;
    include /etc/nginx/naxsi_core.rules;
}
```

#### 8. 開啟 web server 
```
/tmp/start.sh
```


## Command cheatsheet

relaod nginx

`/usr/sbin/nginx -s reload`

start mysql

`service mysql start`

relaod mysql

`service mysql restart`

start apache

`service apache2 start`

relaod apache

`service apache2 restart`
