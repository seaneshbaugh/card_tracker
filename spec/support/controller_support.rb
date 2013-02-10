module ControllerSupport
  def login
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:user)
    end
  end

  def create_params(model)
    model.class.accessible_attributes.reject{ |key| key.blank? }.inject({}){ |params, attribute| params[attribute.to_sym] = model.send(attribute.to_sym); params }
  end
end
