ActiveAdmin.register User do
  menu :parent => "admin_menu", :label => proc {I18n.t(:menu_users)}, :if => proc{ can? :manage, User }
  
  permit_params :preference_wf_stage, :email, :password, :password_confirmation, :name, workgroup_ids: [], role_ids: []

  # Remove all action items
  config.clear_action_items!

  ###########
  ## Index ##
  ###########

  filter :name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  index :download_links => false do
    selectable_column
    id_column
    column :name
    column :email
    column I18n.t(:workgroups) do |user|
         user.get_workgroups.join(", ")
    end
    column I18n.t(:roles) do |user|
         user.get_roles.join(", ")
    end
    column :created_at
    column :active do |user|
      user.active? ? status_tag( "yes", :ok  ) : status_tag( "no"  )
      user.active?
    end
    actions
  end
  
  sidebar :actions, :only => :index do
    render :partial => "activeadmin/filter_workaround"
    render :partial => "activeadmin/section_sidebar_index"
  end
 
  # Include the folder actions
  include FolderControllerActions
  
  ##########
  ## Show ##
  ##########

  show do
    attributes_table do
      row :name
      row :email
      row I18n.t(:workgroups) do |n|
             user.workgroups.map(&:name).join(", ").html_safe
      end
      row I18n.t(:roles) do |user|
           user.get_roles.join(", ")
      end
      row :sign_in_count
      row :created_at
      row :updated_at
    end
  end
  
  sidebar :actions, :only => :show do
    render :partial => "activeadmin/section_sidebar_show", :locals => { :item => user }
  end
  
  ##########
  ## Edit ##
  ##########

  form do |f|
    f.inputs I18n.t(:user_details) do
      f.input :name
      f.input :email

      if can? :update, User
        f.input :password
        f.input :password_confirmation
      end
      if can? :manage, User
        f.input :workgroups, as: :select, multiple: true, collection: Workgroup.all.sort_by {|w| w.name} 
        f.input :roles, as: :select, multiple: false, collection: Role.all
        f.input :preference_wf_stage, as: :select, multiple: false, collection: [:inprogress, :published, :deleted]
      end
    end
  end
  
  sidebar :actions, :only => [:edit, :new, :update] do
    render :partial => "activeadmin/section_sidebar_edit", :locals => { :item => user }
  end

end
