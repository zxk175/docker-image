# 创建docker网络
docker network rm well
docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 well
docker network ls

# 查看网络详情
docker network inspect well
