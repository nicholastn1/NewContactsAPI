module Api::V1
  class ApiController < ApplicationController
    # Olha se o token é válido para o sistema (baseado no email e/ou senha). E seta uma variavel para o usuário.
    acts_as_token_authentication_handler_for User
    # Caso seja mandado um token invalido essa funcao sera responsavel para autenticar baseado no current_user.
    before_action :require_authentication!

    private
    def require_authentication!
      # Lanca uma exceção caso o usuário não esteja logado.
      throw(:warden, scope: :user) unless current_user.presence
    end
  end
end