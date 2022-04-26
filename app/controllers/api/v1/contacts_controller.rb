class Api::V1::ContactsController < Api::V1::ApiController

  before_action :set_contact, only: [:show, :update, :destroy]
  before_action :require_authorization!, only: [:show, :update, :destroy]

  # Lista todos os contatos do usuário logado.
  # GET /api/v1/contacts
  def index
    @contacts = current_user.contacts
    render json: @contacts
  end

  # Mostra um contato especifico.
  # GET /api/v1/contacts/1
  def show
    render json: @contact
  end

  # Cria um novo contato.
  # POST /api/v1/contacts
  def create
    @contact = Contact.new(contact_params.merge(user: current_user))

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # Atualiza um contato especifico.
  # PATCH/PUT /api/v1/contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # Deleta um contato especifico.
  # DELETE /api/v1/contacts/1
  def destroy
    @contact.destroy
  end

  private
  # Seta o contato que sera manipulado.
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Para permitir que o usuário envie um contato com os parametros especificados.
  # Only allow a trusted parameter "white list" through.
  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :description)
  end

  # Verifica se o usuário logado é o dono do contato.
  def require_authorization!
    render json: {}, status: :forbidden unless current_user == @contact.user
  end
end