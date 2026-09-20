# CyberLAB 詳細步驟

## Lab 1:

```bash
cd lab1
```

### 開啟 web server

```bash
docker-compose build --no-cache
docker-compose up

docker-compose exec dvwa /bin/bash
/opt/entrypoint.sh
```

### 用瀏覽器設定 dvwa

1. 用瀏覽器到<http://localhost/setup.php>後，用`Create/Reset Database`重設定Database
2. 用瀏覽器到<http://localhost/security.php>，`Security Level`調整做`Low`

### 試 SQL Injection

1. 用瀏覽器到 <http://localhost/vulnerabilities/sqli/>，輸入`1`，會出現`id=1`使用者名稱。
2. 用瀏覽器到 <http://localhost/vulnerabilities/sqli/>，輸入`1' or 1=1 #`，會出現全部使用者名稱。

### 試 XSS

1. 用瀏覽器到 <http://localhost/vulnerabilities/xss_r/>，輸入`Arik`，結果會顯示`Hello Arik`。
2. 用瀏覽器到 <http://localhost/vulnerabilities/xss_r/>，輸入`<script>alert(document.cookie)</script>`，結果會跳出cookie資訊。


## Lab 2: ModSecurity

```bash
cd lab2
docker-compose up
docker-compose exec dvwa /bin/bash
```


### 安裝 ModSecurity

安裝前更新一下，安裝需要的 lib

```bash
apt update && apt install -y libapache2-mod-security2
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

### 自訂規則

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

### 開啟 web server

```
/opt/entrypoint.sh
```

### 試 XSS 保護成果

用瀏覽器到 <http://localhost/vulnerabilities/xss_r/>，輸入`<script>alert(document.cookie)</script>`，結果會跳出`404 Not Found`,有版本資訊`Apache/2... (Ubuntu) Server`。主機版本資訊應該保護，所以需要移除版本資訊。


### 移除版本資訊

修改設定檔案 `security.conf`

```bash
vim /etc/apache2/conf-enabled/security.conf
```

`ServerTokens` 改成 `Prod`，`ServerSignature` 改成 `off`。

```
ServerTokens Prod
# ...
ServerSignature Off
```

### 開啟 web server
```
/opt/entrypoint.sh
```

### 試 XSS 保護成果

用瀏覽器到 <http://localhost/vulnerabilities/xss_r/>，輸入`<script>alert(document.cookie)</script>`，結果會跳出`404 Not Found`，無版本資訊。

### 練習

保護`SQL Injection`例。

## Lab 3: NAXSI

```bash
cd lab3
docker-compose build --no-cache
docker-compose up
docker-compose exec naxsi /bin/bash
```


#### 自訂基本規則

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

#### 自訂核心規則

修改 `naxsi_core.rules`

```bash
vim /etc/nginx/naxsi_core.rules
```

新增一筆規則

```diff
MainRule "msg:demo" "rx:<script>" "mz:ARGS" "s:$XSS:100" id:123;
```


## Command cheatsheet

reload nginx

`/usr/sbin/nginx -s reload`

start mysql

`service mysql start`

reload mysql

`service mysql restart`

start apache

`service apache2 start`

reload apache

`service apache2 restart`
