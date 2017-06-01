ActiveAdmin.register Email do

  menu false
  actions :all, except: [:edit, :update, :delete, :destroy]

  show do
    attributes_table do
      row :id
      row :address
      row :activated
      row :resend
      row :created_at
    end
  end

end