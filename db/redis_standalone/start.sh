NODE_PRE=./node
LOG_PRE=./logs
PWD=Zxk123456

# 创建redis配置
rm -rf ${NODE_PRE} \
&& mkdir -p ${NODE_PRE}/data \
&& mkdir -p ${NODE_PRE}/conf \
&& touch ${LOG_PRE}/redis.log \
&& chmod 777 ${LOG_PRE}/redis.log \
&& PWD=${PWD} envsubst < ./redis.conf > ${NODE_PRE}/conf/redis.conf

# 删除容器
docker-compose -f ./docker-compose.yml down

# 启动redis
docker-compose -f ./docker-compose.yml up -d
