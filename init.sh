# 创建docker网络
docker network rm well
docker network create --driver bridge --subnet 172.30.0.0/24 --gateway 172.30.0.1 well
docker network ls

# 查看网络详情
docker network inspect well
