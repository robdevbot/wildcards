class CardsController < ApplicationController

  require "braintree"
  
  def index
    @cards = Card.all
  end
  
  def show
    @card = Card.find(params[:id])
  end
  
  
  def client_token
    render :plain => Braintree::ClientToken.generate
  end
  
  
  def checkout
    @card = Card.find(params[:id])
  end
  
  
  def purchase
    
    neworder = Order.create(
      card_id: params[:id],
      name: params[:name],
      address_line_1: params[:address_line_1],
      address_line_2: params[:address_line_2],
      city: params[:city],
      state_abbr: params[:state_abbr],
      zip_code: params[:zip_code]
    )

    method = Braintree::PaymentMethod.create(
      :customer_id => "50004195",
      :payment_method_nonce => params[:nonce]
    )

    sale = Braintree::Transaction.sale(
      :amount => params[:price].to_f,
      :payment_method_token => method.payment_method_nonce,
      :options => {
        :submit_for_settlement => true
      }
    )

    redirect_to "/orders/#{neworder.id}/confirmation"

  end
end