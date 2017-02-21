# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "ec2-34-249-207-239.eu-west-1.compute.amazonaws.com",
  user: "ubuntu",
  roles: %w{web app db}
