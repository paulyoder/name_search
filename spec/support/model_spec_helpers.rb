module ModelSpecHelpers
	def model_should_be_valid
		specify 'model should be valid' do
			model.should be_valid
		end
	end

	def model_should_respond_to(*attributes)
		attributes.each do |att|
			it "should respond to #{att.to_s}" do
				model.should respond_to att
			end
		end
	end

	def model_should_require(*attributes)
		attributes.each do |att|
			it "should require #{att.to_s}" do
				orig_val = model.send(att.to_s)
				model.send("#{att.to_s}=", nil)
				
				model.should_not be_valid
				model.errors.keys.include?(att).should be_true

				model.send("#{att.to_s}=", orig_val)
			end
		end
	end
end
