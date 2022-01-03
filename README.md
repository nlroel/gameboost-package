#### 使用
```yaml
sed -i '$a src-git gameboost https://github.com/nlroel/gameboost-package.git' feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
```
