module Storenvy
  module User
    def current_user(params)
      get("/v1/me", params)
    end
  end
end

