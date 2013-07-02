module Storenvy
  module Template
    def get_templates(params)
      get("/v1/store/templates", params)
    end

    def update_template(id, params)
      put("/v1/store/templates/#{id}", params)
    end
  end
end

