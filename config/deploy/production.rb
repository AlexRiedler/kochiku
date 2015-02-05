# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Server that is running the Kochiku Rails app
server '104.236.206.38', user: 'root', roles: %w{web app db worker}
