DIR_PRE=node/node
PWD=175745

# 创建redis配置
for port in `seq 1 6`; do
    rm -rf ./${DIR_PRE}${port} \
    && mkdir -p ./${DIR_PRE}${port}/data \
    && mkdir -p ./${DIR_PRE}${port}/conf \
    && PORT=${port} PWD=${PWD} envsubst < ./redis.conf > ./${DIR_PRE}${port}/conf/redis.conf
done

# 删除容器
docker-compose down

# 创建docker网络
docker network rm redis
docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 redis

# 启动redis集群
docker-compose -f ./docker-compose.yml up -d

# redis集群初始化
docker exec -it redis1 redis-cli --cluster create -a ${PWD} 192.168.0.2:6379 192.168.0.3:6379 192.168.0.4:6379 --cluster-replicas 0

# 睡眠5秒
sleep 5
# 查看slots分片
docker exec -it redis1 redis-cli -a ${PWD} cluster slots
# 查看集群信息
docker exec -it redis1 redis-cli -a ${PWD} cluster info
# 查看集群状态
docker exec -it redis1 redis-cli -a ${PWD} cluster nodes

