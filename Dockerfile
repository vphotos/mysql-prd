# Mantén tu misma base (no cambiamos nada del stack MySQL)
FROM mysql/mysql-server:8.0.24

# Tu config de MySQL
COPY config/user.cnf /etc/mysql/my.cnf

# Instalar OpenSSH sin tocar los repos de MySQL Community
USER root
RUN microdnf -y install \
      --disablerepo=mysql80-community \
      --disablerepo=mysql-tools-community \
      openssh-server openssh-clients which shadow-utils bash \
 && microdnf clean all \
 && mkdir -p /var/run/sshd \
 && ssh-keygen -A \
 && chmod 700 /root \
 && mkdir -p /root/.ssh && chmod 700 /root/.ssh \
 && (sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config) \
 && (sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config || echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config)
