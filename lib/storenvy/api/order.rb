module Storenvy
  module Order

    #def update_account(params)
    #  request = {
    #      account: {
    #        minisite_website_name: params[:minisite_website_name],
    #        minisite_website: params[:minisite_website],
    #        minisite_subdomain: params[:minisite_subdomain],
    #        minisite_cname: params[:minisite_cname],
    #        minisite_subdomain_active: params[:minisite_subdomain_active]
    #      },
    #      utoken: params[:utoken]
    #  }
    #  app_key = params[:app_key]
    #  put("/apps/#{app_key}", request)
    #end

    def get_orders(params)
      get("/v1/orders", params)
    end

  end
end

