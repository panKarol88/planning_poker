# redis storage helper
module StorageHelper
  def r_set(key, value, force=false)
    if force || r_get("locks:#{key}").nil?
      $redis.set(key, value)
    else
      $redlock.lock("locks:#{key}", 2000) do |locked|
        if locked
          $redis.set(key, value)
        else
          puts 'unsuccessful storage - helper'
          return false
        end
      end
    end
    return true
  end

  def r_get(key)
    data = $redis.get(key)
    JSON.parse data if data.present?
  end

  def r_release(key)
    $redis.del(key)
  end
end
