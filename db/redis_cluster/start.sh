# 遇到错误退出
set -e

NODE_PRE=./node/node
LOG_PRE=./logs/node
PWD=175745

# 创建redis配置
for port in `seq 1 6`; do
    rm -rf ${NODE_PRE}${port} \
    && mkdir -p ${NODE_PRE}${port}/data \
    && mkdir -p ${NODE_PRE}${port}/conf \
    && touch ${LOG_PRE}${port}/redis.log \
    && chmod 777 ${LOG_PRE}${port}/redis.log \
    && PORT=${port} PWD=${PWD} envsubst < ./redis.conf > ${NODE_PRE}${port}/conf/redis.conf
done

# 删除容器
docker-compose -f ./docker-compose.yml down

# 启动redis集群
docker-compose -f ./docker-compose.yml up -d

# redis集群初始化
docker exec -it redis1 \
redis-cli --cluster \
create -a ${PWD} --cluster-replicas 1 \
192.168.0.2:6379 192.168.0.3:6379 192.168.0.4:6379 192.168.0.5:6379 192.168.0.6:6379 192.168.0.7:6379

# 睡眠5秒
sleep 5
# 查看slots分片
docker exec -it redis1 redis-cli -a ${PWD} cluster slots
# 查看集群信息
docker exec -it redis1 redis-cli -a ${PWD} cluster info
# 查看集群状态
docker exec -it redis1 redis-cli -a ${PWD} cluster nodes
