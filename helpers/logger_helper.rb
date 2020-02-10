module LoggerHelper
  def logger
    Logger.new STDOUT
  end

  def log_info(message)
    logger.info message
  end

  def log_error(message)
    logger.error message
  end
end
