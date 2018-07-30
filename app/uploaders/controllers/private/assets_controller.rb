module Private
  class AssetsController < BaseController
    skip_before_action :auth_member!, only: [:index]

    def index
      @eur_assets  = Currency.assets('eur')
      @usd_assets  = Currency.assets('usd')
      @gbp_assets  = Currency.assets('gbp')
      @btc_proof   = Proof.current :btc
      @eur_proof   = Proof.current :eur
      @usd_proof   = Proof.current :usd
      @gbp_proof   = Proof.current :gbp

      if current_user
        @btc_account = current_user.accounts.with_currency(:btc).first
        @eur_account = current_user.accounts.with_currency(:eur).first
        @usd_account = current_user.accounts.with_currency(:usd).first
        @gbp_account = current_user.accounts.with_currency(:gbp).first
      end
    end

    def partial_tree
      account    = current_user.accounts.with_currency(params[:id]).first
      @timestamp = Proof.with_currency(params[:id]).last.timestamp
      @json      = account.partial_tree.to_json.html_safe
      respond_to do |format|
        format.js
      end
    end

  end
end
