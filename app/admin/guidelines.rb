ActiveAdmin.register_page "guidelines" do
  menu :parent => "guidelines_menu", :label => proc {I18n.t(:menu_guidelines)}, :priority => 1
  
  controller do
    def index
      @guidelines = Guidelines.new("#{Rails.root}/public/help/#{RISM::MARC}/guidelines.yml", session[:locale])
    end
  end
  
  content title: proc{ I18n.t(:menu_guidelines)} do
    render partial: 'content'
  end
  
  ###########
  ## Index ##
  ###########
  
  sidebar :toc, :class => "sidebar_tabs", :only => [:index] do
    # no idea why the I18n.locale is not set by set_locale in the ApplicationController
    I18n.locale = session[:locale]
    render("sidebar") # Calls a partial
  end
  
end