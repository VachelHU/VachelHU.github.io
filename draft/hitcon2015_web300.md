# HITcon2015CTF web300
### 题目
```
Find the flag!
http://52.69.0.204
```
[源码地址](https://gitcafe.com/JJjie/JJjie/tree/gitcafe-pages/ctfcode/hitcon2015/web300)

### 解析
1. 源码在input.phps里面

2. 读源码可知，关键点由`mt_rand()`生成的随机数token，在没有植入种子的情况下，每一次`mt_rand()`都会产生一个随机的32bit的种子给下一次用

3. 使用[php_mt_seed](http://www.openwall.com/php_mt_seed/),申请一个暴力破解种子

### 具体破解

http://www.tasteless.eu/post/2015/10/hitcon-web300/
