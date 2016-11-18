module Assignable
  extend ActiveSupport::Concern

  module ClassMethods
    def assign(*properties)
      properties.each do |p|
        attr_reader p
      end
      helper_method properties
    end
  end
end
