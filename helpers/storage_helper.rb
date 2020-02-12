# redis storage helper
module StorageHelper
  def r_set(key, value)
    $redis.set(key, value)
  end

  def r_get(key)
    data = $redis.get(key)
    JSON.parse data if data.present?
  end
end
