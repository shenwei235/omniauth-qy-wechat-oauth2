require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class QyWechat < OmniAuth::Strategies::OAuth2
      option :name, "qy_wechat"

      option :client_options, {
        site:          "https://qyapi.weixin.qq.com",
        authorize_url: "https://open.weixin.qq.com/connect/oauth2/authorize#wechat_redirect",
        token_url:     "/cgi-bin/gettoken",
        token_method:  :get
      }

      option :authorize_params, {scope: "snsapi_base"}

      option :token_params, {parse: :json}

      option :agentid, 'hahah'

      info do
        { }
      end

      extra do
        {raw_info: raw_info}
      end

      def request_phase
        params = client.auth_code.authorize_params.merge(redirect_uri: callback_url).merge(authorize_params)
        params["appid"] = params.delete("client_id")
        redirect client.authorize_url(params)
      end

      def auth_hash
        hash = AuthHash.new(
          provider: name,
          code:     request.params['code'],
          corpid:   client.id,
          agentid:  options.agentid
        )
        hash
      end

      def raw_info
        { }
      end

      protected

      def build_access_token
        class AccessToken
          def expired?
            false
          end
        end.new
      end

    end
  end
end
