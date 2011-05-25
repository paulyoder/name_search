require 'test_helper'

class ValidationTests
	def self.test_requires(model, attribute)
		orig_val = model.send(attribute.to_s)
		model.send("#{attribute.to_s}=", nil)
		assert_equal false, model.valid?
		model.send("#{attribute.to_s}=", orig_val)
	end
end
