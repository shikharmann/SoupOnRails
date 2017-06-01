ActiveAdmin.register User do

  permit_params :name, email_attributes: [:address]

  includes :email

  filter :email_activated, as: :check_boxes, collection: [true, false]
  filter :name_in, as: :string, label: 'Name'

  actions :all, except: [:edit, :update, :delete, :destroy]

  index do
    column :id do |user|
      link_to user.id, admin_user_path(user.id)
    end
    column :name do |user|
      link_to user.name, admin_user_path(user.id)
    end
    column :email do |user|
      link_to user.email.addws, admin_email_path(user.email.id)
    end
    column :activated do |user|
      user.email.activated
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs :name, name: 'Details'
    f.inputs :address, name: 'Email', for: [:email, f.object.email || Email.new]
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email do |user|
        user.email.address
      end
      row :created_at
    end
  end

end