module Storenvy
  module Product
    def get_products(params)
      get("/v1/products", params)
    end

    def create_product(params)
      post("/v1/products", params)
    end

    def get_product(product_id, params)
      get("/v1/products/#{product_id}", params)
    end

    def update_product(product_id, params)
      put("/v1/products/#{product_id}", params)
    end

    def delete_product(product_id, params)
      delete("/v1/products/#{product_id}", params)
    end
  end
end

