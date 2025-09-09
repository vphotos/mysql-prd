# ---- MySQL 8.0 ----
FROM mysql/mysql-server:8.0.24

# Tu configuración de MySQL
COPY config/user.cnf /etc/mysql/my.cnf

# ---- SSH: instalar y dejar listo ----
# La base es Oracle Linux -> microdnf
RUN microdnf -y update \
 && microdnf -y install openssh-server openssh-clients which shadow-utils bash \
 && microdnf clean all \
 && mkdir -p /var/run/sshd \
 # generar host keys (evita error "no hostkeys available")
 && ssh-keygen -A \
 # permisos correctos para que Render no cierre la SSH
 && chmod 700 /root \
 && mkdir -p /root/.ssh \
 && chmod 700 /root/.ssh \
 # endurecer: solo claves, root sin password
 && (sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config) \
 && (sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config || echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config)
