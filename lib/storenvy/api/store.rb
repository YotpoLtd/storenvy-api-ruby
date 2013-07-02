module Storenvy
  module Store
    def current_store(params)
      get("/v1/store", params)
    end

    def update_store(params)
      put("/v1/store", params)
    end

  end
end

