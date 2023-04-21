USE mysql;

-- 授权远程连接
GRANT ALL PRIVILEGES ON *.*  TO 'root'@'%';
-- 修改root密码
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
-- 刷新权限
FLUSH PRIVILEGES;
