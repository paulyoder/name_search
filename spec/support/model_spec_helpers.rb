module ModelSpecHelpers
	def model_should_be_valid
		specify 'model should be valid' do
			model.should be_valid
		end
	end

	def model_responds_to(*attributes)
		attributes.each do |attribute|
			it "should respond to #{attribute.to_s}" do
				model.should respond_to attribute
			end
		end
	end

	def model_requires(*attributes)
		attributes.each do |attribute|
			it "should require #{attribute.to_s}" do
				orig_val = model.send(attribute.to_s)
				model.send("#{attribute.to_s}=", nil)
				
				model.should_not be_valid
				model.errors.should have_key(attribute)

				model.send("#{attribute.to_s}=", orig_val)
			end
		end
	end

	def model_has_unique_attributes(*attributes)
		attributes.each do |attribute|
			it "#{attribute.to_s} attribute should be unique" do
				model.class._validators.should have_key(attribute)
				model.class._validators[attribute].any?{|x| x.class == ActiveRecord::Validations::UniquenessValidator}.should be_true
			end
		end
	end
end
