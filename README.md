## 开启wsl并安装ubuntu20：
1、在搜索栏中搜索并打开“启用或关闭Windows功能”，勾选“适用于Linux的Windows子系统”项。
2、在微软应用商店搜索 ubuntu，选ubuntu即可（版本20.04.3）

## 之后可能需要更新几个配置（如果下面有的包安不上用这里）
### 换源：
https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
### 换DNS：
cd /etc
vi resolv.conf
在打开的文件里把nameserver换成114.114.114.114和8.8.8.8
## 都弄完了，安rails并启动
sudo apt install ruby

sudo gem install rails

sudo gem install bundler

sudo apt install libsqlite3-dev

sudo apt install npm

npm install --global yarn

bundle insall

rails server
