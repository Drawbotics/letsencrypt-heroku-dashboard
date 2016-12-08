class ApplicationService
  attr_accessor :success, :message

  def self.call(*params)
    new(*params).call
  end

  def success?
    success
  end

  def failure?
    !success?
  end

end
