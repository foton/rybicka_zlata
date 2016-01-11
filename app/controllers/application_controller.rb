class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  before_action :authenticate_user!, except: [:home,:change_locale]
  before_action :set_locale
  around_filter :user_time_zone, :if => :current_user

  def set_locale
    I18n.locale = params[:locale] || (current_user && current_user.locale) || I18n.default_locale
  end

  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end

  
  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone || RybickaZlata4::Application.config.time_zone, &block) 
  end


  #TODO:  move it to module
  #---------- Exception handling --------------------
  #First should be common exception and after it there are specific exceptions
  #last "rescue" in chain is evaluated first
  
  rescue_from Exception do |exception|
    begin
      params_to_show= params.to_yaml
    rescue
      params_to_show=params.to_s.encode("utf-8")
    end

    short_version=false
    headers=request.headers.to_s rescue ""
    message=""
    message+="EXCEPTION[#{exception.class.name}]: #{exception}"
    message+="\n CURRENT_USER: #{current_user.to_s}"
    message+="\n PARAMS: #{params_to_show}" unless short_version
    message+="\n REQUEST.BODY: #{request.body.to_s}" unless short_version
    message+="\n z adresy:#{ request.remote_ip } \n\n na: #{request.referer}"
    message+="\nDOTAZ (#{params[:action]}) NA: #{request.url}"
    message+="\n\nPARAMS: #{params_to_show}" unless short_version
    message+="\nHEADERS:#{headers}"
    message+="\n\nBACKTRACE: #{exception.backtrace.join("\n")}" unless short_version
    message+="\n\nEXCEPTION[#{exception.class.name}]: #{exception}"
    logger.debug(message)
    puts(message)

    predmet=("#{exception}")[0..50]
    RybickaZlata4::Application.inform_admin(message, "VYJIMKA: #{predmet}")
    
    respond_to do |format|
      format.html {
        if Rails.env.include?("development") || Rails.env.include?("test") || (!current_user.blank? && current_user.admin?)
          render text: "#{exception.message} -- #{exception.class}<br/>#{exception.backtrace.join("<br/>")}", status: :internal_server_error
        else
          render file: "#{Rails.root}/public/500", formats: [:html], status: :internal_server_error, layout: false
        end
      }
      format.xml { head :internal_server_error }
      format.json { head :internal_server_error }
      format.js { head :internal_server_error }
    end
  end
  
  rescue_from User::NotAuthorized do |exception|
    msg = exception.message.blank? ? "Nejste oprávněni zobrazit si požadovanou stránku či provést požadovanou akci (s těmito parametry)." : exception.message
    respond_to do |format|
      format.html { 
        flash[:error]=msg
        redirect_to (request.referer || root_path)
      }
      format.xml { head :forbidden }
      format.json { head :forbidden }
    end
  end

  rescue_from ActiveRecord::RecordNotFound, AbstractController::ActionNotFound do |exception|
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", formats: [:html], status: :not_found }
      format.xml { head :not_found }
      format.json { head :not_found }
    end
  end


  
  def after_sign_in_path_for(resource)
    my_page_path(resource)
  end

end
