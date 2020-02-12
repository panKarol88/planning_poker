# ---- REDIS CONFIG ----
REDIS_CONFIG = YAML.load( File.open( 'config/redis.yml' ) )
default = REDIS_CONFIG['default']
config = default.merge(REDIS_CONFIG[ENV['ENVIRONMENT']]) if REDIS_CONFIG[ENV['ENVIRONMENT']]
$redis = Redis.new(config)

# to clear out the db before each test
$redis.flushdb if ENV['ENVIRONMENT'] == 'test'

# redlock configuration - for locking redis keys
$redlock = Redlock::Client.new(
                [$redis], {
                retry_count:   3,
                retry_delay:   200, # milliseconds
                retry_jitter:  50,  # milliseconds
                redis_timeout: 0.1  # seconds
            })
