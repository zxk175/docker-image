# 遇到错误退出
# set -e

# 删除容器
docker-compose -f ./docker-compose.yml down

# 创建docker网络
docker network rm postgres
docker network create --driver bridge postgres

# 启动redis集群
docker-compose -f ./docker-compose.yml up -d
