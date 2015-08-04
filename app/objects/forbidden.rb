class Forbidden < StandardError
  def initialize
    super("User access requires higher level of permissions")
  end
end
