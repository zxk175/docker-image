# 删除容器
docker-compose -f ./docker-compose.yml down

docker network prune -f

# 启动redis
docker-compose -f ./docker-compose.yml up -d
