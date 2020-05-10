# IPFS 网关 IPNS加速器

## 食用方法

~~~bash
apt install openresty

./install.sh
~~~
记得去set_ipns.lua里修改token. 

## 更多说明
https://blog.csdn.net/weixin_43668031/article/details/100174147

## 加速效果
设置ipns记录
~~~bash
ipns=QmXidpbD1osmHXWN4gJc3NHry3kzTnicnp9Utrpxk6s4Du
ipfs=QmaRPBEKsm1gTDg3PNbbgwD8FTB8z7gJWhAeGPDWRhjC45

curl -H "token:123456" http://ipfs-gateway.dlimba.top:8082/set/$ipns/$ipfs
~~~
效果明显

访问
http://ipfs-gateway.dlimba.top:8082/ipns/QmXidpbD1osmHXWN4gJc3NHry3kzTnicnp9Utrpxk6s4Du/
瞬间打开。

但是访问 https://ipfs.io/ipns/QmXidpbD1osmHXWN4gJc3NHry3kzTnicnp9Utrpxk6s4Du/ 慢的一批。

