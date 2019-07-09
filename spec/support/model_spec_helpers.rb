module ModelSpecHelpers
  def model_should_be_valid
    specify 'model should be valid' do
      expect(model).to be_valid
    end
  end

  def model_responds_to(*attributes)
    attributes.each do |attribute|
      it "should respond to #{attribute.to_s}" do
        expect(model).to respond_to(attribute)
      end
    end
  end

  def model_requires(*attributes)
    attributes.each do |attribute|
      it "should require #{attribute.to_s}" do
        orig_val = model.send(attribute.to_s)
        model.send("#{attribute.to_s}=", nil)
        
        expect(model).to_not be_valid
        expect(model.errors).to have_key(attribute)

        model.send("#{attribute.to_s}=", orig_val)
      end
    end
  end

  def model_has_unique_attributes(*attributes)
    attributes.each do |attribute|
      it "#{attribute.to_s} attribute should be unique" do
        expect(model.class._validators).to have_key(attribute)
        expect(model.class._validators[attribute].any?{|x| x.class == ActiveRecord::Validations::UniquenessValidator}).to eq true
      end
    end
  end
end
