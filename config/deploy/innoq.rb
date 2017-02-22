# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "helloworld.innoq.info",
  user: "ubuntu",
  roles: %w{web app db}
