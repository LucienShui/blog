---
title: "让网站永久拥有HTTPS - 申请免费SSL证书并自动续期"
date: 2018-02-05 19:02:00 +0800
last_modified_at: 2018-09-03 23:21:20 +0800
math: true
render_with_liquid: false
categories: ["程序人生", "网站"]
tags: ["网站"]
img_path: /assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/
---

## 为什么要用HTTPS

&emsp;&emsp;网站没有使用HTTPS的时候，浏览器一般会报不安全，而且在别人访问这个网站的时候，很有可能会被运营商劫持，然后在网站里显示一些莫名其妙的广告。

![屏幕快照 2018-02-05 16.43.26.png][1]

&emsp;&emsp;有HTTPS的时候，通俗地讲所有的数据传输都会被加密，你和网站之间的数据交流也就更加安全。

![屏幕快照 2018-02-05 16.47.53.png][2]

## 相关简介

### Let's Encrypt

&emsp;&emsp;如果要启用HTTPS，我们就需要从证书授权机构处获取一个证书，Let's Encrypt 就是一个证书授权机构。我们可以从 Let's Encrypt 获得网站域名的免费的证书。

### Certbot

&emsp;&emsp;[Certbot](https://certbot.eff.org)是Let's Encrypt推出的获取证书的客户端，可以让我们免费快速地获取Let's Encrypt证书。

### 便宜SSL

&emsp;&emsp;[便宜SSL](https://www.pianyissl.com/?i121522)是一家国内的SSL证书提供商，同样也拥有免费证书。而且提供丰富的工具: https://www.pianyissl.com/tools。

## 获取HTTPS证书

&emsp;&emsp;获取SSL证书的过程大体上都一样。既可以图形化，也可以命令行，最后实现的效果都完全一样，大家各取所需。

### 命令行

#### 安装Certbot

&emsp;&emsp;进入[Certbot](https://certbot.eff.org)的官网，选择你所使用的软件和系统环境，然后就会跳转到对应版本的安装方法，以Ubuntu + Nginx为例。

```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot 
```

#### 申请证书

&emsp;&emsp;安装完成后执行：

```
certbot certonly --webroot -w /var/www/example -d example.com -d www.example.com
```

&emsp;&emsp;这条命令的意思是为以`/var/www/example`为根目录的两个域名`example.com`和`www.example.com`申请证书。

&emsp;&emsp;如果你的网站没有根目录或者是你不知道你的网站根目录在哪里，可以通过下面的语句来实现：

```
certbot certonly --standalone -d example.com -d www.example.com
```

&emsp;&emsp;使用这个语句时Certbot会自动启用网站的`443`端口来进行验证，如果你有某些服务占用了`443`端口，就必须先停止这些服务，然后再用这种方式申请证书。

&emsp;&emsp;证书申请完之后，Certbot会告诉你证书所在的目录，一般来说会在`/etc/letsencrypt/live/`这个目录下。

### 图形化

&emsp;&emsp;进入便宜SSL的官网[https://www.pianyissl.com](https://www.pianyissl.com/?i121522)，注册了账号之后，选择那个体验版的`免费测试`，然后点确认购买。

![图片2.png][3]

&emsp;&emsp;输入域名并点击`生成CSR并提交申请`按钮。

![图片3.png][4]

&emsp;&emsp;点击`确定`按钮。

![图片4.png][5]

&emsp;&emsp;接下来会选择验证方式。

![图片5.png][6]

&emsp;&emsp;这里我选择邮箱验证方式，其它另外两种依照你的个人情况而定，反正就是为了验证域名是不是你的而已。

![图片6.png][7]

&emsp;&emsp;大约过几分钟，邮箱会收到一封验证邮件，如下图，复制②指向的一串验证码，点击①处的Here链接。

![图片7.png][8]

&emsp;&emsp;输入验证码，点击`Next>`按钮。

![图片8.png][9]

&emsp;&emsp;提示已经输入正确的验证码，点击`Close Window`。

![图片9.png][10]

&emsp;&emsp;大约等到10分钟左右，再次登陆[https://www.pianyissl.com](https://www.pianyissl.com/?i121522)，进入个人中心，可以看到已经成功申请SSL证书，点击查看详情。

![图片10.png][11]

&emsp;&emsp;此时你可以点击箭头所指的证书打包下载，然后免费的SSL证书就可以下载到本地了，下载后可以看到SSL压缩包内的文件。

![图片11.png][12]

## 部署HTTPS证书

&emsp;&emsp;找到网站的Nginx配置文件，找到`listen 80;`，修改为`listen 443;`在这一行的下面添加以下内容：

```
ssl on;
ssl_certificate XXX/fullchain.pem;  修改为fullchain.pem所在的路径
ssl_certificate_key XXX/privkey.pem;  修改为privkey.pem所在的路径
ssl_session_timeout 5m;
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
```

&emsp;&emsp;保存退出后，通过`nginx -t`来检查配置文件是否正确，有错误的话改之即可。配置文件检测正确之后，通过`nginx -s reload`来重载配置文件。

&emsp;&emsp;然后通过访问`https://example.com`来查看是否配置成功。

&emsp;&emsp;如果发现无法访问或者是加载不出来的话检查一下`443`端口有没有开启！

## 设置HTTP强制跳转HTTPS

&emsp;&emsp;上一步成功之后大家可能会发现通过原来的`https://example.com`无法访问网页了，因为HTTP默认走的是`80`端口，我们刚才将其修改为`443`端口了。在这里我们可以在配置文件的最后一行加入以下代码：

```
server {
    listen 80;
    server_name example.com;  这里修改为网站域名
    rewrite ^(.*)$ https://$host$1 permanent;
}
```

&emsp;&emsp;意思是每一个通过`80`端口访问的请求都会强制跳转到`443`端口，这样一来访问`https://example.com`的时候就会自动跳转到`https://example.com`了。

## 命令行下设置证书自动续期

&emsp;&emsp;有心的小伙伴可能会留意到我们刚才申请的整数的有效期只有90天，不是很长，可是我们可以通过`Linux`自带的`cron`来实现自动续期，这样就相当于永久了。

&emsp;&emsp;随便找一个目录，新建一个文件，名字随便起，在这里以`example`为例，在里面写入`0 */12 * * * certbot renew --quiet --renew-hook "/etc/init.d/nginx reload"`，保存。

&emsp;&emsp;然后在控制台里执行`crontab example`一切都OK了。原理是`example`里存入了一个每天检查更新两次的命令，这个命令会自动续期服务器里存在的来自Certbot的SSL证书。然后把`example`里存在的命令导入进Certbot的定时程序里。

## 附：

### 其它环境下的证书部署

&emsp;&emsp;https://www.pianyissl.com/support/

### Nginx相关命令

```
nginx -t  验证配置是否正确
nginx -v  查看Nginx的版本号
service nginx start  启动Nginx
nginx -s stop  快速停止或关闭Nginx
nginx -s quit  正常停止或关闭Nginx
nginx -s reload  重新载入配置文件
```

### crontab相关命令

```
cat /var/log/cron  查看crontab日志
crontab -l  查看crontab列表
crontab -e  编辑crontab列表
systemctl status crond.service  查看crontab服务状态
systemctl restart crond.service  重启crontab
```

## 参考文档

[https://www.cnblogs.com/zoro-zero/p/6590503.html](https://lucien.ink/go/81-1/)
[https://blog.csdn.net/gsls200808/article/details/53486078](https://www.lucien.ink/go/81-2/)
[https://certbot.eff.org/#ubuntuxenial-other](https://lucien.ink/go/81-3/)
[https://nginx.org/en/docs/http/configuring_https_servers.html](https://www.lucien.ink/go/81-4/)


  [1]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/ping_mu_kuai_zhao_2018_02_0516.43.26.png
  [2]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/ping_mu_kuai_zhao_2018_02_0516.47.53.png
  [3]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_2.png
  [4]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_3.png
  [5]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_4.png
  [6]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_5.png
  [7]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_6.png
  [8]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_7.png
  [9]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_8.png
  [10]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_9.png
  [11]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_10.png
  [12]: assets/img/posts/2018/02/05/2018-02-05-rang_wang_zhan_yong_jiu_yong_you_https_shen_qing_mian_fei_ssl_zheng_shu_bing_zi_dong_xu_qi/tu_pian_11.png