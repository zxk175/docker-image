echo "================> 查看构建配置"
docker-compose -f build.yml config

echo "\n================> 开始构建镜像"
# docker-compose -f build.yml build --force-rm --no-rm --no-cache
docker-compose -f build.yml build --force-rm --no-rm
