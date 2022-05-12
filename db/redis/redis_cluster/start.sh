NODE_PRE=./node/node
LOG_PRE=./logs/node
PWD=Zxk123456

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

# 获取容器IP
REDIS_CLUSTER_IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps --filter "name=redis_cluster*" -aq)`
IP_ARR=""
for IP in $REDIS_CLUSTER_IP; do
    IP_ARR+="$IP:6379 "
done

# redis集群初始化
docker exec -it redis_cluster1 \
redis-cli --cluster \
create -a ${PWD} --cluster-replicas 1 \
$IP_ARR

# 睡眠5秒
sleep 5
# 查看slots分片
docker exec -it redis_cluster1 redis-cli -a ${PWD} cluster slots
# 查看集群信息
docker exec -it redis_cluster1 redis-cli -a ${PWD} cluster info
# 查看集群状态
docker exec -it redis_cluster1 redis-cli -a ${PWD} cluster nodes
